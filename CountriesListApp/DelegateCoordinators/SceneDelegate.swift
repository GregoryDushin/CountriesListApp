//
//  SceneDelegate.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let initialViewController = ViewControllerFactory.countriesVC()
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

struct ViewControllerFactory {
    static func countriesVC() -> CountriesListViewController {
        let initialViewController = CountriesListViewController()
        initialViewController.presenter = CountriesListPresenter(dataLoader: DataLoader())
        return initialViewController
                                    
    }
}
