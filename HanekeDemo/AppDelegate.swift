//
//  AppDelegate.swift
//  HanekeDemo
//
//  Created by Hermes Pique on 9/17/14.
//  Copyright (c) 2014 Haneke. All rights reserved.
//

import UIKit
import Haneke

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        HanekeGlobals.setDefaultDiskCapacityStrategy { diskCache, fileManager in
            DiskCache.Invalidation.deleteItemsOverCapacity(diskCache, fileManager)
            
            let calendar = Calendar.current
            guard let invalidationDate = calendar.date(byAdding: .minute, value: -1, to: Date()) else {
                return
            }
            
            DiskCache.Invalidation.deleteItemsCreatedBefore(invalidationDate)(diskCache, fileManager)
           
        }
        
        return true
    }
}
