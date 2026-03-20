//
//  AppCoordinator.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import UIKit

/// Coordinates the app navigation flow.
/// Currently single-screen, but structured for easy expansion
/// (e.g., adding a city list screen or settings screen).
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}

final class AppCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    private let dependencyContainer: DependencyContainer
    
    init(navigationController: UINavigationController, dependencyContainer: DependencyContainer) {
        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        showWeatherScreen()
    }
    
    private func showWeatherScreen() {
        let viewModel = dependencyContainer.makeWeatherViewModel()
        let viewController = WeatherViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    // MARK: - Future Navigation
    // Given more time, additional flows could be added here:
    // func showCityList() { ... }
    // func showSettings() { ... }
    // Each would create its own ViewModel and ViewController via the container
}
