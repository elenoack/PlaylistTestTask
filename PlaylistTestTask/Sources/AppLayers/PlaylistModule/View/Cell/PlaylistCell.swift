//
//  PlaylistCell.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

fileprivate enum Metrics {
    static let albumImageRadius: CGFloat = 8
    static let insets: CGFloat = 18
    static let albumImageSize: CGFloat = 100
}

final class PlaylistCell: UITableViewCell {

    // MARK: - Properties
    var cellViewModel: PlaylistCellViewModel? {
        didSet {
            guard let cellViewModel else { return }
            stackView.title.text = cellViewModel.title
            stackView.subtitle.text = cellViewModel.subtitle
            setupImage(imageURL: cellViewModel.image)
        }
    }

    // MARK: - Views
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }().setupAutoLayout()
    
    private lazy var albumImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = Metrics.albumImageRadius
        image.clipsToBounds = true
        image.backgroundColor = .systemGray6
        image.contentMode = .scaleAspectFill
        return image
    }().setupAutoLayout()
    
    private lazy var stackView = StackView().setupAutoLayout()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImage.image = nil
        stackView.title.text = nil
        stackView.subtitle.text = nil
    }
}

// MARK: - Private methods
extension PlaylistCell {
    
    private func setupHierarchy() {
        [albumImage,
         activityIndicatorView,
         stackView].forEach { addSubview($0) }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            albumImage.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.insets),
            albumImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.insets),
            albumImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.insets),
            albumImage.widthAnchor.constraint(equalTo: albumImage.heightAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: albumImage.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: albumImage.centerYAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: albumImage.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor,
                                               constant: Metrics.insets),
            stackView.rightAnchor.constraint(equalTo: rightAnchor,
                                             constant: -Metrics.insets)
        ])
    }
    
}

// MARK: - Private
extension PlaylistCell {
    
    func setupImage(imageURL: String) {
        Task {
            do {
                activityIndicatorView.startAnimating()
                try await albumImage.setImage(with: imageURL)
                activityIndicatorView.stopAnimating()
            } catch {
                albumImage.image = UIImage(named: "imageNotAvailable")
            }
        }
    }
    
}
