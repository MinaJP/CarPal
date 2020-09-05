//
//  AppDelegate.swift
//  CarPal
//
//  Created by Mina on 6/5/2563 BE.
//  Copyright © 2563 Mina. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		
		GMSPlacesClient.provideAPIKey("AIzaSyBojnH4bEBTpHNe1OzGlt84EvMW2xMyW_A")

		GMSServices.provideAPIKey("AIzaSyBojnH4bEBTpHNe1OzGlt84EvMW2xMyW_A")



		//GMSPlacesClient.provideAPIKey("AIzaSyCoPN_KxqOYGGNGC--iV2CTw2oixIuwcRI")
		return true
		
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

