//
//  MainViewController.swift
//  Underwater-Camera
//
//  Created by Aitor Zubizarreta Perez on 05/08/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var pressureLabel: UILabel!
    
    // MARK: - Properties
    
    var barometerSensorManager: BarometerSensor?
    var cameraManager: Camera?
    var timer = Timer()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Barometer sensor
        self.setupBarometerSensor()
        
        // Camera
        self.setupCamera()
    }
    
    ///
    /// Setup the Barometer sensor.
    ///
    private func setupBarometerSensor() {
        self.barometerSensorManager = BarometerSensor.shared
        
        self.setupBarometerSensorDataReadoutTimer()
    }
    
    ///
    /// Setup a timer to execute the method "getBarometerSensorData" every x seconds.
    ///
    private func setupBarometerSensorDataReadoutTimer(timeIntervar: TimeInterval = 2) {
        self.timer = Timer.scheduledTimer(timeInterval: timeIntervar, target: self, selector: #selector(self.getBarometerSensorData), userInfo: nil, repeats: true)
    }
    
    ///
    /// Get Barometer sensor data.
    ///
    @objc private func getBarometerSensorData() {
        guard let barometerSensorManager = self.barometerSensorManager,
              let pressureValue = barometerSensorManager.getPressureValueInKPA() else { return }
        
        self.pressureLabel.text = "Pressure: \(Int(pressureValue)) kPa"
    }
    
    ///
    /// Setup the Camera.
    ///
    private func setupCamera() {
        self.cameraManager = Camera.shared
        
        if let cameraManager = self.cameraManager,
           cameraManager.checkPermission() {
            cameraManager.setupCameraOutput(previewView: self.cameraPreviewView)
        } else {
            print("NO camera permission")
        }
    }
    
}
