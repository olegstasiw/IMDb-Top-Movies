//
//  TopMoviesSectionHeaderView.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 23.03.2023.
//

import UIKit

class TopMoviesSectionHeaderView: UICollectionReusableView, Reusable {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel().withAutoLayout()
        label.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize,
            weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        let margins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        NSLayoutConstraint.activate(titleLabel.constraintsToFillSuperview(margins: margins))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

