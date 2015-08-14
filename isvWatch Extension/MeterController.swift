//
//  MeterController.swift
//  TrialForceApp
//
//  Created by Rodrigo Reboucas on 8/12/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import WatchKit
import Foundation
import EventKit
import UIKit
import WatchConnectivity

class MeterController:  WKInterfaceController, WCSessionDelegate {
    
    var trialReceived:Trial?

    @IBOutlet weak var imageView: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        
        super.awakeWithContext(context)
        
        trialReceived = context as! Trial?
        
        print("MeterController - checking if Iphone is paired")
        
        if (WCSession.isSupported()) {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
            
            //let context : String = "Ethan"
            
            do {
                var trDictionary = [String: AnyObject]()
                trDictionary["fName"] = trialReceived?.firstName
                trDictionary["lName"] = trialReceived?.lastName
                trDictionary["cName"] = trialReceived?.companyName
                trDictionary["templateId"] = trialReceived?.trialTemplateID
                trDictionary["countryCode"] = trialReceived?.countryCode
                trDictionary["cbURL"] = trialReceived?.connectedAppCallBackURL
                trDictionary["subDomain"] = trialReceived?.subdomain
                trDictionary["userName"] = trialReceived?.userName
                trDictionary["email"] = trialReceived?.email
                trDictionary["consKey"] = trialReceived?.connectedAppConsummerKey
                trDictionary["mSupressed"] = trialReceived?.signupEmailSuppressed
                
                try WCSession.defaultSession().updateApplicationContext(trDictionary)
                //try WCSession.defaultSession().updateApplicationContext(["WCApplicationContext": context])
            } catch {
                print(error)
            }
            
            
        }
        
        
    }
    
    override func willActivate() {
        super.willActivate()
        
        imageView.setImageNamed("Steps-")
        imageView.startAnimating()

        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    

    
}
