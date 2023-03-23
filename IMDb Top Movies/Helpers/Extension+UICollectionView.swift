//
//  Extension+UICollectionView.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import UIKit

public extension UICollectionView {

    func dequeueReusableCell<T: UICollectionViewCell>(withCustomReuseIdentifier reuseIdentifier: String = T.reuseIdentifier, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else { fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)") }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T where T: Reusable {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { fatalError("Could not dequeue supplementary view with identifier: \(T.reuseIdentifier)") }
        return view
    }
    
    func register<T: UICollectionViewCell>(_: T.Type, forCellWithCustomReuseIdentifier reuseIdentifier: String = T.reuseIdentifier) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind elementKind: String) where T: Reusable {
        register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }
}

