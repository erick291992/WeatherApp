//
//  SearchView.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: SearchViewModel
    @Binding private var searchedLocation: Location?

    
    init(viewModel: SearchViewModel = SearchViewModel(), searchedLocation: Binding<Location?>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self._searchedLocation = searchedLocation
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Search for a city", text: $viewModel.searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            List(viewModel.citiesResults, id: \.id) { city in
                Text("\(city.name) · \(city.state ?? "") ·  \(city.country)")
                    .font(.callout)
                    .hAlign(.leading)
                    .onTapGesture {
                        closeKeyboard()
                        searchedLocation = Location(latitude: city.latitude, longitude: city.longitude)
                        dismiss()
                    }
            }
        }.alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchViewModel(), searchedLocation:.constant(nil))
            .preferredColorScheme(.dark)
    }
}
