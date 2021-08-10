//
//  BarometerSensor.swift
//  Underwater-Camera
//
//  Created by Aitor Zubizarreta Perez on 07/08/2021.
//

import Foundation
import CoreMotion

final class BarometerSensor {
    
    // MARK: - Properties
    
    static let shared = BarometerSensor() // Singleton
    let altimeterManager = CMAltimeter()
    var pressure_atm: Float = -1
    var pressure_kPa: Float = -1
    
    // MARK: - Methods
    
    init() {
        self.setupBarometer()
    }
    
    ///
    /// Setup the Barometer sensor.
    ///
    private func setupBarometer() {
        // Check Altimeter is available.
        if CMAltimeter.isRelativeAltitudeAvailable() {
            // Start Altimeter sensor data readout.
            self.altimeterManager.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                if let altimeterData = data {
                    self.pressure_kPa = altimeterData.pressure.floatValue
                    self.pressure_atm = 0.00986923266 * self.pressure_kPa
                }
            }
        }
    }
    
}
