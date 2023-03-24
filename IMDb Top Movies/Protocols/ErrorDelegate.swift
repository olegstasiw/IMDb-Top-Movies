//
//  ErrorDelegate.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 24.03.2023.
//

import Foundation

protocol ErrorDelegate: AnyObject {
    func showError(error: String)
}
