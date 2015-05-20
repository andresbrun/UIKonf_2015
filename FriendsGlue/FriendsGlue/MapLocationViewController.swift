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
  
    override func viewDidLoad() {
      super.viewDidLoad()
      locationmanager.requestWhenInUseAuthorization()
      locationmanager.startUpdatingLocation()
      mapView.showsUserLocation = true
      mapView.setUserTrackingMode(.Follow, animated: true)
      mapView.userLocation.title = "You"
      let anno = get_point()
      mapView.addAnnotation(anno)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
//  TO REMOVE, just fake Location to draw it on the map
  func get_point() -> MapPoint {
    let coord = CLLocationCoordinate2DMake( 52.500578,13.4147954)
    return MapPoint(title: "UIKonf2015", address: "adress", coordinate: coord)
  }

  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if let annotation = annotation as? MapPoint {
      var view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Location")
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -10, y: 10)
      view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
      return view
    }
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
