//
//  MapPoint.swift
//  FriendsGlue
//
//  Created by Eugen Pirogoff on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import MapKit

class MapPoint: NSObject, MKAnnotation {
  let title: String
  let address: String
  let coordinate: CLLocationCoordinate2D
  
  init(title: String, address: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.address = address
    self.coordinate = coordinate
    super.init()
  }
  
  var subtitle: String {
    return address
  }

}