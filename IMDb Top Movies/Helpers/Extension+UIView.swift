//
//  Extension+UIView.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import UIKit

public extension UIView {
    
    func withAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func addShadow(masksToBounds: Bool = false,
                   shadowOffset: CGSize = .zero,
                   shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOpacity: Float = 0.2,
                   shadowRadius: CGFloat = 4) {
        layer.masksToBounds = masksToBounds
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func cornered(cornerRadius: CGFloat = 10) {
        layer.cornerRadius = cornerRadius
    }
    
    func constraintsToFillSuperview(margins: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        let horizontally = constraintsToFillSuperviewHorizontally(leadingMargin: margins.left, trailingMargin: -margins.right)
        let vertically = constraintsToFillSuperviewVertically(topMargin: margins.top, bottomgMargin: -margins.bottom)
        
        return horizontally + vertically
    }
    
    func constraintsToFillSuperviewHorizontally(leadingMargin: CGFloat, trailingMargin: CGFloat) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("This view does not have a superview: \(self)")
        }
        let left = leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leadingMargin)
        let right = trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailingMargin)
        
        return [left, right]
    }

    func constraintsToFillSuperviewVertically(topMargin: CGFloat, bottomgMargin: CGFloat) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("This view does not have a superview: \(self)")
        }
        let top = topAnchor.constraint(equalTo: superview.topAnchor, constant: topMargin)
        let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomgMargin)
        
        return [top, bottom]
    }
}
