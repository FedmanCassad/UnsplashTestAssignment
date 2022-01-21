//
//  FavoritesCell.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 20.01.2022.
//

import Kingfisher
import UIKit

final class FavoritesCell: UITableViewCell {

    // Identifier for registering
    static let identifier = String(describing: FavoritesCell.self)

    // MARK: - Props
    var viewModel: FavoritesCellViewModelProtocol!

    // MARK: - UI props
    lazy var smallPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutolayout()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.toAutolayout()
        return label
    }()

    // MARK: - Configuring cell method
    func configure(withViewModel viewModel: FavoritesCellViewModelProtocol) {
        self.viewModel = viewModel
        smallPhoto.kf.setImage(
            with: viewModel.url,
            placeholder: R.image.imagePlaceholder(),
            options: [.transition(.fade(0.3))]
        )
        authorLabel.text = viewModel.author
        contentView.backgroundColor = .systemGray3.withAlphaComponent(0.2)
        setupAutoLayout()
    }

    // MARK: - Layout
    private func setupAutoLayout() {
        [smallPhoto, authorLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            smallPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            smallPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            smallPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            smallPhoto.widthAnchor.constraint(equalTo: smallPhoto.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: smallPhoto.trailingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            authorLabel.centerYAnchor.constraint(equalTo: smallPhoto.centerYAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
}
