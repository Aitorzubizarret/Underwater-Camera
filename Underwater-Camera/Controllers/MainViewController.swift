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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Camera
        self.setupCamera()
    }
}

// MARK: - Barometer Sensor

extension MainViewController {
    
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
    
}

// MARK: - Camera

extension MainViewController {
    
    ///
    /// Setup the Camera.
    ///
    private func setupCamera() {
        self.cameraManager = Camera.shared
        
        guard let cameraManager = self.cameraManager else { return }
        
        cameraManager.handleCameraPermission { (error) in
            if let error = error {
                print("Camera permission error:  \(error.description)")
            } else {
                DispatchQueue.main.async {
                    cameraManager.setupCameraOutput(previewView: self.cameraPreviewView)
                }
            }
        }
    }
    
}
