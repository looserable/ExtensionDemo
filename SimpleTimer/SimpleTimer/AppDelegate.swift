//
//  AppDelegate.swift
//  SimpleTimer
//
//  Created by 王 巍 on 14-8-1.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

let taskDidFinishedInWidgetNotification = "com.john.taskDidFinished"

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        self.window?.frame = UIScreen.mainScreen().bounds
        
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme == "simpleTimer" {
            if url.host == "finished" {
                NSNotificationCenter.defaultCenter()
                    .postNotificationName(taskDidFinishedInWidgetNotification, object: nil)
            }
            return true
        }
        
        return false
    }

}

