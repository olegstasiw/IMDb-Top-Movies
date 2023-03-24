//
//  MockUINavigationController.swift
//  IMDb Top MoviesTests
//
//  Created by Oleh Stasiv on 24.03.2023.
//

@testable import IMDb_Top_Movies
import UIKit

class MockUINavigationController: UINavigationController {
    private(set) var pushViewControllerIsCalled = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerIsCalled = true
        super.pushViewController(viewController, animated: animated)
    }
}
