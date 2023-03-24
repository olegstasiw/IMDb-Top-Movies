//
//  StackViewSpacerView.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 24.03.2023.
//

import UIKit

public class StackViewSpacerView: UIView {

    public init(axis: NSLayoutConstraint.Axis, minimumSpace: CGFloat) {
        super.init(frame: CGRect.zero)
        setContentHuggingPriority(.defaultLow, for: axis)
        let anchor = (axis == .vertical ? heightAnchor : widthAnchor)
        let constraint = anchor.constraint(greaterThanOrEqualToConstant: minimumSpace)
        constraint.priority =  UILayoutPriority(rawValue: 999)
        constraint.isActive = true
        isAccessibilityElement = false
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
