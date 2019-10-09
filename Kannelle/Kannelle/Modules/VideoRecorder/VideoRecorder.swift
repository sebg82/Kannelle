//
//  VideoRecorder.swift
//  Kannelle
//
//  Created by Sebastien Gohier on 09/10/2019.
//  Copyright © 2019 Sebastien Gohier. All rights reserved.
//

import UIKit

class VideoRecorder: UIViewController {
    
    @IBOutlet weak var message: UIVisualEffectView!
    @IBOutlet weak var cameraViewContainer: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    // 
    weak var cameraView: CameraView?
    var timer = Timer()
    var seconds: Double = 0
    let context = CIContext()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCameraView()
        message.alpha = 0
    }
    
    @IBAction func didClickedStartStopRecording() {
        if cameraView?.isRecording ?? false {
            cameraView?.stopRecording()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
            let dateString = dateFormatter.string(from: Date())
            
            let fileURL = C.documentsURL.appendingPathComponent("\(dateString).mov")
            cameraView?.startRecording(to: fileURL)
        }
    }
    
    private func initCameraView() {
        let camera = CameraView(frame: view.bounds)
        camera.delegate = self
        camera.inputVideoAvailable = true
        camera.inputAudioAvailable = true
//        camera.outputVideoAvailable = true
        camera.outputFrameVideoAvailable = true
        camera.startRunning()
        cameraView = camera
        cameraViewContainer.addSubview(camera)
    }
}
