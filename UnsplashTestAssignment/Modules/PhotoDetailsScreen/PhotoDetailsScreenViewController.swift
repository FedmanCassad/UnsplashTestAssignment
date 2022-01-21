//
//  PhotoDetailsScreen.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 20.01.2022.
//

import UIKit
import Kingfisher

protocol FavoritesViewControllerDelegate: AnyObject {
    func notifyNeedsUpdateState()
}

final class PhotoDetailsViewController: UIViewController {

    // MARK: - Props
    private var labelHeight: CGFloat = 35
    let viewModel: PhotoDetailsScreenViewModelProtocol!
    weak var router: Router?

    // MARK: - UI props
    lazy var photoImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.toAutolayout()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var authorTitleLabel: UILabel =  {
        let label = getLabelConfiguredLabel()
        label.text = "Author name:"
        label.textAlignment = .right
        return label
    }()

    lazy var authorNameLabel = getLabelConfiguredLabel()
    lazy var dateCreatedTitleLabel: UILabel =  {
        let label = getLabelConfiguredLabel()
        label.text = "Created at:"
        label.textAlignment = .right
        return label
    }()

    lazy var dateCreatedLabel = getLabelConfiguredLabel()
    lazy var downloadsCountTitleLabel: UILabel = {
        let label = getLabelConfiguredLabel()
        label.text = "Downloads:"
        label.textAlignment = .right
        return label
    }()

    lazy var downloadsCountLabel = getLabelConfiguredLabel()

    lazy var locationTitleLabel: UILabel = {
        let label = getLabelConfiguredLabel()
        label.text = "Location:"
        label.textAlignment = .right
        return label
    }()

    lazy var addToFavoritesButton: UIButton = {
        let button = UIButton()
        button.toAutolayout()
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

    lazy var locationLabel = getLabelConfiguredLabel()

    // MARK: - Init
    init(withViewModel model: PhotoDetailsScreenViewModelProtocol) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAutoLayout()
        configureUIByViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            router?.notifyDetailsViewControllerDismissed(detailsViewController: self)
        }
    }


    // MARK: - Private methods
    private func getLabelConfiguredLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.toAutolayout()
        return label
    }

    private func configureUIByViewModel() {
        photoImage.kf.setImage(
            with: viewModel.urls[UnsplashPhotoModel.URLType.regular.rawValue],
            placeholder: R.image.imagePlaceholder(),
            options: [.transition(.flipFromLeft(0.3))]
        )
        authorNameLabel.text = viewModel.author
        dateCreatedLabel.text = viewModel.dateCreated
        downloadsCountLabel.text = String(viewModel.downloadsCount)
        locationLabel.text = viewModel.locationTitle
        addToFavoritesButton.tintColor = viewModel.buttonColor
        addToFavoritesButton.addTarget(self, action: #selector(addToFavorites(_:)), for: .touchUpInside)
    }

    // MARK: - Setting UI elements position
    private func setupAutoLayout() {
        [
            photoImage, authorTitleLabel, authorNameLabel, dateCreatedTitleLabel,
            dateCreatedLabel, downloadsCountLabel, downloadsCountTitleLabel,
            locationLabel, locationTitleLabel, addToFavoritesButton
        ] .forEach { view.addSubview($0) }

        // -- Photo view
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            photoImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            photoImage.heightAnchor.constraint(equalTo: photoImage.safeAreaLayoutGuide.widthAnchor)
        ])

        // -- Author title label
        NSLayoutConstraint.activate([
            authorTitleLabel.leadingAnchor.constraint(equalTo: photoImage.leadingAnchor),
            authorTitleLabel.trailingAnchor.constraint(equalTo: photoImage.centerXAnchor, constant: -30),
            authorTitleLabel.topAnchor.constraint(equalTo: photoImage.bottomAnchor),
            authorTitleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

        // -- Author label
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: photoImage.centerXAnchor),
            authorNameLabel.trailingAnchor.constraint(equalTo: photoImage.trailingAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: photoImage.bottomAnchor),
            authorNameLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

        // -- Date created title label
        NSLayoutConstraint.activate([
            dateCreatedTitleLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.leadingAnchor),
            dateCreatedTitleLabel.trailingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor),
            dateCreatedTitleLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor),
            dateCreatedTitleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

        // -- Date created label
        NSLayoutConstraint.activate([
            dateCreatedLabel.leadingAnchor.constraint(equalTo: photoImage.centerXAnchor),
            dateCreatedLabel.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
            dateCreatedLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor),
            dateCreatedLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

        // -- Downloads count title label
        NSLayoutConstraint.activate([
            downloadsCountTitleLabel.leadingAnchor.constraint(equalTo: dateCreatedTitleLabel.leadingAnchor),
            downloadsCountTitleLabel.trailingAnchor.constraint(equalTo: dateCreatedTitleLabel.trailingAnchor),
            downloadsCountTitleLabel.topAnchor.constraint(equalTo: dateCreatedTitleLabel.bottomAnchor),
            downloadsCountTitleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

        // -- Downloads count label
        NSLayoutConstraint.activate([
            downloadsCountLabel.leadingAnchor.constraint(equalTo: photoImage.centerXAnchor),
            downloadsCountLabel.trailingAnchor.constraint(equalTo: dateCreatedLabel.trailingAnchor),
            downloadsCountLabel.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor),
            downloadsCountLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

        // -- Location title label
        NSLayoutConstraint.activate([
            locationTitleLabel.leadingAnchor.constraint(equalTo: downloadsCountTitleLabel.leadingAnchor),
            locationTitleLabel.trailingAnchor.constraint(equalTo: downloadsCountTitleLabel.trailingAnchor),
            locationTitleLabel.topAnchor.constraint(equalTo: downloadsCountTitleLabel.bottomAnchor),
            locationTitleLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

        // --Location label
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: photoImage.centerXAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: downloadsCountLabel.trailingAnchor),
            locationLabel.topAnchor.constraint(equalTo: downloadsCountLabel.bottomAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])

        // --Add to favorites button
        NSLayoutConstraint.activate([
            addToFavoritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToFavoritesButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 40),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 50),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Button function
    @objc func addToFavorites(_ sender: UIButton) {
        viewModel.buttonTapped()
        router?.notifyUpdateStates()
    }

    // MARK: - UI sync. Actually just used to sync addToFavoritesButton's tintColor with viewModel
    func notifyNeedsUpdateState() {
        viewModel.updateState()
        addToFavoritesButton.tintColor = viewModel.buttonColor
    }
}
