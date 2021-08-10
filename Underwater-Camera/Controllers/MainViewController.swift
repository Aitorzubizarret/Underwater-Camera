//
//  MainViewController.swift
//  Underwater-Camera
//
//  Created by Aitor Zubizarreta Perez on 05/08/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var barometerSensorManager: BarometerSensor?
    var timer = Timer()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Barometer sensor
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
        guard let barometerSensorManager = self.barometerSensorManager else { return }
        
        print("Pressure \(Int(barometerSensorManager.pressure_kPa)) kPa")
    }
    
}
