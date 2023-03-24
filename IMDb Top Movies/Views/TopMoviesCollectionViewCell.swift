//
//  TopMoviesCollectionViewCell.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import Combine
import UIKit

class TopMoviesCollectionViewCell: UICollectionViewCell, Reusable {

    private struct Constants {
        static let rankSize: CGFloat = 50
        static let movieImageViewWidth: CGFloat = 150
        static let movieImageViewPadding: CGFloat = 5
        static let iMDbRankViewWidth: CGFloat = 50
        static let iMDbRankViewHeight: CGFloat = 30
        static let iMDbRankViewPadding: CGFloat = 5
        static let titleLabelPadding: CGFloat = 10
    }

    lazy var rankView: UIView = {
        let rankView = UIView().withAutoLayout()
        rankView.backgroundColor = .customBackgroundColor
        rankView.addShadow()
        rankView.cornered(cornerRadius: 5)
        return rankView
    }()

    lazy var rankLabel: UILabel = {
        let label = UILabel().withAutoLayout()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
                                       weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView().withAutoLayout()
        imageView.addShadow()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "placeholderMovie")
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel().withAutoLayout()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize,
                                         weight: .medium)
        return label
    }()

    lazy var iMDbRankView: UIView = {
        let rankView = UIView().withAutoLayout()
        rankView.backgroundColor = .white
        rankView.addShadow()
        rankView.cornered(cornerRadius: 5)
        return rankView
    }()

    lazy var iMDbRankLabel: UILabel = {
        let label = UILabel().withAutoLayout()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize,
                                       weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    var viewModel: TopMoviesCollectionViewCellViewModelProtocol?
    weak var errorDelegate: ErrorDelegate?
    private var cancellable = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        self.backgroundColor = .cardBackgroundColor
        addSubviews()
        setupConstraints()
        setupBindings()
    }

    func setupData(movie: Movie, indexPath: IndexPath) {
        setupCell()
        rankLabel.text = movie.rank
        titleLabel.text = movie.title
        iMDbRankLabel.text = movie.imDbRating
        setUpImageView(id: movie.id + "small", imageURL: movie.image, indexPath: indexPath)
    }

    private func addSubviews() {
        addSubview(movieImageView)
        addSubview(rankView)
        rankView.addSubview(rankLabel)
        addSubview(titleLabel)
        addSubview(iMDbRankView)
        iMDbRankView.addSubview(iMDbRankLabel)
    }

    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: [
            movieImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.movieImageViewPadding),
            movieImageView.widthAnchor.constraint(equalToConstant: Constants.movieImageViewWidth),
            rankView.topAnchor.constraint(equalTo: topAnchor, constant: -Constants.rankSize / 4),
            rankView.leftAnchor.constraint(equalTo: leftAnchor, constant: -Constants.rankSize / 4),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleLabelPadding),
            titleLabel.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: Constants.titleLabelPadding),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.titleLabelPadding),
            iMDbRankView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.iMDbRankViewPadding),
            iMDbRankView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.iMDbRankViewPadding)
        ])
        constraints += movieImageView.constraintsToFillSuperviewVertically(topMargin: Constants.movieImageViewPadding, bottomgMargin: -Constants.movieImageViewPadding)
        constraints += rankLabel.constraintsToFillSuperview()
        constraints += iMDbRankLabel.constraintsToFillSuperview()
        constraints += rankView.constraintsWidthAndHeight(width: Constants.rankSize, height: Constants.rankSize)
        constraints += iMDbRankView.constraintsWidthAndHeight(width: Constants.iMDbRankViewWidth, height: Constants.iMDbRankViewHeight)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupBindings() {
        viewModel?.error
            .sink { [weak self] error in
                guard let error = error else { return }
                self?.errorDelegate?.showError(error: error)
            }
            .store(in: &cancellable)
    }
    
    private func setUpImageView(id: String, imageURL: String, indexPath: IndexPath) {
        self.tag = indexPath.item
        guard let url = URLBuilder.shared.buildSmallImageResizeURL(imageURL: imageURL) else { return }
        if let cached = viewModel?.getImageDataFromCache(id: id) {
            DispatchQueue.main.async {
                if self.tag == indexPath.item {
                    self.movieImageView.image = UIImage(data: cached)
                }
            }
        } else {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    if self.tag == indexPath.item {
                        self.viewModel?.saveImageDataToCache(id: id, url: url.absoluteString, data: data)
                        self.movieImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
