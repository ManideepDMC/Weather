//
//  SceneDelegate.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        
        // Style the navigation bar
        navigationController.navigationBar.prefersLargeTitles = true
        
        let container: DependencyContainer
        // Check if running UI tests
        if ProcessInfo.processInfo.arguments.contains("-uitesting") {
            container = makeTestDependencyContainer()
        } else {
            container = DependencyContainer()
        }
        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            dependencyContainer: container
        )
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        // Start the app flow
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    /// Creates a DependencyContainer configured for UI testing.
    /// Handles launch arguments for pre-set cache, skipped location, etc.
    private func makeTestDependencyContainer() -> DependencyContainer {
        let container = DependencyContainer()
        let args = ProcessInfo.processInfo.arguments
        
        // Reset cache if requested
        if args.contains("-resetCache") {
            UserDefaults.standard.removeObject(forKey: "lastSearchedCityName")
            UserDefaults.standard.removeObject(forKey: "lastSearchedCityState")
            UserDefaults.standard.removeObject(forKey: "lastSearchedCityCountry")
            UserDefaults.standard.removeObject(forKey: "lastSearchedCityLatitude")
            UserDefaults.standard.removeObject(forKey: "lastSearchedCityLongitude")
        }
        
        // Pre-populate cached city if provided.
        // We parse ProcessInfo.arguments directly instead of UserDefaults because
        // negative longitude values (e.g., "-122.4194") get misinterpreted as
        // new flag keys by NSUserDefaults argument domain parsing.
        if let cityName = argValue(for: "-cachedCityName", in: args) {
            let latitude = Double(argValue(for: "-cachedCityLatitude", in: args) ?? "0") ?? 0
            let longitude = Double(argValue(for: "-cachedCityLongitude", in: args) ?? "0") ?? 0
            let country = argValue(for: "-cachedCityCountry", in: args) ?? "US"
            let state = argValue(for: "-cachedCityState", in: args)

            let city = CityEntity(
                name: cityName,
                state: state,
                country: country,
                latitude: latitude,
                longitude: longitude
            )
            container.cacheRepository.saveLastSearchedCity(city)
        }

        // Override location use case to skip permission prompt during UI tests
        if args.contains("-skipLocation") {
            container.overrideLocationUseCase = SkipLocationUseCase()
        }

        return container
    }

    /// Safely extracts the value following a flag in the arguments array.
    /// Handles negative values (e.g., "-122.4194") that UserDefaults would misparse.
    private func argValue(for key: String, in args: [String]) -> String? {
        guard let index = args.firstIndex(of: key),
              index + 1 < args.count else {
            return nil
        }
        return args[index + 1]
    }

}
