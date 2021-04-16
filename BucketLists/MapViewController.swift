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
    var bucketItems: [Item]?
    let dataController = DataController()

    var hasRecievedAlert: Bool {
        let value = dataController.retrieveValue(pathName: DataController.hasRecievedPathName)        
        return value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title of pins to bucket list item name
        //subtitle to location
        
        //Set region and span

        mapView.region.span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees("100")!, longitudeDelta: CLLocationDegrees("100")!)
        //percentage doesn't work for some reason
        
        if let items = bucketItems {
            items.forEach { (item) in
                if let location = item.location {
                    dropPinZoomIn(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude)!, longitude: CLLocationDegrees(location.longitude)!)), title: item.name, subtitle: location.location)
                }
            }
        }
        //        mapView.centerToLocation(initialLocation)
        //        let location = BucketItemLocation(coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        //        mapView.addAnnotation(location)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let items = bucketItems {
            items.forEach { (item) in
                if let location = item.location {
                    dropPinZoomIn(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude)!, longitude: CLLocationDegrees(location.longitude)!)), title: item.name, subtitle: location.location)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !hasRecievedAlert {
            let ac = UIAlertController(title: "Completion Locations", message: "Scroll to see locations where you completed items on your bucket list.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (_) in
                //change the value of hasRecievedAlert
                self.dataController.saveData(data: true, pathName: DataController.hasRecievedPathName)
                print(self.dataController.retrieveData(pathName: DataController.hasRecievedPathName))
            }))
            present(ac, animated: true, completion: nil)
        }
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

extension MapViewController {
    
    func dropPinZoomIn(placemark: MKPlacemark, title: String, subtitle: String) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView?.addAnnotation(annotation)
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
//        mapView!.setRegion(region, animated: true)
    }
    
    
}


