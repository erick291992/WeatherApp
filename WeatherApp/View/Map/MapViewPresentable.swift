//
//  MapView.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import SwiftUI
import MapKit

struct MapViewPresentable: UIViewControllerRepresentable {

    var latitude: Double
    var longitude: Double
    var title: String
    
    func makeUIViewController(context: Context) -> MapViewController {
        let viewController = MapViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {

        uiViewController.mapView.removeAnnotations(uiViewController.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        uiViewController.mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        uiViewController.mapView.setRegion(region, animated: false)
    }
}
