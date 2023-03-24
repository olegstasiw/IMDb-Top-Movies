//
//  Extension+XCTestCase.swift
//  IMDb Top MoviesTests
//
//  Created by Oleh Stasiv on 24.03.2023.
//

import XCTest

extension XCTestCase {

    public func assertObjectWillDealloc(_ file: StaticString = #filePath, line: UInt = #line, createObject: () -> AnyObject) {
        weak var weakReference: AnyObject?

        autoreleasepool {
            let strongReference = createObject()
            if let viewController = strongReference as? UIViewController {
                _ = viewController.view
            }
            weakReference = strongReference
        }

        XCTAssertNil(weakReference, "weak reference not cleaned up, there may be a retain cycle", file: file, line: line)
    }
}

