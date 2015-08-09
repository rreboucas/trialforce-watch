//
//  ExtensionDelegate.swift
//  isvWatch Extension
//
//  Created by Rodrigo Reboucas on 8/3/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    var iphoneData = [String: AnyObject]()
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        WCSession.defaultSession().delegate = self
        WCSession.defaultSession().activateSession()
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        
        
        //
        
        print("didReceiveApplicationContext =  \(applicationContext)")
        iphoneData = applicationContext
    }

}
