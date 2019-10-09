//
//  UIImage+Extension.swift
//  Kannelle
//
//  Created by Sebastien Gohier on 09/10/2019.
//  Copyright © 2019 Sebastien Gohier. All rights reserved.
//

import UIKit


extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        return image
    }
}
