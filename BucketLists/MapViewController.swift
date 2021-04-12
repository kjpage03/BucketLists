//
//  MapViewController.swift
//  BucketLists
//
//  Created by Kaleb Page on 4/5/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.centerToLocation(initialLocation)
        let location = BucketItemLocation(coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(location)
        
        // Do any additional setup after loading the view.
    }
    
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}

class BucketItemLocation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D

    
    init(coordinate: CLLocationCoordinate2D) {
        
        self.coordinate = coordinate
        super.init()
    }
}


