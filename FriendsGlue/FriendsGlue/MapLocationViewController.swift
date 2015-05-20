//
//  MapLocationViewController.swift
//  FriendsGlue
//
//  Created by Eugen Pirogoff on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var successClosure: ((String, CLLocation) -> ())?
    var whatContext: String?
    
    var locationmanager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    var location: CLLocation?
    var address: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.Follow, animated: true)
        mapView.userLocation.title = "You"
        var gesture = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        gesture.minimumPressDuration = 0.7
        self.view.addGestureRecognizer(gesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPressed(longPress: UIGestureRecognizer) {
        if (longPress.state == UIGestureRecognizerState.Ended) {
            
        }else if (longPress.state == UIGestureRecognizerState.Began) {
            let touchEvenPoint = longPress.locationInView(self.view)
            mapView.removeAnnotations(mapView.annotations)
            addPointToMap(touchEvenPoint)
        }
    }
    
    func addPointToMap(point: CGPoint) {
        let coord = mapView.convertPoint(point, toCoordinateFromView: self.mapView)
        
        location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
       
        lookupLocation(location!, success: { (addressString) -> () in
            if let string = addressString {
                self.address = string
                let mappoint = MapPoint(title: self.whatContext ?? "Place" , address: string, coordinate: coord)
                self.mapView.addAnnotation(mappoint)
                self.mapView.selectAnnotation(mappoint, animated: true)
            }
        })
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? MapPoint {
            var view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Location")
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -20, y: 20)
            view.setSelected(true, animated: true)
            view.selected = true
            return view
        }
        return nil
    }
    
    func lookupLocation(coordinate: CLLocation, success: (String?) -> ()) {
        geocoder.reverseGeocodeLocation(coordinate, completionHandler: {(data, error) in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            if data.count > 0 {
                let pm = data[0] as! CLPlacemark
                let address = "\(pm.name), \(pm.subLocality), \(pm.locality)"
                success(address)
            } else {
                success(nil)
            }
            
        })
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    @IBAction func done(sender: AnyObject) {
        if let locationValue = location, addressValue = address {
            successClosure?(addressValue, locationValue)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
}
