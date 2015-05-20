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
    
    var locationmanager = CLLocationManager()
    var geocoder = CLGeocoder()
    
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
        let mappoint = MapPoint(title: "UIKonf2015", address: "adress", coordinate: coord)
        mapView.addAnnotation(mappoint)
        mapView.selectAnnotation(mappoint, animated: true)
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
    
    
    func reverseLookup(coord :CLLocationCoordinate2D) -> String? {
        geocoder.reverseGeocodeLocation(coord, completionHandler: )
        return nil
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
