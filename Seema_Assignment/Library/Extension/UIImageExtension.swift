//
//  UIImageViewExtension.swift
//  HomeEscape
//
//  Created by Devubha Manek on 8/18/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

extension UIImageView {
    func changeImageColor(color:UIColor) -> UIImage{
        image = image!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        return image!
    }
    
    
    func load(url: URL,strName: String) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        if strName != "" {
                            let success = saveImage(image: image, strName: strName)
                        }
                    }
                }
            }
        }
    }
    
}






