//
//  LocationController.swift
//  Backyard Birds
//
//  Created by dmu mac 26 on 16/05/2025.
//

import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Lokationstilladelse givet")
        case .denied, .restricted:
            print("Lokationstilladelse nægtet")
        default:
            break
        }
    }
}
