//
//  LocationPinView.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/24/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    public let location: Location
    
    var title: String? { return location.name }
    var subtitle: String? { return location.displayCount }
    var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude) }
    
    init(location: Location) {
        self.location = location
        super.init()
    }
}

class LocationMarker: MKMarkerAnnotationView {
    var icon: UILabel?
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? LocationAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 20)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = LocationMarker.getColor(annotation: annotation)
            glyphText = ""
            displayPriority = .required
            
            if let icon = icon {
                icon.removeFromSuperview()
            }
            
            icon = UILabel()
            icon!.isUserInteractionEnabled = true
            icon!.font = Fonts.fontAwesome(size: 15)
            icon!.textColor = ColorPallete.white
            icon!.layer.zPosition = 9999
            
            switch annotation.location.type {
            case .academic: icon!.frame = CGRect(x: 7, y: 1.5, width: 20, height: 15)
            case .dining: icon!.frame = CGRect(x: 7, y: 1.5, width: 20, height: 15)
            case .gym: icon!.frame = CGRect(x: 4.5, y: 1.5, width: 20, height: 15)
            }
            icon!.text = Icons.from(type: annotation.location.type)
            
            addSubview(icon!)
        }
    }
    
    private static func getColor(annotation: LocationAnnotation) -> UIColor {
        let spaces = annotation.location.spaces
        var avgRating = 0
        spaces.forEach({ avgRating += $0.congestionRating })
        return ColorPallete.congestionColor(min: 0, max: 100, current: CGFloat(avgRating / spaces.count))
    }
    
    public func update() {
        print ((self.annotation as! LocationAnnotation).location.id)
        UIView.animate(withDuration: 0.5, animations: {
            self.markerTintColor = LocationMarker.getColor(annotation: (self.annotation as! LocationAnnotation))
        })
    }
}
