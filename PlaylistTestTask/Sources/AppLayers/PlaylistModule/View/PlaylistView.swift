//
//  PlaylistView.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

final class PlaylistView: UIView {
    
    // MARK: - Properties
    var textFieldBottomConstraint = NSLayoutConstraint()
    
    // MARK: - Views
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Constants.Strings.searchControllerPlaceholder
        return searchController
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(PlaylistCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .gray
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                        #selector(handleRefresh),
                                     for: UIControl.Event.valueChanged)
        tableView.tintColor = UIColor.systemGray2
        return tableView
    }().setupAutoLayout()

    lazy var titleTextField = TitleTextField(with: Constants.Strings.title).setupAutoLayout()
    
    // MARK: - Action
    var refreshCompletion: (() -> Void)?
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
}

// MARK: - Settings
extension PlaylistView {
    
    private func setupView() {
        titleTextField.setLeftIcon(UIImage(systemName: "pencil"))
        backgroundColor = .systemBackground
        titleTextField.isHidden = true
    }
    
    private func setupHierarchy() {
        [tableView,
         titleTextField].forEach { addSubview($0) }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: Constants.Size.titleTextFieldHeight)
        ])
        
        textFieldBottomConstraint = titleTextField.topAnchor.constraint(equalTo: bottomAnchor)
        textFieldBottomConstraint.isActive = true
    }
    
}

// MARK: - Private
extension PlaylistView {
    
    @objc
    private func handleRefresh() {
        refreshCompletion?()
    }
    
}
