//
//  FavoritesViewModel.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 20.01.2022.
//

import UIKit

typealias FavoritesDiffableDataSource = UITableViewDiffableDataSource<Int, UnsplashPhotoModel>
typealias FavoritesSnapshot = NSDiffableDataSourceSnapshot<Int, UnsplashPhotoModel>

protocol FavoritesScreenViewModelProtocol: AnyObject {
    ///  /// UITableViewDiffableDataSource remained visible to connect with collectionView instance at right moment.
    var dataSource: FavoritesDiffableDataSource { get }

    /// Used to retrieve reference to tableVoew without tight coupling VC <-> VM.
    var tableViewProvider: (() -> UITableView)! { get set }

    /// Fetches favorites photos from persistent store.
    func getFavorites()

    /// Removes photo from favorites (from persistent store).
    func removeFromFavorites(photoAtIndexPath indexPath: IndexPath)

    /// Simple factory method.
    /// - Returns: ViewModel for PhotoDetailsViewController.
    func  preparePhotoDetailsScreenViewModel(
        forPhotoAtIndexPath IndexPath: IndexPath) -> PhotoDetailsScreenViewModelProtocol
}

final class FavoritesScreenViewModel: FavoritesScreenViewModelProtocol {

    var tableViewProvider: (() -> UITableView)!
    let service: DataProviderFacadeProtocol = CoreDataService.shared
    var photos: [UnsplashPhotoModel] = [] {
        didSet {
            applySnapshot()
        }
    }

    private(set) lazy var dataSource: FavoritesDiffableDataSource = FavoritesDiffableDataSource(
        tableView: tableViewProvider()
    ) { [weak self] tableView, indexPath, model in
        guard let self = self,
              let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: FavoritesCell.identifier, for: indexPath
                ) as? FavoritesCell else { return UITableViewCell()}
        let viewModel = self.prepareFavoritesCellViewModel(withModel: model)
        cell.configure(withViewModel: viewModel)
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
    }

    private func prepareFavoritesCellViewModel(withModel model: UnsplashPhotoModel) -> FavoritesCellViewModelProtocol {
        let viewModel = FavoritesCellViewModel(withPhotoModel: model)
        return viewModel
    }

    private func applySnapshot() {
        dataSource.apply(prepareSnapshot(), animatingDifferences: true)
    }

    private func prepareSnapshot() -> FavoritesSnapshot {
        var snapshot = FavoritesSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(photos, toSection: 0)
        return snapshot
    }

    func getFavorites() {
        guard let CDPhotos: [CDPhoto] = service.fetchSavedPhotoModels()
        else { return }
        let photos = CDPhotos.compactMap{ UnsplashPhotoModel(fromCDPhotoModel: $0) }
        self.photos = photos
    }
    

    func removeFromFavorites(photoAtIndexPath indexPath: IndexPath) {
        service.deleteSpecificPhotoFromFavorites(byPhotoId: photos[indexPath.row].photoID)
        getFavorites()
    }

    func preparePhotoDetailsScreenViewModel(
        forPhotoAtIndexPath IndexPath: IndexPath
    ) -> PhotoDetailsScreenViewModelProtocol {
        let photoModel = photos[IndexPath.row]
        let viewModel = PhotoDetailsScreenViewModel(withPhotoModel: photoModel)
        return viewModel
    }

}
