//
//  LocationInfoViewController.swift
//  CWRUded
//
//  Created by Jacob Alspaw on 3/24/19.
//  Copyright © 2019 Jacob Alspaw. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import MapKit

class LocationInfoViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    public var location: Location?
    private var locationView: LocationInfo?
    private var directionsButton: ActionButton?
    private var favoriteButton: ActionButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupView() {
        setTitle()
        setScrollView()
        setLocationView()
        setDirectionsButton()
        setFavoriteButton()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateLocationViewContent), userInfo: nil, repeats: true)
    }
    
    private func setTitle() {
        setTitle(container: titleView,
                 iconLabel: titleIconLabel,
                 textLabel: titleTextLabel,
                 icon: Icons.info,
                 title: " Info")
    }
    
    private func setScrollView() {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        scrollView.backgroundColor = ColorPallete.clay
    }
    
    private func setLocationView() {
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        locationView = LocationInfo(location: location!)
        locationView!.transform = CGAffineTransform(translationX: 0, y: 10)
        scrollView.addSubview(locationView!)
    }
    
    @objc private func updateLocationViewContent() {
        for location in CrowdedData.singleton.locations {
            if (self.location!.id == location.id) {
                self.location = location
                break;
            }
        }
        self.locationView!.update(location: self.location!)
    }
    
    private func setDirectionsButton() {
        self.directionsButton = ActionButton(text: "Directions",
                                             textFont: Fonts.app(size: 23, weight: .bold),
                                             icon: Icons.compass,
                                             iconFont: Fonts.fontAwesome(size: 18),
                                             backgroundColor: ColorPallete.darkGrey,
                                             foregroundColor: ColorPallete.white,
                                             frame: CGRect(x: 10, y: locationView!.frame.height + 20, width: UIScreen.main.bounds.width - 20, height: 40),
                                             action: { self.directionsButtonTapped() })
        
        scrollView.addSubview(self.directionsButton!)
    }
    
    private func directionsButtonTapped() {
        guard let location = location else { return }
        let addressDict = [CNPostalAddressStreetKey: location.name]
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    private func setFavoriteButton() {
        self.favoriteButton = ActionButton(text: "Favorite",
                                             textFont: Fonts.app(size: 23, weight: .bold),
                                             icon: Icons.heart,
                                             iconFont: Fonts.fontAwesome(size: 18),
                                             backgroundColor: ColorPallete.darkGrey,
                                             foregroundColor: ColorPallete.white,
                                             frame: CGRect(x: 10,
                                                           y: directionsButton!.frame.origin.y + directionsButton!.frame.height + 10,
                                                           width: UIScreen.main.bounds.width - 20,
                                                           height: 40),
                                             action: { self.favoriteButtonTapped() })
        
        scrollView.addSubview(self.favoriteButton!)
    }
    
    private func favoriteButtonTapped() {
        guard let location = location else { return }
        
    }
    
    private func setScrollHeight() {
        //best way to set the height?
    }
}
