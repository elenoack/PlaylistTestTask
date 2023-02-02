//
//  UITableView+Reuse.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

protocol ReusableView: UIView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

extension UITableViewCell: ReusableView {}

extension UITableView {
    
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(
        for indexPath: IndexPath
    ) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier,
                                   for: indexPath) as? T ?? T()
    }
    
}
