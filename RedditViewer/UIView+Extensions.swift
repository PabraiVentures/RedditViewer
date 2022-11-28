//
//  UIView+Extensions.swift
//  RedditViewer
//
//  Created by Nathan Pabrai on 11/27/22.
//

import Foundation
import UIKit

extension UIView {
    func addSubviewIgnoringAutoresizingMask(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
    
    func addSubviewWithEqualEdgeConstraints(_ subview: UIView, constant: CGFloat = 0) {
        addSubviewIgnoringAutoresizingMask(subview)
        NSLayoutConstraint.activate([
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
        subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: constant),
        subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -constant)
        ])
    }
    
    func addSubview(_ subview: UIView, verticalPadding: CGFloat = 0, horizontalPadding: CGFloat = 0) {
        addSubviewIgnoringAutoresizingMask(subview)
        NSLayoutConstraint.activate([
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
        subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: verticalPadding),
        subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -verticalPadding)
        ])
    }
}

