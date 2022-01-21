//
//  PhotoDetailsViewModel.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 20.01.2022.
//

import UIKit

protocol PhotoDetailsScreenViewModelProtocol: AnyObject {

    /// Must be initialized with UnsplashPhotoModel
    init(withPhotoModel model: UnsplashPhotoModel)

    // Just the data for visual representation by View(ViewController)
    var author: String { get }
    var dateCreated: String { get }
    var locationTitle: String { get }
    var downloadsCount: Int { get }
    var urls: [String: URL] { get }
    var isFavoritePhoto: Bool { get }
    var buttonColor: UIColor { get }

    /// Handles add to favorites logic.
    func buttonTapped()
    
    // Used to update addToFavoritesButton tintColor
    func updateState()
}

final class PhotoDetailsScreenViewModel: PhotoDetailsScreenViewModelProtocol {
    private let photo: UnsplashPhotoModel
    let coreDataService: DataProviderFacadeProtocol = CoreDataService.shared

    init(withPhotoModel model: UnsplashPhotoModel) {
        photo = model
    }

    var isFavoritePhoto: Bool {
       let photo = coreDataService.getSpecificPhoto(byID: photo.photoID)
        return photo != nil
    }

    var author: String {
        photo.user.name
    }

    var dateCreated: String {
        guard let date = photo.date else {
            return "Undefined"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.string(from: date)
    }

    var locationTitle: String {
        photo.location.title ?? "Undefined"
    }

    var downloadsCount: Int {
        photo.downloadsCount
    }

    var urls: [String : URL] {
        photo.urls
    }

    private(set) lazy var buttonColor: UIColor = isFavoritePhoto ? .green : .red

    func buttonTapped() {
        if isFavoritePhoto {
            coreDataService.deleteSpecificPhotoFromFavorites(byPhotoId: photo.photoID)
        } else {
            coreDataService.savePhotoModel(photo)
        }
        updateState()
    }

    func updateState() {
        buttonColor = isFavoritePhoto ? .green : .red
    }
}
