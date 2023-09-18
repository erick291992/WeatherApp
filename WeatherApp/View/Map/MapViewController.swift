//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import MapKit

class MapViewController: UIViewController {
    var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isRotateEnabled = false
        view.addSubview(mapView)
        
        // Set the map view to cover the entire screen
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MapViewController: MKMapViewDelegate {
    // Here will be any future delegates we want
}

import SwiftUI

struct MapViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }

    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<MapViewControllerPreview.ContainerView>) -> MapViewController {
            return MapViewController()
        }

        func updateUIViewController(_ uiViewController: MapViewControllerPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MapViewControllerPreview.ContainerView>) {

        }
    }
}
