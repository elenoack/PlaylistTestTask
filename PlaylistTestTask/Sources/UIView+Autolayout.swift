//
//  UIView+Autolayout.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

protocol AutoLayoutPrepareable {
    func setupAutoLayout() -> Self
}

extension UIView: AutoLayoutPrepareable {
    func setupAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
