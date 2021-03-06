//
//  SceneDelegate.swift
//  GithubApp
//
//  Created by 김광준 on 2021/07/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        /*
         ‼️ Description: About Hierarchy of UIViewController, UINavigationController and UITabBarController.
         -> UITabBarController is 'holding' UINavigationControllers.
         -> UINavigationController is 'holding' UIViewControllers.
         */
        
        // ‼️ c.f : UINavigationController has to have UIViewController which is in the screen showing.
        // ‼️ c.f : UINavigationController can contain UIViewControllers which contain works like 'Stack'.

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Configure window with the windowScene
        
        // Set up window's frame
        // c.f : 'windowScene.coordinateSpace.bounds' basically makes it fill up the full screen
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        // ‼️ c.f : Every window has windowScene
        // Set up the window's windowScene which is I made it at line 17.
        window?.windowScene = windowScene
        
        // Set up root view controller
        window?.rootViewController = GFTabBarController()
        
        configureNavigationBar()
        
        // This code is doing that actually showing.
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
    

    // MARK:- configureNavigationBar for the navigationBar tint color change
    /*
     Discussion: Why did I create 'configureNavigationBar' function?
     Because I will use any where to want use this code which is UINavigationBar tintColor to be change by 'systemGreen'.
     Otherwise this function is generic function to make UINavigaiotnBar tintColor change to 'systemGreen'.
     */
    func configureNavigationBar() {
        /*
         Discussion: About appearance() method.
         The 'appearance' method have means to 'overall'.
         For example this code 'appearance()' means all of UINavigationBar are going to have this code.
         */
        
        UINavigationBar.appearance().tintColor = .systemGreen
        
    }

}

