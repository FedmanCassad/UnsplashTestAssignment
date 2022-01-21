//
//  Router.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 21.01.2022.
//

import UIKit

/// Simple router.
final class Router {
    var photosSectionNavigationController: UINavigationController!
    var favoritesSectionNavigationController: UINavigationController!
    weak var tabBarController: UITabBarController?

    private var pushedDetailsViewControllers: [PhotoDetailsViewController] = []

    func notifyDetailsViewControllerDismissed(detailsViewController viewController: PhotoDetailsViewController) {
        pushedDetailsViewControllers.removeAll { $0 === viewController }
    }

    func showDetailsViewController(withViewModel viewModel: PhotoDetailsScreenViewModelProtocol) {
        let detailsViewController = PhotoDetailsViewController(withViewModel: viewModel)
        detailsViewController.router = self
        tabBarController?.selectedIndex == 0
        ? photosSectionNavigationController.pushViewController(detailsViewController, animated: true)
        : favoritesSectionNavigationController.pushViewController(detailsViewController, animated: true)
        pushedDetailsViewControllers.append(detailsViewController)
    }

    /// Used to notify pushed details view controllers to update UI.
    func notifyUpdateStates() {
        pushedDetailsViewControllers.forEach {
            $0.notifyNeedsUpdateState()
        }
    }
}
