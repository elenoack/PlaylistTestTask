//
//  UITextField+Extension.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

extension UITextField {
    
    func setLeftIcon(_ image: UIImage?) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
        iconView.image = image
        iconView.tintColor = .gray
        let iconContainerView: UIView = UIView(frame: CGRect(x: 30, y: 0, width: 40, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
}
