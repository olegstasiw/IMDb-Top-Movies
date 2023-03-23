//
//  SceneDelegate.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 22.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let viewModel = TopMoviesViewModel()
        let viewController = TopMoviesViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

