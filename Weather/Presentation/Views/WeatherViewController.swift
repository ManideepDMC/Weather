//
//  WeatherViewController.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import UIKit
import SwiftUI

final class WeatherViewController: UIViewController {
    
    private let viewModel: WeatherViewModel
    
    // MARK: - Init (Dependency Injection, no storyboard)
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Storyboards are not used.")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weather"
        view.backgroundColor = .systemBackground
        
        setupSwiftUIView()
    }
    
    // MARK: - Embed SwiftUI
    /// Hosts the SwiftUI content view inside this UIKit ViewController.
    /// The SwiftUI view fills the entire safe area.
    private func setupSwiftUIView() {
        let contentView = WeatherContentView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: contentView)
        
        // Add as child ViewController
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Constrain to fill the entire view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Orientation Support
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .allButUpsideDown
    }
}
