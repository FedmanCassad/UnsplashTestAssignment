//
//  RandomPhotosViewModel.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 18.01.2022.
//

import UIKit

typealias UnsplashPhotosDataSource = UICollectionViewDiffableDataSource<Int, UnsplashPhotoModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<Int, UnsplashPhotoModel>

protocol RandomPhotosViewModelProtocol {

    /// UICollectionViewDataSource remained visible to connect with collectionView instance at right moment.
    var dataSource: UnsplashPhotosDataSource? { get }

    /// Callback to notify viewController to display an error.
    var errorOccurs: ((ErrorDomain) -> Void)? { get set }

    /// Used to retrieve reference to collectionView without tight coupling VC <-> VM.
    var collectionViewProvider: (() -> UICollectionView)! { get set }

    /// Loads an array of random photo models.
    func getRandomPhotos()

    /// Simple factory method to get Deatails view controller view model
    /// - Returns: viewModel for instantiating PhotoDetailsViewController
    func prepareViewModelForDetailsScreen(
        forPhotoAtIndexPath indexPath: IndexPath
    ) -> PhotoDetailsScreenViewModelProtocol

    /// Uses to get array of photo models by remotePhotoService.
    func searchPhotos(withKeyword keyword: String)
}

final class RandomPhotosViewModel: RandomPhotosViewModelProtocol {

    var errorOccurs: ((ErrorDomain) -> Void)?
    let photoService: networkPhotoService = UnsplashService()
    var collectionViewProvider: (() -> UICollectionView)!
    var photosModels: [UnsplashPhotoModel] = [] {
        didSet {
            prepareAndApplySnapshot()
        }
    }

    lazy var dataSource: UnsplashPhotosDataSource?  = {
        UnsplashPhotosDataSource(collectionView: collectionViewProvider()) { [weak self] collectionView, indexPath, _ in
            guard let self = self else { return UICollectionViewCell() }
            let viewModel: PhotoCellViewModelProtocol = PhotoCellViewModel(
                withPhotoModel: self.photosModels[indexPath.item]
            )
            guard let cell = collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: RandomPhotoCollectionViewCell.identifier,
                        for: indexPath
                    ) as? RandomPhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(withViewModel: viewModel)
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            return cell
        }
    }()


    func getRandomPhotos() {
        photoService.getRandomPhotosModels(ofCount: 30) { [weak self] result in
            switch result {
            case let .failure(error):
                self?.errorOccurs?(error)
            case let .success(photos):
                self?.photosModels = photos
            }
        }
    }

    func prepareViewModelForDetailsScreen(
        forPhotoAtIndexPath indexPath: IndexPath
    ) -> PhotoDetailsScreenViewModelProtocol {
        return PhotoDetailsScreenViewModel(withPhotoModel: photosModels[indexPath.item])
    }

    private func prepareAndApplySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(photosModels, toSection: 0)
        dataSource?.apply(snapshot)
    }

    func searchPhotos(withKeyword keyword: String) {
        photoService.getPhotosByKeyword(keyword: keyword) { [weak self] result in
            switch result {
            case  .failure(let error):
                self?.errorOccurs?(error)
            case .success(let searchModel):
                let photos = searchModel.results.compactMap { UnsplashPhotoModel(fromSearchedPhotoModel: $0) }
                self?.photosModels = photos
            }
        }
    }
}
