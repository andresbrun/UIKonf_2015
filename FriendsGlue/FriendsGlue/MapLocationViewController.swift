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

class MapLocationViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  
  var locationmanager = CLLocationManager()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      locationmanager.requestWhenInUseAuthorization()
      locationmanager.startUpdatingLocation()
      mapView.showsUserLocation = true
      mapView.setUserTrackingMode(.Follow, animated: true)
      mapView.userLocation.title = "You"
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
