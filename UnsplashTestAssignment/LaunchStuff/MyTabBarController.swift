//
//  MyTabBarController.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 18.01.2022.
//

import UIKit

final class MyCustomTabBarController: UITabBarController {
    var router = Router()

    override func viewDidLoad() {
        super.viewDidLoad()
       setupTabBar()
    }

    // -- Just encapsulated tabBar configuring process.
    private func setupTabBar()  {
        let photosGalleryVC = RandomPhotosViewController(withViewModel: RandomPhotosViewModel())
        photosGalleryVC.title = "Photos"
        let photosNavigationController = UINavigationController(rootViewController: photosGalleryVC)
        photosNavigationController.tabBarItem.tag = 0
        photosNavigationController.tabBarItem.image = UIImage(systemName: "rectangle.on.rectangle.square.fill")
        let favoritesVC = FavoritesViewController(withViewModel: FavoritesScreenViewModel())
        favoritesVC.title = "Favorites"
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesVC)
        favoritesNavigationController.tabBarItem.tag = 1
        favoritesNavigationController.tabBarItem.image = UIImage(systemName: "hand.thumbsup.fill")
        viewControllers = [photosNavigationController, favoritesNavigationController]
        favoritesNavigationController.overrideUserInterfaceStyle = .light
        overrideUserInterfaceStyle = .light
        router.photosSectionNavigationController = photosNavigationController
        router.tabBarController = self
        router.favoritesSectionNavigationController = favoritesNavigationController
        photosGalleryVC.router = router
        favoritesVC.router = router
    }


}
