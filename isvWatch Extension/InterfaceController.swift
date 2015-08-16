//
//  InterfaceController.swift
//  isvWatch Extension
//
//  Created by Rodrigo Reboucas on 8/3/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UIKit

var  controlleReceivedData: NSData = NSData()

class InterfaceController:  WKInterfaceController, WCSessionDelegate, WKExtensionDelegate {
    
    var session : WCSession!
    var context = [String: AnyObject]()
    var phData: AnyObject?
    var dicts:NSArray = []
    var selectedTemplateIndex:Int = 0
    var receivedDictionary = [String : AnyObject]()
    
    // comment
    //new

    @IBOutlet var trialPicker: WKInterfacePicker!
    
    @IBAction func Picker_Tapped(value: Int) {
        print("Printer tapped")
        print("Value selected = \(value)")
        selectedTemplateIndex = value
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) ->
        AnyObject? {
            
            var dataToSend = dicts[selectedTemplateIndex] as! NSDictionary
            
            var tmpName = dataToSend["Name"] as? String
            var tmpId = dataToSend["lc_trialforce__Trialforce_Template_ID__c"] as? String
            var cbUrl = dataToSend["lc_trialforce__Connected_App_Callback_URL__c"] as? String
            var emailSup = dataToSend["lc_trialforce__Signup_Email_Suppressed__c"] as? Bool
            var consKey = dataToSend["lc_trialforce__Connected_App_Consumer_Key__c"] as? String
            var subdomain = dataToSend["lc_trialforce__Subdomain__c"] as? String

            var trial = Trial(templateName: tmpName, trialTemplateID: tmpId, connectedAppCallBackURL: cbUrl, signupEmailSuppressed: emailSup, connectedAppConsummerKey: consKey, subdomain: subdomain)
            
            if segueIdentifier == "hierarchical" {
                return trial
                //return ["tempName": tmpName, "tempId":tmpId]
            }
            else {
                return ["segue": "", "data": ""]
            }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        
        
        
        /*var imgbyte =

        var imgCru = NSData(base64Encoding: imgbyte)
        var imgeWK = WKImage(imageData: imgCru!);
*/
        
        super.awakeWithContext(context)
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()

            
            var applicationData = context
            print("applicationData =  \(applicationData)")
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let savedTemplates = defaults.dataForKey("trialTemplates")
            {
                // Unarchive NSData
                phData = NSKeyedUnarchiver.unarchiveObjectWithData(savedTemplates) as AnyObject?
                print("phData =  \(phData)")
                let objct = phData as! NSDictionary
                loadPickerData(objct)
                
            }
            /*else {
                if applicationData == nil{
                    // send message to ios app to receive list of templates
                    if (WCSession.isSupported()) {
                        let session = WCSession.defaultSession()
                        session.delegate = self
                        session.activateSession()
                        
                        if WCSession.defaultSession().reachable == true {
                            
                            let requestValues = ["command" : "sendmetrialtemplates"]
                            let session = WCSession.defaultSession()
                            
                            
                            session.sendMessage(requestValues, replyHandler: { reply in
                                //handle iphone response here
                                if(reply["results"] != nil) {
                                    self.receivedDictionary = reply
                                    
                                }
                                
                                }, errorHandler: {(error ) -> Void in
                                    // catch any errors here
                            })
                            
                            if receivedDictionary.count > 0 {
                                let receivedNSData:NSData = (receivedDictionary["results"] as? NSData)!
                                
                                // Save NSData to NSUserDefaults local storage
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(receivedNSData, forKey: "trialTemplates")
                                
                                // Unarchive NSData
                                phData = NSKeyedUnarchiver.unarchiveObjectWithData(receivedNSData) as AnyObject?
                                print("phData =  \(phData)")
                                let objct = phData as! NSDictionary
                                loadPickerData(objct)
                            }
                            
                            
                            
                        }
                        
                        
                    }
                }
            }*/
            

    }
        }
        
        
        /* Configure interface objects here.
        var pickerItems: [WKPickerItem] = []
        for i in 1...10 {
            let item = WKPickerItem()
            item.title = "Picker item \(i)"
            //item.accessoryImage = WKImage(imageName: "apple")
            //item.contentImage = imgeWK
            pickerItems.append(item)
        }
        self.trialPicker.setItems(pickerItems)

    }

*/
    
    private func loadPickerData(objct: NSDictionary) {
        
        dicts = objct["results"] as!NSArray
        var pickerItems: [WKPickerItem] = []
        for dict in dicts {
            var imgbyte = dict["lc_trialforce__Template_Logo__c"] as! String
            var imgCru = NSData(base64Encoding: imgbyte)
            var imgeWK = WKImage(imageData: imgCru!);
            let item = WKPickerItem()
            item.contentImage = imgeWK
            pickerItems.append(item)
        }
        self.trialPicker.setItems(pickerItems)
        
        /*
        dicts = objct["results"] as!NSArray
        
        // Set Picker Items on Scene with new list of options
        var pickerItems: [WKPickerItem] = []
        for dict in dicts {
            var tmpName = dict["Name"] as! String
            //var templateID = dict["lc_trialforce__Trialforce_Template_ID__c"] as! String
            print("didReceiveApplicationContext: tmpName = \(tmpName)")
            let item = WKPickerItem()
            item.title = tmpName as! String
            pickerItems.append(item)
        }
        self.trialPicker.setItems(pickerItems)
        */
    
    }

    @IBAction func TrialPicker_Selected(value: Int) {
        
        print("Value selected = \(value)")
        print("dicts = \(dicts)")
        
    }
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        
        
        print("Controller didReceiveApplicationContext =  \(applicationContext)")
        let receivedNSData:NSData = (applicationContext["results"] as? NSData)!
        
        // Save NSData to NSUserDefaults local storage
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(receivedNSData, forKey: "trialTemplates")
        
        // Unarchive NSData
        phData = NSKeyedUnarchiver.unarchiveObjectWithData(receivedNSData) as AnyObject?
        print("phData =  \(phData)")
        let objct = phData as! NSDictionary
        loadPickerData(objct)
        
        
    }
    

}
