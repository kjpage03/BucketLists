//
//  MapViewController.swift
//  BucketLists
//
//  Created by Jake Olsen on 4/1/21.
//

import UIKit
import MapKit
 
class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            // continue to implement here
        } else {
            let locationAlert = UIAlertController(title: "Please turn on Location Services.", message: "Please enable location services to use the map.", preferredStyle: .alert)
            locationAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            }
            // Do any additional setup after loading the view.
        }
    func checkLocationServices() {
        switch CLLocationManager().authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted:
        break
        case .authorizedAlways:
        break
        @unknown default:
            break
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
