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
    private let altimeterManager = CMAltimeter()
    private var pressure_kPa: Float?
    
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
                }
            }
        }
    }
    
    ///
    /// Returns the pressure value in kPa.
    ///
    public func getPressureValueInKPA() -> Float? {
        return self.pressure_kPa
    }
    
}
