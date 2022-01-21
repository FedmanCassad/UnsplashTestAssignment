//
//  Favorit.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 20.01.2022.
//

import UIKit

final class FavoritesViewController: UIViewController {

    // MARK: - Props.
    let viewModel: FavoritesScreenViewModelProtocol
    var delegate: FavoritesViewControllerDelegate?
    weak var router: Router?

    // MARK: - UI props.
    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.identifier)
        tableView.backgroundColor = .white
        tableView.toAutolayout()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - Init
    init(withViewModel viewModel: FavoritesScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.tableViewProvider = { [weak favoritesTableView] in
            return favoritesTableView ?? UITableView()
        }
        favoritesTableView.dataSource = viewModel.dataSource
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getFavorites()
    }

    // MARK: - Layout
    private func setupAutoLayout() {
        view.addSubview(favoritesTableView)
        NSLayoutConstraint.activate([
            favoritesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            favoritesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            favoritesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TableViewDelegate's methods
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .destructive, title: "Remove from favorites"
        ) { [weak viewModel, weak router] _, _, _ in
            viewModel?.removeFromFavorites(photoAtIndexPath: indexPath)
            router?.notifyUpdateStates()
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModel.preparePhotoDetailsScreenViewModel(forPhotoAtIndexPath: indexPath)
        router?.showDetailsViewController(withViewModel: viewModel)
    }
}
