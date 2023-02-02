//
//  Alert+Extensions.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String? = Constants.Strings.ок,
                   message: String? = nil,
                   actions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: Constants.Strings.ок, style: .default, handler: nil))
        }

        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String? = nil,
                         message: String? = nil,
                         showCancel: Bool = true,
                         actions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        if showCancel {
            let cancelAction = UIAlertAction(title: Constants.Strings.hide, style: .cancel)
            alert.addAction(cancelAction)
        }
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.permittedArrowDirections = []
        
        present(alert, animated: true, completion: nil)
    }
    
}
