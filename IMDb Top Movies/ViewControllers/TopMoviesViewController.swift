//
//  TopMoviesViewController.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 22.03.2023.
//

import UIKit

class TopMoviesViewController: UIViewController {

    private enum Section: String {
        case main = "Top 10"
    }

    private struct Constants {
        static let itemEdgeInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        static let sectionEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        static let itemHeight: CGFloat = 240
        static let itemCountForIphone = 1
        static let itemCountForIpad = 2
        static let itemCornerRadius: CGFloat = 10
        static let navigationTitle = "IMDb Movies"
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, video) -> UICollectionViewCell? in
                let cell: TopMoviesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.addShadow()
                cell.cornered(cornerRadius: Constants.itemCornerRadius)
                // setup Cell
                cell.setupCell()
                return cell
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let view: TopMoviesSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            view.titleLabel.text = section.rawValue
            return view
        }
        return dataSource
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                collectionViewLayout: UICollectionViewFlowLayout()).withAutoLayout()
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        return collectionView
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    var viewModel: TopMoviesViewModelProtocol

    init(viewModel: TopMoviesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didPullToRefresh(_ sender: Any) {
        // fetchData
        refreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .customBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constants.navigationTitle
        configureCollectionView()
        registerCells()
        configureLayout()
        setupBindings()

        viewModel.fetchData()
    }

    private func setupBindings() {
        viewModel.dataDidChange = { [weak self] viewModel in
            self?.applySnapshot()
        }
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate(collectionView.constraintsToFillSuperview())
    }

    private func registerCells() {
        collectionView.register(TopMoviesCollectionViewCell.self)
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.movies, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension TopMoviesViewController {
    private func configureLayout() {
        collectionView.register(TopMoviesSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(Constants.itemHeight)
            )
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let itemCount = isPhone ? Constants.itemCountForIphone : Constants.itemCountForIpad

            let item = NSCollectionLayoutItem(layoutSize: size)
            item.contentInsets = Constants.itemEdgeInsets
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = Constants.sectionEdgeInsets

            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(1)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
}
