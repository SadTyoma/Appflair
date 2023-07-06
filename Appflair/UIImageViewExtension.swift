//
//  UIImageViewExtension.swift
//  Appflair
//
//  Created by Artem Shuneyko on 5.07.23.
//

import UIKit

extension UIImageView {
    func imageFromURL(_ URLString: String?) {
        let image = UIImage(systemName: "photo")
        let size = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image?.draw(in: CGRect(origin: .zero, size: size))
        let placeHolder = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = placeHolder
        guard let URLString = URLString, let imageUrl = URL(string: URLString) else { return }
        if let cachedImage = ImageCache.shared.image(for: imageUrl.absoluteString) {
            self.image = cachedImage
        } else {
            let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.image = image
                }
                ImageCache.shared.save(image, for: imageUrl.absoluteString)
            }
            task.resume()
        }
        
    }
}
