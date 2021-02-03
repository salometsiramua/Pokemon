//
//  Extensions.swift
//  Pokemon
//
//  Created by Salome Tsiramua on 2/2/21.
//

import UIKit

extension UIView {
    class var identifier: String {
        return String(describing: self)
    }
    
    func pin(to view: UIView, edgeInsets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeInsets.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeInsets.right).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: edgeInsets.top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -edgeInsets.bottom).isActive = true
    }
    
    func pinToTop(to view: UIView, edgeInsets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeInsets.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeInsets.right).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: edgeInsets.top).isActive = true
    }
    
    func pinToBottom(to view: UIView, edgeInsets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeInsets.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeInsets.right).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -edgeInsets.bottom).isActive = true
    }
    
    func pinToEdges(to view: UIView, edgeInsets: UIEdgeInsets = .zero) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeInsets.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeInsets.right).isActive = true
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension String {
    var pokemonsIndex: String? {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

extension UIViewController {
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "calcel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
