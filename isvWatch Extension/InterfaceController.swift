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

var  controlleReceivedData: NSData = NSData()

class InterfaceController:  WKInterfaceController, WCSessionDelegate, WKExtensionDelegate {
    
    var session : WCSession!
    var context = [String: AnyObject]()
    var phData: AnyObject?
    // comment
    //new

    @IBOutlet var trialPicker: WKInterfacePicker!
    
    override func awakeWithContext(context: AnyObject?) {
        
        
        
        var imgbyte = "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"

        var imgCru = NSData(base64Encoding: imgbyte)
        var imgeWK = WKImage(imageData: imgCru!);
        
        super.awakeWithContext(context)
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
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
                let dicts:NSArray = objct["results"] as!NSArray
                
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
            }
            //let dicts = defaults.stringForKey("trialTemplates") as!NSArray
       

            
            
            /*
            if (WCSession.defaultSession().reachable) {
                session.sendMessage(applicationData, replyHandler: { replyDict in
                    }, errorHandler: { error in
                })
                
                session.sendMessage(applicationData, replyHandler: { reply in
                    //handle iphone response here
                    if(reply["success"] != nil) {
                        print("got here")
                        let a:AnyObject = reply["success"] as! NSDictionary
                        self.loadPickerData(a as! NSDictionary)
                    }
                    
                    }, errorHandler: {(NSError error) -> Void in
                        // catch any errors here
                        print(error)
                })*/
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
    
    private func loadPickerData(results: NSDictionary) {
        //results come in 3 elements* "done"(bool), "totalSize"(nsnumber), and "records"(NSArray)
        
        let records:NSArray = results["records"] as! NSArray
        var pickerItems: [WKPickerItem] = []
        
        for (index, record) in records.enumerate() {
            //let row = optyTable.rowControllerAtIndex(index) as! OpportunityRowController
            let item = WKPickerItem()
            let s: NSDictionary = record as! NSDictionary
            
            item.title = s["Name"] as? String
            pickerItems.append(item)
        }
        self.trialPicker.setItems(pickerItems)
    }
*/

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
        let dicts:NSArray = objct["results"] as!NSArray
        
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
        
        
        
        //context = phData
    }
    

}
