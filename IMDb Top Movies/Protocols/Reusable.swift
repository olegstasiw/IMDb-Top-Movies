//
//  Reusable.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import UIKit

public protocol Reusable: AnyObject {
    
    static var reuseIdentifier: String { get }
}

public extension Reusable where Self: UIView {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
