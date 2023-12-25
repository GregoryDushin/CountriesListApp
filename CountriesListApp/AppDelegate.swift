//
//  AppDelegate.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 21.12.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = CountriesListViewController()
        initialViewController.presenter = CountriesListPresenter(dataLoader: DataLoader())

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }
}
