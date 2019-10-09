//
//  VideoRecorder+AVCaptureFileOutputRecordingDelegate.swift
//  Kannelle
//
//  Created by Sebastien Gohier on 09/10/2019.
//  Copyright © 2019 Sebastien Gohier. All rights reserved.
//

import AVKit


extension VideoRecorder: AVCaptureFileOutputRecordingDelegate {
    
    
    @objc func updateTimer() {
        // TODO show a label with the elapsed time
        seconds += 1
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        recordButton.setTitle("STOP", for: .normal)
        UIApplication.shared.isIdleTimerDisabled = true
        seconds = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        recordButton.setTitle("START", for: .normal)
        
        UIApplication.shared.isIdleTimerDisabled = false
        timer.invalidate()
        
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)

        self.navigationController?.popViewController(animated: true)
    }

}

extension VideoRecorder: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        // It is where I check if the image is too dark
        // TODO check the brightness only for 1 image by second
        if (cgImage.isDark) {
            DispatchQueue.main.async {
                self.message.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.message.alpha = 0
                }
            }
        }
    }
}
