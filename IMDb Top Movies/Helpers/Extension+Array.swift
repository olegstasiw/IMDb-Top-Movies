//
//  Extension+Array.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 24.03.2023.
//
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
