//
//  RandomPhotosViewController.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 18.01.2022.
//

import UIKit
import AudioToolbox

final class RandomPhotosViewController: UIViewController {

    // MARK: - Props
   var viewModel: RandomPhotosViewModelProtocol!
   weak var router: Router?

    // MARK: - UI Props
    private lazy var photosCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(
            RandomPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: RandomPhotoCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .white
        collectionView.toAutolayout()
        collectionView.contentInset.top = 8
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private lazy var searchField: UISearchTextField = {
        let field = UISearchTextField()
        field.layer.cornerRadius = 10
        field.rightViewMode = .always
        field.placeholder = "Search for a photo"
        let magnifierImage = UIImage(systemName: "magnifyingglass")
        let magnifierImageView = UIImageView(image: magnifierImage)
        magnifierImageView.tintColor = .gray
        field.leftView = magnifierImageView
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.keyboardType = .webSearch
        field.addTarget(self, action: #selector(searchQueryChanged(sender:)), for: .editingChanged)
        return field
    }()

    // MARK: - Init
    init(withViewModel viewModel: RandomPhotosViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.collectionViewProvider = { [weak photosCollection] in
            return photosCollection ?? UICollectionView()
        }

        self.viewModel.errorOccurs = { [weak self] error in
            self?.alert(error: error)
        }
        
        photosCollection.dataSource = viewModel.dataSource
        setupAutoLayout()
        viewModel.getRandomPhotos()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Setting constraints
    private func setupAutoLayout() {
        view.addSubview(searchField)
        view.addSubview(photosCollection)
        // --Search field layout
        NSLayoutConstraint.activate ([
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchField.heightAnchor.constraint(equalToConstant: 35)
        ])
        // --CollectionView layout
        NSLayoutConstraint.activate([
            photosCollection.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            photosCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photosCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photosCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewFlowLayoutDelegate's methods.
extension RandomPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (view.frame.width / 2) - 0.5
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.25
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let viewModel = viewModel.prepareViewModelForDetailsScreen(forPhotoAtIndexPath: indexPath)
        router?.showDetailsViewController(withViewModel: viewModel)
        searchField.endEditing(false)
    }
}

// MARK: - TextField delegate's methods.
extension RandomPhotosViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              !text.isEmpty else {
                  textField.endEditing(false)
                  return true
              }
        viewModel.searchPhotos(withKeyword: text)
        textField.endEditing(false)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.getRandomPhotos()
        return true
    }
}

// MARK: - Search call
extension RandomPhotosViewController {
    @objc func searchQueryChanged(sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel.searchPhotos(withKeyword: text)
    }
}

