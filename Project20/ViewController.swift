//
//  ViewController.swift
//  Project20
//
//  Created by Gitko Denis on 02.09.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
	@IBOutlet var distanceReading: UILabel!
	
	var beaconLocated = false
	var locationManager: CLLocationManager?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.requestAlwaysAuthorization()
		
		view.backgroundColor = .gray
		
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		if manager.authorizationStatus == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				}
			}
		}
	}
	
	func startScanning() {
		let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
		let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
		
		locationManager?.startMonitoring(for: beaconRegion)
		locationManager?.startRangingBeacons(in: beaconRegion)
	}

	func update(distance: CLProximity) {
		UIView.animate(withDuration: 1) {
			switch distance {
			case .unknown:
				self.view.backgroundColor = UIColor.gray
				self.distanceReading.text = "UNKNOWN"
			case .immediate:
				self.view.backgroundColor = UIColor.red
				self.distanceReading.text = "RIGHT HERE"
			case .near:
				self.view.backgroundColor = UIColor.orange
				self.distanceReading.text = "NEAR"
			case .far:
				self.view.backgroundColor = UIColor.blue
				self.distanceReading.text = "FAR"
			default:
				self.view.backgroundColor = UIColor.gray
				self.distanceReading.text = "UNKNOWN"
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
		if let beacon = beacons.first {
			if beaconLocated == false {
				beaconLocated = true
				let ac = UIAlertController(title: "Found a beacon", message: "We've located the first beacon", preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
				present(ac, animated: true)
			}
			update(distance: beacon.proximity)
		} else {
			update(distance: .unknown)
		}
	}

}

