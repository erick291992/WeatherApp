//
//  LocationView.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct LocationView: View {
    private let weatherData: WeatherData
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isIPhoneLandscapeOrIpad: Bool {
        return verticalSizeClass == .compact || (verticalSizeClass == .regular && horizontalSizeClass == .regular)
    }

    init(weatherData: WeatherData) {
        self.weatherData = weatherData
    }
    
    var body: some View {
        if isIPhoneLandscapeOrIpad {
            HStack {

                VStack(alignment: .leading) {
                    TitleView()
                    TempInfoView(alignment: .leading)
                }

                MapViewPresentable(latitude: weatherData.coord.lat,
                                   longitude: weatherData.coord.lon,
                                   title: weatherData.name)
                    .frame(width: 300, height: 300, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .vAlign(.top)
            .hAlign(.center)
            .background(Color.primaryBackground)
            .preferredColorScheme(.dark)
        } else {
            VStack {
                TitleView()
                .hAlign(.leading)
                .padding()



                TempInfoView()

                MapViewPresentable(latitude: weatherData.coord.lat,
                                   longitude: weatherData.coord.lon,
                                   title: weatherData.name)
                    .frame(width: 300, height: 300, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .vAlign(.top)
            .hAlign(.center)
            .background(Color("Background"))
            .preferredColorScheme(.dark)
        }
        
    }
    
    func TitleView() -> some View{
        VStack(alignment: .leading) {
            Text(weatherData.name)
                .bold()
                .font(.title)
            
            Text("Today \(Date().formatted(.dateTime.month().day().hour().minute()))")
                .fontWeight(.light)
        }
    }
    
    func TempInfoView(alignment: HorizontalAlignment = .center) -> some View{
        VStack(alignment: alignment,spacing: 0) {
            HStack {
                WebImage(url: weatherData.weather.first?.imageUrl).placeholder {
                    // MARK: Placeholder Image
                    ProgressView()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                
                Text("\(weatherData.main.feelsLike.roundedString())°")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .padding()
            
            }
            
            Text(weatherData.weather.first?.description ?? "")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                TempInfo(title: "H", value: weatherData.main.tempMax.roundedString())
                TempInfo(title: "L", value: weatherData.main.tempMin.roundedString())
            }
            
        }
    }
    
    func TempInfo(title: String, value: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
            Text(":\(value)°")
        }
        .font(.subheadline)
        .fontWeight(.bold)
    }
}
