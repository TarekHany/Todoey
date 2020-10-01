//
//  AppDelegate.swift
//  Todoey
//
//  Created by Tarek Hany on 9/28/20.
//  Copyright © 2020 Tarek Hany. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        do {
            _ = try Realm()
            
        } catch {
            print("Error initializing new Realm, \(error)")
        }
        return true
    }
}

