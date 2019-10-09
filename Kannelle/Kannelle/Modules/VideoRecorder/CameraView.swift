//
//  CameraView.swift
//  Kannelle
//
//  Created by Sebastien Gohier on 09/10/2019.
//  Copyright © 2019 Sebastien Gohier. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol CameraViewDelegate: AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {}

class CameraView: UIView {
    
    weak var delegate: (AVCaptureFileOutputRecordingDelegate & AVCaptureVideoDataOutputSampleBufferDelegate)?
    
    var inputVideoAvailable: Bool = false { didSet { if inputVideoAvailable { let _ = inputVideo }}}
    var inputAudioAvailable: Bool = false { didSet { if inputAudioAvailable { let _ = inputAudio }}}
    var outputFrameVideoAvailable: Bool = false { didSet { if outputFrameVideoAvailable { let _ = outputFrameVideo }}}
    var outputVideoAvailable: Bool = false { didSet { if outputVideoAvailable { let _ = outputVideo }}}
    
    private lazy var inputVideo: AVCaptureDeviceInput? = {
        if let deviceVideo = AVCaptureDevice.default(for: AVMediaType.video),
            let input = try? AVCaptureDeviceInput(device: deviceVideo),
            captureSesssion.canAddInput(input) {
            do {
                try deviceVideo.lockForConfiguration()
                deviceVideo.exposureMode = .autoExpose //autoWhiteBalance
                let gain = deviceVideo.deviceWhiteBalanceGains
                print("*** gain: \(gain)")
                deviceVideo.unlockForConfiguration()
            } catch {}
            captureSesssion.addInput(input)
            return input
        }
        return nil
    }()
    private lazy var inputAudio: AVCaptureDeviceInput? = {
        if let deviceAudio = AVCaptureDevice.default(for: AVMediaType.audio),
            let input = try? AVCaptureDeviceInput(device: deviceAudio),
            captureSesssion.canAddInput(input) {
            captureSesssion.addInput(input)
            return input
        }
        return nil
    }()
    private lazy var outputVideo: AVCaptureMovieFileOutput? = {
        let output = AVCaptureMovieFileOutput()
        if captureSesssion.canAddOutput(output) {
            output.connection(with: .video)?.videoOrientation = .portrait
            captureSesssion.addOutput(output)
            return output
        }
        return nil
    }()
    private lazy var outputFrameVideo: AVCaptureVideoDataOutput? = {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "sample buffer"))
        if captureSesssion.canAddOutput(output) {
            output.connection(with: .video)?.videoOrientation = .portrait
            captureSesssion.addOutput(output)
            return output
        }
        return nil
    }()
    private lazy var captureSesssion: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        session.sessionPreset = .hd1280x720
        return session
    }()
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let pl = AVCaptureVideoPreviewLayer(session: captureSesssion)
        pl.videoGravity = AVLayerVideoGravity.resizeAspectFill
        pl.frame = bounds
        if let orientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue) {
            pl.connection?.videoOrientation = orientation
        }
        layer.addSublayer(pl)
        pl.connection?.videoOrientation = .portrait
        return pl
    }()
    
    deinit {
        captureSesssion.stopRunning()
        previewLayer.removeFromSuperlayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI(frame: layer.frame, interfaceOrientation: nil)
    }
}


// MARK: Public methods
extension CameraView {
    
    var isRecording: Bool {
        return outputVideo?.isRecording ?? false
    }
    
    func updateUI(frame: CGRect, interfaceOrientation: UIInterfaceOrientation?) {
        self.frame = frame
        layer.frame = frame
        previewLayer.frame = frame
        
        if let interfaceOrientation = interfaceOrientation,
            interfaceOrientation.isPortrait || interfaceOrientation.isLandscape,
            let orientation = interfaceOrientation.videoOrientation {
            previewLayer.connection?.videoOrientation = orientation
            outputVideo?.connection(with: .video)?.videoOrientation = orientation
        }
    }
    
    func startRunning() {
        DispatchQueue.main.async { [weak self] in
            self?.captureSesssion.startRunning()
        }
    }
    
    func stopRunning() {
        DispatchQueue.main.async { [weak self] in
            self?.captureSesssion.stopRunning()
        }
    }
    
    func startRecording(to filePath: URL) {
        guard let delegate = delegate else { return }
        outputVideo?.maxRecordedDuration = CMTime(seconds: 180, preferredTimescale: 30) // 30fps
        outputVideo?.startRecording(to: filePath, recordingDelegate: delegate)
    }
    
    func stopRecording() {
        outputVideo?.stopRecording()
    }
    
}

//#endif
