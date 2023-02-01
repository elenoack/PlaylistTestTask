//
//  PlaylistViewController.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

final class PlaylistViewController: UIViewController {
    
    // MARK: - Properties
    var keyboardObservers = [NSObjectProtocol]()
    
    private var playlistView: PlaylistView? {
        guard isViewLoaded else { return nil }
        return view as? PlaylistView
    }
    
    private lazy var viewModel = {
        PlaylistViewModel()
    }()
    
    private var index: Int?
    
    // MARK: - View Life Cycle
    override func loadView() {
        view = PlaylistView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureView()
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboard()
    }
}

// MARK: - Settings
extension PlaylistViewController: UISearchControllerDelegate, UITableViewDelegate {
    
    private func setupNavigationBar() {
        navigationItem.searchController = playlistView?.searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = Constants.Strings.navigationControllerTitle
    }
    
    private func configureView() {
        hideKeyboardWhenTappedAround()
        playlistView?.tableView.delegate = self
        playlistView?.tableView.dataSource = self
        playlistView?.titleTextField.delegate = self
        configureSearchController()
        handleCompletion()
    }
    
    private func configureSearchController() {
        playlistView?.searchController
            .hidesNavigationBarDuringPresentation = false
        playlistView?.searchController.searchResultsUpdater = self
        playlistView?.searchController.delegate = self
        playlistView?.searchController.searchBar.delegate = self
    }
    
    private func handleCompletion() {
        playlistView?.refreshCompletion = { [weak self] in
            self?.playlistView?.refreshControl.endRefreshing()
            self?.viewModel.getDefaulConfigureCell()
        }
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        playlistView?.tableView.addGestureRecognizer(longPress)
    }
}

// MARK: - UITableViewDataSource
extension PlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlistCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(for: indexPath)
                as? PlaylistCell else { return UITableViewCell() }
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellViewModel
        setupCell(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Size.tableViewHeight
    }
    
    private func setupCell(_ cell: PlaylistCell) {
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        cell.accessoryView?.tintColor = .gray
        cell.selectionStyle = .none
    }
    
}

// MARK: - UISearchResultsUpdating
extension PlaylistViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.searchBar.text.isEmptyOrNil {
            guard let text = searchController.searchBar.text else { return }
            viewModel.updateAlbums(request: .init(predicate: text))
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getDefaulConfigureCell()
    }
    
}

// MARK: - UITextFieldDelegate
extension PlaylistViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text.isEmptyOrNil {
            viewModel.updateTitle(title: textField.text ?? "", for: index ?? 0)
        }
        return textField.resignFirstResponder()
    }
    
}

// MARK: - ViewControllerKeyboardListener
extension PlaylistViewController: ViewControllerKeyboardListener {
    
    func keyboardShown(keyboardSize: CGRect, duration: CGFloat) {
        playlistView?.textFieldBottomConstraint.constant = -(keyboardSize.height + Constants.Size.titleTextFieldHeight)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(duration: CGFloat) {
        playlistView?.textFieldBottomConstraint.constant = Constants.Size.titleTextFieldHeight
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        playlistView?.titleTextField.isHidden = true
    }
    
}

// MARK: - Private Methods
extension PlaylistViewController {
    
    private func showError() {
        let action = UIAlertAction(title: Constants.Strings.alertWarning, style: .default, handler: nil)
        self.showAlert(message: viewModel.localizedError.localizedDescription,
                       actions: [action])
    }
    
    private func showPopMenu(_ indexPath: IndexPath) {
        let editAction = UIAlertAction(title: Constants.Strings.edit, style: .destructive) { [weak self] _ in
            self?.showKeyboard(indexPath)
        }
        showActionSheet(actions: [editAction])
    }
    
    private func showKeyboard(_ indexPath: IndexPath) {
        playlistView?.titleTextField.isHidden = false
        index = indexPath.row
        playlistView?.titleTextField.text = viewModel.playlistCellViewModel[indexPath.row].title
        playlistView?.titleTextField.becomeFirstResponder()
    }
    
    private func restart(action: UIAlertAction) {
        initViewModel()
    }
    
}

// MARK: - Actions
extension PlaylistViewController {
    
    @objc
    private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: playlistView?.tableView)
            if let indexPath = playlistView?.tableView.indexPathForRow(at: touchPoint) {
                showPopMenu(indexPath)
            }
        }
    }
}

// MARK: - Observing
extension PlaylistViewController {
    
    private func initViewModel() {
        viewModel.updateDate = { [weak self] in
            guard let self else { return }
            Task {
                await MainActor.run {
                    self.playlistView?.tableView.reloadData()
                }
            }
        }
        
        viewModel.failData = { [weak self] in
            guard let self else { return }
            self.showError()
        }
    }
    
}
