//
//  RandomPhotoCellViewModel.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit
import Kingfisher

protocol PhotoCellViewModelProtocol {

    /// Asynchronously loads photo into provided image view
    func loadPhoto(forImageView imageView: UIImageView)

    /// Must be initialized with UnsplashPhotoModel.
    init(withPhotoModel: UnsplashPhotoModel)

    /// Text data to display
    var authorName: String? { get }
}

final class PhotoCellViewModel: PhotoCellViewModelProtocol {

    let photoModel: UnsplashPhotoModel
    let service: networkPhotoService = UnsplashService()
    var authorName: String? {
        photoModel.user.name
    }

    init(withPhotoModel photoModel: UnsplashPhotoModel) {
        self.photoModel = photoModel
    }
    
    func loadPhoto(forImageView imageView: UIImageView) {
        imageView.kf.setImage(
            with: photoModel.urls[UnsplashPhotoModel.URLType.small.rawValue],
            placeholder: R.image.imagePlaceholder(),
            options: [.transition(.flipFromBottom(0.3))]
        )
    }
}
