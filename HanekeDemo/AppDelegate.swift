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
        
        setDefaultDiskCapacityStrategy { diskCache, fileManager in
            deleteItemsOverCapacity(diskCache, fileManager)
            
            let cachePath = diskCache.path
            
            let calendar = Calendar.current
            let targetDate = calendar.date(byAdding: .minute, value: -1, to: Date())!
            
            guard let paths = try? fileManager.directoryContents(at: URL(string: cachePath)!, before: targetDate)
                .compactMap({ $0.path }), paths.count > 0 else {
                return
            }
            
            diskCache.removeFiles(for: paths)
            print("\(paths.count) old files have been removed")
            return
        }
        
        return true
    }
}


private extension FileManager {
    func directoryContents(at url: URL) throws -> [URL] {
        return try contentsOfDirectory(at: url,
                                        includingPropertiesForKeys: nil,
                                        options: [.skipsHiddenFiles])
        
    }
    
    func directoryContents(at url: URL, before date: Date) throws -> [URL] {
        return try directoryContents(at: url).filter({ u in
            let attributes = try attributesOfItem(atPath: u.path)
            
            guard let creationDate = attributes[.creationDate] as? Date else {
                return true
            }
            
            return creationDate < date
        })
    }
}
