//
//  MovieDetailsViewControllerTests.swift
//  IMDb Top MoviesTests
//
//  Created by Oleh Stasiv on 24.03.2023.
//

import XCTest
@testable import IMDb_Top_Movies
import UIKit

class MovieDetailsViewControllerTests: XCTestCase {
    
    func testDealloc() {
        assertObjectWillDealloc {
            return createMovieDetailsViewController(viewModel: createViewModel(movie: MockData.mockMovie,
                                                                               urlBuider: URLBuilder.shared,
                                                                               cacheManager: CoreDataManager.shared))
        }
    }
    
    func testScrollView() {
        let viewModel = createViewModel()
        let vc = createMovieDetailsViewController(viewModel: viewModel)
        _ = vc.view
        
        XCTAssertNotNil(vc.view.subviews.first as? UIScrollView)
        XCTAssertEqual(vc.view.backgroundColor, .customBackgroundColor)
    }
    
    
    func testHierarchyOfViews() throws {
        let viewModel = createViewModel()
        let vc = createMovieDetailsViewController(viewModel: viewModel)
        _ = vc.view
        
        let stack = try XCTUnwrap(vc.view.subviews.first?.subviews.first as? UIStackView)
        XCTAssertEqual(stack.axis, .vertical)
        XCTAssertEqual(stack.spacing, 5)
        
        let horizontalStack = try XCTUnwrap(stack.arrangedSubviews.first as? UIStackView)
        XCTAssertEqual(horizontalStack.axis, .horizontal)
        XCTAssertEqual(horizontalStack.spacing, 5)
        
        XCTAssertNotNil(horizontalStack.arrangedSubviews.first as? UIImageView)
        XCTAssertNotNil(horizontalStack.arrangedSubviews.last as? UIStackView)
    }
    
    func testInfoStackView() throws {
        let viewModel = createViewModel()
        let vc = createMovieDetailsViewController(viewModel: viewModel)
        _ = vc.view
        
        let stack = try XCTUnwrap(vc.view.subviews.first?.subviews.first as? UIStackView)
        let horizontalStack = try XCTUnwrap(stack.arrangedSubviews.first as? UIStackView)
        let infoStack = try XCTUnwrap(horizontalStack.arrangedSubviews.last as? UIStackView)
        
        XCTAssertEqual((infoStack.arrangedSubviews[0] as? UILabel)?.text, "Info")
        XCTAssertEqual((infoStack.arrangedSubviews[2] as? UILabel)?.text, "Crew: Test crew")
        XCTAssertEqual((infoStack.arrangedSubviews[3] as? UILabel)?.text, "Year: 2023")
        XCTAssertEqual((infoStack.arrangedSubviews[4] as? UILabel)?.text, "IMBd rank: 9.0")
        XCTAssertEqual((infoStack.arrangedSubviews[5] as? UILabel)?.text, "Voted 1000 times")
    }
    
    func testContingLettersInTitle() throws {
        let viewModel = createViewModel()
        let vc = createMovieDetailsViewController(viewModel: viewModel)
        _ = vc.view

        XCTAssertEqual(vc.title, "Title")
        let mainStack = try XCTUnwrap(vc.view.subviews.first?.subviews.first as? UIStackView)
        let stack = try XCTUnwrap(mainStack.arrangedSubviews.last as? UIStackView)
        XCTAssertEqual((stack.arrangedSubviews[0] as? UILabel)?.text, "Total count - 5")
        XCTAssertEqual((stack.arrangedSubviews[1] as? UILabel)?.text, "Letter t is repeated 2 times.")
        XCTAssertEqual((stack.arrangedSubviews[2] as? UILabel)?.text, "Letter i is repeated 1 time.")
        XCTAssertEqual((stack.arrangedSubviews[3] as? UILabel)?.text, "Letter l is repeated 1 time.")
        XCTAssertEqual((stack.arrangedSubviews[4] as? UILabel)?.text, "Letter e is repeated 1 time.")
    }
    
    private func createMovieDetailsViewController(viewModel: MovieDetailsViewModelProtocol) -> MovieDetailsViewController {
        return MovieDetailsViewController(viewModel: viewModel)
    }
    
    private func createViewModel(movie: Movie = MockData.mockMovie,
                                 urlBuider: URLBuilderProtocol = FakeURLBuilder(),
                                 cacheManager: CoreDataManagerProtocol = FakeCacheManager()) -> MovieDetailsViewModelProtocol {
        return MovieDetailsViewModel(movie: movie, urlBuider: urlBuider, cacheManager: cacheManager)
    }
}
