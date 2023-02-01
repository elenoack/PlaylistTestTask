//
//  ViewControllerKeyboardListene.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

protocol ViewControllerKeyboardListener: AnyObject {
    func keyboardShown(keyboardSize: CGRect, duration: CGFloat)
    func keyboardHide(duration: CGFloat)
    var keyboardObservers: [NSObjectProtocol] { get set }
}

extension ViewControllerKeyboardListener where Self: UIViewController {

    func subscribeToKeyboardNotification() {
        let willShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil, queue: nil
        ) { [weak self] notification in
            self?.keyboardWillShow(notification: notification)
        }

        let willHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil, queue: nil
        ) { [weak self] notification in
            self?.keyboardWillHide(notification: notification)
        }

        keyboardObservers = [willShowObserver, willHideObserver]
    }

    func unsubscribeFromKeyboard() {
        let center = NotificationCenter.default
        keyboardObservers.forEach { center.removeObserver($0) }
    }

    func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
                            as? NSNumber)?.doubleValue ?? 0.25
            keyboardShown(keyboardSize: keyboardSize, duration: duration)
        }
    }

    func keyboardWillHide(notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                        as? NSNumber)?.doubleValue ?? 0.25
        keyboardHide(duration: duration)
    }

}

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboardView() {
        view.endEditing(true)
        if let navController = self.navigationController {
            navController.view.endEditing(true)

        }
    }

}
