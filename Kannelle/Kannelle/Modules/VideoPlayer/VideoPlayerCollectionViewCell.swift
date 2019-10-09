//
//  VideoPlayerCollectionViewCell.swift
//  Kannelle
//
//  Created by Sebastien Gohier on 09/10/2019.
//  Copyright © 2019 Sebastien Gohier. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImagePreview: UIImageView!

    func configureCell(url: URL) {
        // Generate a thumbnail image from the video
        // Resize the image
        // Display the image in the cell
        AVAsset(url: url).generateThumbnail { [weak self] (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self?.videoImagePreview.image = image.imageWith(newSize: CGSize(width: 90, height: 160))
            }
        }
    }
}
