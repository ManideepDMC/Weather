# Weather App

A native iOS weather application built with **MVVM + Clean Architecture + Coordinator** pattern. Users can search for US cities and view current weather conditions. No third-party libraries — built entirely with native Swift and Apple frameworks.

## Architecture

```
Presentation (UIKit + SwiftUI)
    │
    ▼
Domain (Entities, Use Cases, Protocols)
    ▲
    │
Data (Repositories, Network, Cache)
```

- **Domain Layer** — Entities, use case protocols/implementations, repository protocols. Zero external dependencies.
- **Data Layer** — Repository implementations, network service (URLSession), DTOs with JSON mapping, image cache (NSCache + FileManager), location (CoreLocation), persistence (UserDefaults).
- **Presentation Layer** — Coordinators manage navigation via UIKit. SwiftUI views are embedded using UIHostingController. ViewModels expose state via Combine `@Published` properties.

## Project Structure

```
Weather/
├── App/                        # AppDelegate, SceneDelegate, DependencyContainer
├── Domain/
│   ├── Entities/               # WeatherEntity, CityEntity, LocationEntity, WeatherError
│   ├── UseCases/               # FetchWeather, SearchCity, GetLastSearchedCity, GetCurrentLocation
│   └── Protocols/              # Repository protocols (Dependency Inversion)
├── Data/
│   ├── Network/                # NetworkService, APIEndpoint, APIConstants
│   ├── DTOs/                   # WeatherResponseDTO, GeocodingResponseDTO
│   ├── Repositories/           # WeatherRepository, LocationRepository, CacheRepository
│   └── Cache/                  # ImageCacheService (memory + disk)
├── Presentation/
│   ├── Coordinators/           # AppCoordinator
│   ├── ViewModels/             # WeatherViewModel
│   └── Views/                  # UIKit ViewController + SwiftUI Views
├── WeatherTests/               # Unit tests (ViewModel, UseCase, Repository)
└── WeatherUITests/             # UI tests with Page Object pattern
```

## Features

- Search US cities with geocoding API and debounced input
- Current weather display: temperature, feels like, humidity, wind, visibility, pressure, sunrise/sunset
- Weather condition icons from OpenWeatherMap with two-tier caching (memory + disk)
- Auto-loads last searched city on app launch
- Location-based weather on first launch (with user permission)
- Adaptive layout for portrait/landscape using SwiftUI size classes
- Light, dark, and tinted app icons

## Requirements

- iOS 16.0+
- Xcode 15+
- OpenWeatherMap API key

## Setup

1. Clone the repository
2. Open `Weather.xcodeproj` in Xcode
3. Replace `YOUR_API_KEY_HERE` in `Weather/Data/Network/APIConstants.swift` with your [OpenWeatherMap API key](https://openweathermap.org/api)
4. Build and run

## Testing

- **Unit Tests** (`Cmd + U`): ViewModel, UseCase, and Repository tests with mocked dependencies
- **UI Tests**: Search flow, weather display, app launch scenarios using Page Object pattern

## Tech Stack

| Area | Technology |
|------|-----------|
| UI | UIKit (navigation) + SwiftUI (views) |
| Reactive | Combine |
| Networking | URLSession + async/await |
| Location | CoreLocation |
| Persistence | UserDefaults |
| Image Cache | NSCache + FileManager |
| Testing | XCTest |
