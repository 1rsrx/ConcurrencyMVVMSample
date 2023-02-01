//
//  ViewController.swift
//  ConcurrencyMVVMSample
//
//  Created by Hikaru Kuroda on 2023/01/29.
//

import UIKit
import Combine

class SearchRepositoryViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repositoryTableView: UITableView!
    private var loadingLabel: UILabel!

    private var viewModel: SearchRepositoryViewModel!
    private var cancellables: [AnyCancellable] = []
    private let repositoryTableViewCellIdentifier = "RepositoryTableViewCell"

    override func loadView() {
        let view = UINib(nibName: "SearchRepositoryView", bundle: nil)
            .instantiate(withOwner: self).first! as! UIView
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SearchRepositoryViewModel()
        setupView()
        bind()
    }

    private func setupView() {
        searchBar.delegate = self

        repositoryTableView.register(
            UINib(nibName: "RepositoryTableViewCell", bundle: nil),
            forCellReuseIdentifier: repositoryTableViewCellIdentifier
        )
        repositoryTableView.dataSource = self

        loadingLabel = UILabel()
        loadingLabel.text = "通信中"
        loadingLabel.textColor = .black
        loadingLabel.isHidden = true
        view.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func bind() {
        viewModel.$repositories
            .sink { [weak self] in
                self?.reloadRepositoryTableView($0)
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .sink { [weak self] in
                self?.showAlert(title: "エラー", message: $0)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .sink { [weak self] in
                self?.toggleItemHidden(by: $0)
            }
            .store(in: &cancellables)
    }

    private func reloadRepositoryTableView(_ repositories: [Repository]) {
        self.repositoryTableView.reloadData()
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "閉じる", style: .default)
        alert.addAction(closeAction)
        self.present(alert, animated: true)
    }

    private func toggleItemHidden(by isLoading: Bool) {
        self.repositoryTableView.isHidden = isLoading
        self.loadingLabel.isHidden = !isLoading
    }
}

extension SearchRepositoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: repositoryTableViewCellIdentifier,
            for: indexPath
        ) as! RepositoryTableViewCell

        let repository = viewModel.repositories[indexPath.row]
        cell.configureWith(repository: repository)

        return cell
    }
}

extension SearchRepositoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.onSearchTextChanged(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)

        Task {
            await viewModel.onSearchButtonTapped()
        }

    }
}
