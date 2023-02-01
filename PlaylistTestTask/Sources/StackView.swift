//
//  StackView.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

final class StackView: UIStackView {
    
    // MARK: - Views
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.title
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }().setupAutoLayout()
    
    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.font =  Constants.Fonts.subtitle
        label.textColor = .gray
        return label
    }().setupAutoLayout()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupHierachy()
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Settings
    private func setupHierachy() {
        [title,
         subtitle].forEach { addArrangedSubview($0) }
    }
    
    private func setupView() {
        self.alignment = .leading
        self.distribution = .equalSpacing
        self.spacing = 4
        self.axis = .vertical
    }
    
}
