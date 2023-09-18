//
//  HomeView.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import SwiftUI
import CoreLocationUI

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    @State private var searchedLocation: Location?

    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.isPresentingSearchView.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .tint(.white)
                        .scaleEffect(0.9)
                }
            }
            .hAlign(.trailing)
            .padding(.horizontal)
            
            if viewModel.locationPermission == .disabled {
                Text("Please enable your location to get the weather in your area")
            } else if viewModel.locationPermission != .authorized {
                RequestPermissionView()
            }
            
            if let weatherData = viewModel.weatherData {
                LocationView(weatherData: weatherData)
            }
        }
        .vAlign(.top)
        .hAlign(.center)
        .sheet(isPresented: $viewModel.isPresentingSearchView, onDismiss: {
            if let location = searchedLocation {
                viewModel.onUserLocationSearched(location: location)
            }
        }) {
            SearchView(searchedLocation: $searchedLocation)
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
        }
    }
    
    func RequestPermissionView() -> some View {
        VStack(spacing: 20) {
            Text("Please share your current location to get the weather in your area")
            Button {
                if viewModel.locationPermission == .denied {
                    openAppSettings()
                } else {
                    viewModel.requestLocationPermission()
                }
            } label: {
                Text("Request Location")
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // TODO: Handle this edge case
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
