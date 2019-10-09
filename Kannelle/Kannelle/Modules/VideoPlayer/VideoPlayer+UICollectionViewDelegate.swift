//
//  VideoPlayer+UICollectionViewDelegate.swift
//  Kannelle
//
//  Created by Sebastien Gohier on 09/10/2019.
//  Copyright © 2019 Sebastien Gohier. All rights reserved.
//

import UIKit
import AVFoundation

extension VideoPlayer: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VideoPlayerCollectionViewCell.self) , for: indexPath) as! VideoPlayerCollectionViewCell
        cell.configureCell(url: videos[indexPath.row])
        return cell
    }
}

extension VideoPlayer: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        noVideoSelected.isHidden = true
        resetPlayer()
        
        // When selecting a video, initialize a video player and play it
        let selectedUrl = videos[indexPath.row]
        player = AVPlayer(url: selectedUrl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer!)
        player?.seek(to: CMTime.zero)
        player?.play()
        updateUI()
    }
}
