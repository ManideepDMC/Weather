//
//  WeatherContentView.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import SwiftUI

struct WeatherContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.4),
                    Color.cyan.opacity(0.2),
                    Color.white.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search bar always visible at top
                SearchBarView(
                    searchText: $viewModel.searchText,
                    searchResults: viewModel.searchResults,
                    isSearching: viewModel.isSearching,
                    onCitySelected: { city in
                        viewModel.selectCity(city)
                    }
                )
                .padding()
                
                // Weather content based on state
                weatherContent
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    // MARK: - State-Based Content
    @ViewBuilder
    private var weatherContent: some View {
        switch viewModel.viewState {
        case .idle:
            idleView
            
        case .loading:
            loadingView
            
        case .loaded(let weather):
            if horizontalSizeClass == .regular {
                // iPad / Landscape: side-by-side layout
                landscapeWeatherView(weather: weather)
            } else {
                // iPhone Portrait: scrollable stack
                portraitWeatherView(weather: weather)
            }
            
        case .error(let message):
            errorView(message: message)
        }
    }
    
    // MARK: - Idle State
    private var idleView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text("Search for a city to see weather")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .accessibilityIdentifier(AccessibilityID.idleView)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search for a city to see weather information")
    }
    
    // MARK: - Loading State
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Fetching weather...")
                .progressViewStyle(CircularProgressViewStyle())
                .font(.headline)
            Spacer()
        }
        .accessibilityIdentifier(AccessibilityID.loadingView)
        .accessibilityLabel("Loading weather data")
    }
    
    // MARK: - Error State
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Try Again") {
                viewModel.onAppear()
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier(AccessibilityID.retryButton)
            Spacer()
        }
        .accessibilityIdentifier(AccessibilityID.errorView)
        .accessibilityElement(children: .combine)
    }
    
    // MARK: - Portrait Layout (Scrollable vertical stack)
    private func portraitWeatherView(weather: WeatherEntity) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                WeatherIconView(imageData: viewModel.weatherIconData)
                WeatherDetailView(weather: weather, viewModel: viewModel)
            }
            .padding()
        }
    }
    
    // MARK: - Landscape Layout (Side by side)
    private func landscapeWeatherView(weather: WeatherEntity) -> some View {
        HStack(alignment: .top, spacing: 20) {
            WeatherIconView(imageData: viewModel.weatherIconData)
                .frame(maxWidth: .infinity)
            
            ScrollView(showsIndicators: false) {
                WeatherDetailView(weather: weather, viewModel: viewModel)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
