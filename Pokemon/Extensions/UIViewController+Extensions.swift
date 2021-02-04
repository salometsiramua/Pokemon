//
//  UIViewController+Extensions.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/4/21.
//

import UIKit

extension UIViewController {
    func showAlert(with error: Error) {
        stopIndicatingActivity()
        let message = (error as? NetworkError)?.description ?? error.localizedDescription
        let alert = UIAlertController(title: "Error occured", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    struct Holder {
        static var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    }
        
    var indicator: UIActivityIndicatorView {
        get {
            return Holder.activityIndicatorView
        }
        
        set (newValue){
            Holder.activityIndicatorView = newValue
        }
        
    }

    // MARK: - Acitivity Indicator
    func startIndicatingActivity() {
        DispatchQueue.main.async {
            self.view.addSubview(self.indicator)
            self.indicator.pin(to: self.view, directions: [.centerX, .centerY])
            self.indicator.startAnimating()
        }
    }

    func stopIndicatingActivity() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
    }
}
