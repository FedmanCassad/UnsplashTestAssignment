//
//  FavoritesCellViewModel.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 20.01.2022.
//

import Foundation

protocol FavoritesCellViewModelProtocol {
    init(withPhotoModel model: UnsplashPhotoModel)

    // Just a data provided to a view to display it.
    var url: URL { get }
    var author: String { get }
}

final class FavoritesCellViewModel: FavoritesCellViewModelProtocol {
    let photo: UnsplashPhotoModel

    init(withPhotoModel model: UnsplashPhotoModel) {
        photo = model
    }

    var url: URL {
        photo.urls[UnsplashPhotoModel.URLType.small.rawValue]!
    }

    var author: String {
        photo.user.name
    }
}
