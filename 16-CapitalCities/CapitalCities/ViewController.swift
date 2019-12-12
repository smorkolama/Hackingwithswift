//
//  ViewController.swift
//  CapitalCities
//
//  Created by Benjamin van den Hout on 12/12/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import UIKit
import MapKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Capital Cities"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapView))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 summer olympics", wikiURL: URL(string: "https://en.wikipedia.org/wiki/London"))
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a a thousand years ago", wikiURL: URL(string: "https://en.wikipedia.org/wiki/Oslo"))
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called City of Light", wikiURL: URL(string: "https://en.wikipedia.org/wiki/Paris"))
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it", wikiURL: URL(string: "https://en.wikipedia.org/wiki/Rome"))
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself", wikiURL: URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C."))

        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    @objc func changeMapView() {
        let ac = UIAlertController(title: "Map view", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = . standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
            self?.mapView.mapType = . satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
            self?.mapView.mapType = . hybrid
        })
        ac.addAction(UIAlertAction(title: "Satellite FlyOver", style: .default) { [weak self] _ in
            self?.mapView.mapType = . satelliteFlyover
        })
        ac.addAction(UIAlertAction(title: "Hybrid FlyOver", style: .default) { [weak self] _ in
            self?.mapView.mapType = . hybridFlyover
        })
        ac.addAction(UIAlertAction(title: "Muted standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = . mutedStandard
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Will also get notified for other stuff, only react on Capital objects
        guard annotation is Capital else { return nil }
        
        // re-use identifier
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

        // Could be that we need to construct our own
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.pinTintColor = UIColor.green
        
        return annotationView
    }
    
    // This gets called automatically by the (I) button in annotation, no need to add targets
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
//        let placeName = capital.title
//        let placeInfo = capital.info
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
        // Optional 3: show webview with wiki info
        let vc = DetailViewController()
        vc.detailItem = capital

        // Override back button text
//         you would expect this to work but it doesn't
//        navigationItem.backBarButtonItem?.title = "Back to map"
        
        // Instead this works:
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to map", style: .plain, target: nil, action: nil)

        navigationController?.pushViewController(vc, animated: true)
        
    }
}

