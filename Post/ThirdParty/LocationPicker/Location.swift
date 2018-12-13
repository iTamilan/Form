//
//  Location.swift
//  LocationPicker
//
//  Created by Almas Sapargali on 7/29/15.
//  Copyright (c) 2015 almassapargali. All rights reserved.
//

import Foundation

import CoreLocation
import AddressBookUI

// class because protocol
public class Location: NSObject {
	public let name: String?
	
    public var shortName: String {
        if let name = name {
            return name
        } else if let name = placemark.name {
            return name
        } else {
            return "Unknown location: \(coordinate.latitude), \(coordinate.longitude)"
        }
    }
    
	// difference from placemark location is that if location was reverse geocoded,
	// then location point to user selected location
	public let location: CLLocation
	public let placemark: CLPlacemark
	
	public var address: String {
		// try to build full address first
		var addressArray = [String]()
        if let name = placemark.name {
            addressArray.append(name)
        }
        if let thoroughfare = placemark.thoroughfare {
            addressArray.append(thoroughfare)
        }
        if let locality = placemark.locality {
            addressArray.append(locality)
        }
        if let administrativeArea = placemark.administrativeArea {
            addressArray.append(administrativeArea)
        }
        if let isoCountryCode = placemark.isoCountryCode {
            addressArray.append(isoCountryCode)
        }
        if addressArray.isEmpty {
            addressArray.append("\(coordinate.latitude), \(coordinate.longitude)")
        }
        return addressArray.joined(separator: ", ")
	}
	
	public init(name: String?, location: CLLocation? = nil, placemark: CLPlacemark) {
		self.name = name
        if let location = location {
            self.location = location
        } else if let location = placemark.location {
            self.location = location
        } else {
            self.location = CLLocation()
        }

		self.placemark = placemark
	}
}

import MapKit

extension Location: MKAnnotation {
    @objc public var coordinate: CLLocationCoordinate2D {
		return location.coordinate
	}
	
    public var title: String? {
		return name ?? address
	}
}
