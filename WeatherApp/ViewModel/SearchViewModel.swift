//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published private(set) var citiesResults: [City] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] newValue in
                if newValue.isEmpty {
                    self?.citiesResults = []
                } else {
                    self?.findCities(name: newValue)
                }
            })
    }
    
    private func findCities(name: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let cities = try await NetworkService.shared.searchCity(with: name)
                await MainActor.run(body: {
                    self.citiesResults = cities
                })
            } catch {
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async {
        // MARK: UI Must be run on the Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}
