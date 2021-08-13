//
//  Camera.swift
//  Underwater-Camera
//
//  Created by Aitor Zubizarreta Perez on 07/08/2021.
//

import UIKit
import AVFoundation

protocol CameraPermissionHandler {
    func handleCameraPermission(completion: @escaping (_ error: PermissionError?) -> Void)
}

enum PermissionError: Error {
    // Throw when the user denied the permission.
    case denied
    
    // Throw when the user can't grant access due to restrictions.
    case restricted
}

extension PermissionError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .denied: return "User denied permission."
        case .restricted: return "User can't grant access due to restrictions."
        }
    }
    
}

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

// MARK: - Camera Permission Handler

extension Camera: CameraPermissionHandler {
    
    func handleCameraPermission(completion: @escaping (PermissionError?) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            print("Authorized")
            completion(nil)
        case .notDetermined:
            print("Not determined")
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    print("Permission granted.")
                    completion(nil)
                } else {
                    print("The user has NOT granted access to the camera.")
                    completion(.denied)
                }
            }
        case .denied:
            print("Denied")
            completion(.denied)
        case .restricted:
            print("Restricted")
            completion(.restricted)
        default: // For future status types.
            print("Default")
        }
    }
    
}
