//
//  UIKitHelpers.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import UIKit

extension UIView {
    func toAutolayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIViewController {
    func alert(error: ErrorDomain) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: error.description.title,
                message: error.description.message,
                preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
