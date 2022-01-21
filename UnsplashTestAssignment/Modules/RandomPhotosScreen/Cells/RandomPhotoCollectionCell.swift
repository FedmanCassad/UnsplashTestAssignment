//
//  RandomPhotoCollectionCell.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

final class RandomPhotoCollectionViewCell: UICollectionViewCell {

    /// Used for cell registering
    static let identifier: String = String(describing: RandomPhotoCollectionViewCell.self)

    private(set) var viewModel: PhotoCellViewModelProtocol!

    // MARK: - UI props
    lazy var photoView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.toAutolayout()
        return imageView
    }()

    lazy var authorTitle: UILabel = {
        let label = UILabel()
        label.toAutolayout()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 1
        label.backgroundColor = .clear
        return label
    }()

    // MARK: - Public methods
    func configure(withViewModel viewModel: PhotoCellViewModelProtocol) {
        self.viewModel = viewModel
        contentView.addSubview(photoView)
        photoView.addSubview(authorTitle)
        authorTitle.text = viewModel.authorName
        setupAutoLayout()
        viewModel.loadPhoto(forImageView: photoView)
    }

    // MARK: - UI layout
    private func setupAutoLayout() {
        // --Photo constraints
        NSLayoutConstraint.activate (
            [
                photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
                photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )

        // --Author label constraints
        NSLayoutConstraint.activate(
            [
                authorTitle.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
                authorTitle.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 2),
                authorTitle.heightAnchor.constraint(equalToConstant: 30),
                authorTitle.trailingAnchor.constraint(equalTo: photoView.trailingAnchor)
            ]
        )
    }
}
