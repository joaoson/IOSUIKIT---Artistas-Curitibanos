//
//  SceneDelegate.swift
//  IOSUIkitFinal
//
//  Created by João Vitor De Freitas on 20/04/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let navigationDelegate = CortinaNavigationControllerDelegate()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)

        // --- 1) Splash ---
        let splash = SplashViewController()

        // --- 2) Navegação principal (ainda não apresentada) ---
        let mainVC = ViewController2()
        let nav = UINavigationController(rootViewController: mainVC)
        nav.delegate = navigationDelegate

        // --- 3) Quando o splash terminar... ---
        splash.onFinish = { [weak self] in
            guard let self = self, let window = self.window else { return }

            // Animação cross-dissolve trocando o root
            UIView.transition(with: window,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                  window.rootViewController = nav
                              },
                              completion: { _ in
                                  // Garante que não guardamos referência ao splash
                                  splash.removeFromParent()
                              })
        }

        // --- 4) Define splash como root inicial ---
        window?.rootViewController = splash
        window?.makeKeyAndVisible()
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
