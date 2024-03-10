//
//  SceneDelegate.swift
//  RacingGame
//
//  Created by Игорь Николаев on 19.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = SettingAssembly().builder()
        let start = StartViewController()
        let navigationController = UINavigationController(rootViewController: start)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
