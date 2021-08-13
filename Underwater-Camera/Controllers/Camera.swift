//
//  Camera.swift
//  Underwater-Camera
//
//  Created by Aitor Zubizarreta Perez on 07/08/2021.
//

import UIKit
import AVFoundation

final class Camera {
    
    // MARK: - Properties
    
    static let shared = Camera() // Singleton
    private var captureSession: AVCaptureSession = AVCaptureSession()
    private var captureDevice: AVCaptureDevice?
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private var previewView: UIView?
    
    // MARK: - Methods
    
    init() {}
    
    ///
    /// Check camera permission.
    ///
    public func checkPermission() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("Camera permission: Authorized")
            return true
            //self.setupCameraSession()
        case .notDetermined:
            print("Camera permission: Not Determined")
            self.askCameraPermission()
            return false
        case .denied:
            print("Camera permission: Denied")
            return false
        case .restricted:
            print("Camera permission: Restricted")
            return false
        default:
            print("Camera permission: ¿Default?")
            return false
        }
    }
    
    ///
    /// Ask permission to the user to access the camera.
    ///
    private func askCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if granted {
                print("Permission granted.")
            } else {
                print("The user has NOT granted access to the camera.")
            }
        }
    }
    
    ///
    /// Setup the view to display the camera output image.
    ///
    public func setupCameraOutput(previewView: UIView) {
        self.previewView = previewView
        
        self.setupCameraSession()
    }
    
    ///
    /// Setup the AVCameraSession.
    ///
    private func setupCameraSession() {
        // Create the Capture Session.
        self.captureSession = AVCaptureSession()
        
        // Find a list of cameras from the Device.
        let discoverSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera],
                                                               mediaType: .video,
                                                               position: .back)
        let devices = discoverSession.devices
                
        // Check if there are any cameras and if so select the first one.
        if !devices.isEmpty {
            self.captureDevice = devices.first
            self.displayCameraOutput()
        } else {
            print("No cameras")
        }
    }
    
    ///
    /// Display the image from the selected camera.
    ///
    public func displayCameraOutput() {
        guard let videoCaptureDevice = self.captureDevice,
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              self.captureSession.canAddInput(videoDeviceInput),
              let previewView = self.previewView else { return }
                
        // Add the device input  to the session.
        self.captureSession.addInput(videoDeviceInput)
                
        // Start the session.
        self.captureSession.startRunning()
                
        // Add the PreviewLayer (video data output) to the view.
        self.previewLayer.session = self.captureSession
        self.previewLayer.videoGravity = .resizeAspectFill
        
        previewView.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = previewView.frame
    }
    
}
