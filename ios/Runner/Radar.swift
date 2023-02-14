//
//  Radar.swift
//  Runner
//
//  Created by io on 14.02.2023.
//


import Foundation
import CoreLocation

class Radar: NSObject, CLLocationManagerDelegate {
    func insertLocation(loc: CLLocation, heading: Double) {
        print("code for helperdelegaete")
    }
    
    func insertLocation(loc: CLLocation, heading: Double, result: (Any?) -> Void) {
        print("code for helperdelegate with flutter result")
    }

    static let shared = Radar()
    let locationManager: CLLocationManager
    var currentHeading: Double = 0
    var counter: Int = 0

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        super.init()
        locationManager.delegate = self
    }
    
    func start() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if (CLLocationManager .headingAvailable()){
            locationManager.headingFilter = 5
            locationManager.startUpdatingHeading()
        }
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (newHeading.headingAccuracy < 0){
            return;
        }
        let theHeading:CLLocationDirection = ((newHeading.trueHeading>0) ? newHeading.trueHeading: newHeading.magneticHeading);
        self.currentHeading = theHeading
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }

        self.counter+=1
      
        print("\(mostRecentLocation.coordinate.latitude), \(mostRecentLocation.coordinate.longitude)")

        
        AppDelegate().broadcastLocation(location: mostRecentLocation)

     

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.stopUpdatingLocation()
    }


}
