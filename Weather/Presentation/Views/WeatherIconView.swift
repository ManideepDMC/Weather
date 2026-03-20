//
//  WeatherIconView.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import SwiftUI

struct WeatherIconView: View {
    
    let imageData: Data?
    
    var body: some View {
        Group {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .accessibilityIdentifier(AccessibilityID.weatherIcon)
                    .accessibilityLabel("Weather condition icon")
            } else {
                // Placeholder while icon loads or if loading failed
                ProgressView()
                    .frame(width: 120, height: 120)
                    .accessibilityHidden(true)
            }
        }
    }
}
