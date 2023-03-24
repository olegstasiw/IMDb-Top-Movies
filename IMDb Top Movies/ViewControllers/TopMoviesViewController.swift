//
//  TopMoviesViewController.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 22.03.2023.
//

import Combine
import UIKit

class TopMoviesViewController: UIViewController {

    private enum Section: String {
        case main = "Top 10"
    }

    private struct Constants {
        static let itemEdgeInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)
        static let sectionEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        static let itemHeight: CGFloat = 240
        static let itemCountForIphone = 1
        static let itemCountForIpad = 2
        static let itemCornerRadius: CGFloat = 10
        static let navigationTitle = "IMDb Movies"
        static let searchPlaceholder = "Search Movies"
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, video) -> UICollectionViewCell? in
                guard let strongSelf = self else { return nil }
                let cell: TopMoviesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.viewModel = TopMoviesCollectionViewCellViewModel()
                cell.errorDelegate = self
                cell.addShadow()
                cell.cornered(cornerRadius: Constants.itemCornerRadius)
                let movie = strongSelf.searchController.isActive
                ? strongSelf.viewModel.filteredMovies[indexPath.item]
                : strongSelf.viewModel.movies[indexPath.item]
                cell.setupData(movie: movie, indexPath: indexPath)
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
        collectionView.delegate = self
        return collectionView
    }()

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView().withAutoLayout()
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    private var searchController = UISearchController(searchResultsController: nil)

    var viewModel: TopMoviesViewModelProtocol
    private var cancellable = Set<AnyCancellable>()

    init(viewModel: TopMoviesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupConstraints()
        registerCells()
        configureLayout()
        setupBindings()
        configureSearchController()
        viewModel.fetchData { [weak self] in
            guard let strongSelf = self, !strongSelf.viewModel.movies.isEmpty else {
                self?.loadingIndicator.stopAnimating()
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.applySnapshot()
                strongSelf.loadingIndicator.stopAnimating()
            }
        }
    }

    @objc private func didPullToRefresh(_ sender: Any) {
        viewModel.fetchData {  [weak self] in
            guard let strongSelf = self, !strongSelf.viewModel.movies.isEmpty else { return }
            DispatchQueue.main.async {
                self?.applySnapshot()
            }
        }
        refreshControl.endRefreshing()
    }

    private func setupBindings() {
        viewModel.error
            .sink { [weak self] error in
                guard let error = error else { return }
                self?.showToast(with: error)
            }
            .store(in: &cancellable)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = Constants.navigationTitle
    }

    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        collectionView.backgroundColor = .customBackgroundColor
    }
    
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints += loadingIndicator.constraintsToBeCenteredInSuperview()
        constraints += collectionView.constraintsToFillSuperview()
        NSLayoutConstraint.activate(constraints)
    }

    private func registerCells() {
        collectionView.register(TopMoviesCollectionViewCell.self)
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        let movies = searchController.isActive ? viewModel.filteredMovies : viewModel.movies
        snapshot.appendItems(movies, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension TopMoviesViewController: UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movies = searchController.isActive ? viewModel.filteredMovies : viewModel.movies
        let viewModel = MovieDetailsViewModel(movie: movies[indexPath.item])
        let controller = MovieDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TopMoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filteredMovies = filteredItems(for: searchController.searchBar.text)
        applySnapshot()
    }
    
    func filteredItems(for queryOrNil: String?) -> [Movie] {
        viewModel.filteredMovies.removeAll()
        let items = viewModel.movies
        guard let query = queryOrNil, !query.isEmpty else { return items }

        return items.filter { item in
            let matches = item.title.lowercased().contains(query.lowercased())
            return matches
        }
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchPlaceholder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension TopMoviesViewController: ErrorDelegate {
    func showError(error: String) {
        self.showToast(with: error)
    }
}
