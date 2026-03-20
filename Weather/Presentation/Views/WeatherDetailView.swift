//
//  WeatherDetailView.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import SwiftUI

struct WeatherDetailView: View {
    
    let weather: WeatherEntity
    let viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // City name and main temperature
            headerSection
            
            // Detail grid
            detailGrid
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text(weather.cityName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityIdentifier(AccessibilityID.cityNameLabel)
                .accessibilityAddTraits(.isHeader)
            
            Text(viewModel.formattedDescription(weather.weatherDescription))
                .font(.title3)
                .foregroundColor(.secondary)
                .accessibilityIdentifier(AccessibilityID.descriptionLabel)
            
            Text(viewModel.formattedTemperature(weather.temperature))
                .font(.system(size: 64, weight: .thin))
                .accessibilityIdentifier(AccessibilityID.temperatureLabel)
                .accessibilityLabel("Temperature \(viewModel.formattedTemperature(weather.temperature))")
            
            HStack(spacing: 16) {
                Label(
                    "H: \(viewModel.formattedTemperature(weather.tempMax))",
                    systemImage: "arrow.up"
                )
                Label(
                    "L: \(viewModel.formattedTemperature(weather.tempMin))",
                    systemImage: "arrow.down"
                )
            }
            .font(.body)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Detail Grid
    private var detailGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 12
        ) {
            detailCard(
                title: "Feels Like",
                value: viewModel.formattedTemperature(weather.feelsLike),
                icon: "thermometer",
                identifier: AccessibilityID.feelsLikeCard
            )
            detailCard(
                title: "Humidity",
                value: "\(weather.humidity)%",
                icon: "humidity",
                identifier: AccessibilityID.humidityCard
            )
            detailCard(
                title: "Wind",
                value: viewModel.formattedWindSpeed(weather.windSpeed),
                icon: "wind",
                identifier: AccessibilityID.windCard
            )
            detailCard(
                title: "Visibility",
                value: viewModel.formattedVisibility(weather.visibility),
                icon: "eye",
                identifier: AccessibilityID.visibilityCard
            )
            detailCard(
                title: "Pressure",
                value: "\(weather.pressure) hPa",
                icon: "gauge.medium",
                identifier: AccessibilityID.pressureCard
            )
            detailCard(
                title: "Sunrise",
                value: viewModel.formattedTime(weather.sunrise),
                icon: "sunrise",
                identifier: AccessibilityID.sunriseCard
            )
            detailCard(
                title: "Sunset",
                value: viewModel.formattedTime(weather.sunset),
                icon: "sunset",
                identifier: AccessibilityID.sunsetCard
            )
            detailCard(
                title: "Sea Level",
                value: "\(weather.seaLevel) meters",
                icon: "water.waves",
                identifier: AccessibilityID.seaLevelCard
            )
            detailCard(
                title: "Ground Level",
                value: "\(weather.groundLevel) meters",
                icon: "mountain.2",
                identifier: AccessibilityID.groundLevelCard
            )
        }
    }
    
    // MARK: - Reusable Card
    private func detailCard(title: String, value: String, icon: String, identifier: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .accessibilityIdentifier(identifier)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}
