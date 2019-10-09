//
//  VideoPlayer.swift
//  Kannelle
//
//  Created by Sebastien Gohier on 09/10/2019.
//  Copyright © 2019 Sebastien Gohier. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayer: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noVideoSelected: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var videos: [URL] = []
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Initialize the view
        resetPlayer()
        noVideoSelected.isHidden = false
        
        // Get the videos registered in Document directory
        videos = ContentManager().getLocalVideosUrl()
        
        // Refresh the list
        collectionView.reloadData()

        recordButton.isHidden = videos.count > 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    func resetPlayer() {
        player?.pause()
        videoView.layer.sublayers?.removeAll()
    }
    
    func updateUI() {
        playerLayer?.frame = videoView.bounds
        videoView.layer.sublayers?.first?.frame = videoView.bounds
    }
    
    @IBAction func didClickedPlayStopVideo() {
        
    }
}
