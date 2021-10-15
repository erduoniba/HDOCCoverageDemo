//
//  AppDelegate.swift
//  HDCoverageDemo
//
//  Created by denglibing on 2021/10/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var coverageFile = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        coverageFile?.append("/coverageFiles")
        if let coverageFile = coverageFile {
            debugPrint("coverageFile: \(coverageFile)")
            // setenv的意思是将数据的根目录设置为app的Documents
            setenv("GCOV_PREFIX", coverageFile.cString(using: .utf8), 1)
            // setenv的意思是strip掉一些目录层次，因为覆盖率数据默认会写入一个很深的目录层次
            setenv("GCOV_PREFIX_STRIP", "13", 1)
        }
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

