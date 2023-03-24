//
//  TopMoviesViewControllerTests.swift
//  IMDb Top MoviesTests
//
//  Created by Oleh Stasiv on 24.03.2023.
//

import XCTest
@testable import IMDb_Top_Movies
import UIKit

class TopMoviesViewControllerTests: XCTestCase {
    
    func testDealloc() {
        assertObjectWillDealloc {
            return createTopMoviesViewController(viewModel: createViewModel(networkManager: NetwortManager(),
                                                                            cacheManager: CoreDataManager.shared))
        }
    }
    
    func testCollectionView() throws {
        let viewModel = createViewModel()
        let vc = createTopMoviesViewController(viewModel: viewModel)
        _ = vc.view
        
        let collectionView = try XCTUnwrap(vc.view.subviews.first as? UICollectionView)
        XCTAssertEqual(collectionView.backgroundColor, UIColor.customBackgroundColor)
    }
    
    func testSearchController() {
        let viewModel = createViewModel()
        let vc = createTopMoviesViewController(viewModel: viewModel)
        _ = vc.view
        
        XCTAssertNotNil(vc.navigationItem.searchController)
    }
    
    func testResultForSearchControllerisOne() {
        let viewModel = createViewModel()
        let vc = createTopMoviesViewController(viewModel: viewModel)
        _ = vc.view
        vc.navigationItem.searchController?.searchBar.text = "ti"
        XCTAssertEqual(vc.viewModel.filteredMovies.count, 1)
    }
    
    func testResultForSearchControllerisZero() {
        let viewModel = createViewModel()
        let vc = createTopMoviesViewController(viewModel: viewModel)
        _ = vc.view
        vc.navigationItem.searchController?.searchBar.text = "nnnnnnnnnnn"
        XCTAssertEqual(vc.viewModel.filteredMovies.count, 0)
    }
    
    func testClickOnItem() {
        let viewModel = createViewModel()
        let vc = createTopMoviesViewController(viewModel: viewModel)
        _ = vc.view
        let mockNavigationController = MockUINavigationController(rootViewController: vc)
        vc.collectionView(vc.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        XCTAssertTrue(mockNavigationController.pushViewControllerIsCalled)
    }
    
    func testLoadingIndicator() {
        let viewModel = createViewModel()
        let vc = createTopMoviesViewController(viewModel: viewModel)
        XCTAssertTrue(vc.loadingIndicator.isAnimating)
        vc.viewDidLoad()
        XCTAssertFalse(vc.loadingIndicator.isAnimating)
    }
    
    private func createTopMoviesViewController(viewModel: TopMoviesViewModelProtocol) -> TopMoviesViewController {
        return TopMoviesViewController(viewModel: viewModel)
    }
    
    private func createViewModel(networkManager: NetworkService = FakeNetworkManager(),
                                 cacheManager: CoreDataManagerProtocol = FakeCacheManager()) -> TopMoviesViewModelProtocol {
        return TopMoviesViewModel(networkManager: networkManager, cacheManager: cacheManager)
    }
}
