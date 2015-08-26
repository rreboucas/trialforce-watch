//
//  ThirdController.swift
//  TrialForceApp
//
//  Created by Rodrigo Reboucas on 8/12/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import WatchKit
import Foundation
import EventKit
import UIKit

class ThirdInterfaceController:  WKInterfaceController {
    
    var attendeesList: [EKParticipant] = []
    var selectedParticipantIndex:Int = 0
    var trialReceived:Trial?
    @IBOutlet var Contact_Picker: WKInterfacePicker!
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) ->
        AnyObject? {
            
            var partipant = attendeesList[selectedParticipantIndex]
            var fullName = partipant.name
            var nameArray = split(fullName!.characters, maxSplit: Int.max, allowEmptySlices: false, isSeparator: { $0 == " " })
                .map ( { String($0) } )
            
            if nameArray.count > 1{
                trialReceived?.firstName = nameArray[0]
                trialReceived?.lastName = nameArray[1]
            }
            else{
                trialReceived?.firstName = partipant.name
                trialReceived?.lastName = "Test"
            }
            trialReceived?.countryCode = "US"
            
            var email = partipant.URL.resourceSpecifier
            trialReceived?.email = email
            trialReceived?.userName = email + "\(NSDate().timeIntervalSince1970 * 10)"
            
            var companyArray = split(email.characters, maxSplit: Int.max, allowEmptySlices: false, isSeparator: { $0 == "@" })
                .map ( { String($0) } )
            
            if companyArray.count > 1{
                var domainArray = split(companyArray[1].characters, maxSplit: Int.max, allowEmptySlices: false, isSeparator: { $0 == "." })
                    .map ( { String($0) } )
                if domainArray.count > 1{
                    trialReceived?.companyName = domainArray[0]
                }
                else {
                    trialReceived?.companyName = nameArray[1]
                }
                
            }
            else{
                trialReceived?.companyName = "Test"
            }
            
            
            //

            
            
            if segueIdentifier == "hierarchical" {
                return trialReceived
                //return eventAttendees
            }
            else {
                return ["segue": "", "data": ""]
            }
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        
        super.awakeWithContext(context)
        
        trialReceived = context as! Trial?
        var eventAttendees = trialReceived?.attendees
        attendeesList = eventAttendees!
        //var eventAttendees = context as! [EKParticipant]?
        
        var pickerItems: [WKPickerItem] = []
        for eventAttendee in eventAttendees! {
            
            let item = WKPickerItem()
            item.title = eventAttendee.name
            //var img = UIImage(contentsOfFile: "/Users/rreboucas/Documents/WatchAppPics/contact3.png")
            var img = UIImage(named: "contact3.png")
            var imgWk = WKImage(image: img!)
            item.accessoryImage = imgWk
            pickerItems.append(item)

            
        }
        
        self.Contact_Picker.setItems(pickerItems)
        
    }


    @IBAction func Picker_Tapped(value: Int) {
        print("Printer tapped")
        print("Value selected = \(value)")
        selectedParticipantIndex = value
    }
}