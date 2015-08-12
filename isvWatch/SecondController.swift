//
//  SecondController.swift
//  TrialForceApp
//
//  Created by Rodrigo Reboucas on 8/10/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import WatchKit
import Foundation
import EventKit
import UIKit

class SecondInterfaceController:  WKInterfaceController {

    var eventsList: [EKEvent] = []
    var selectedEventIndex:Int = 0
    
    @IBOutlet var eventPicker: WKInterfacePicker!
    
    @IBAction func Picker_Tapped(value: Int) {
        
        print("Printer tapped")
        print("Value selected = \(value)")
        selectedEventIndex = value
        
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) ->
        AnyObject? {
            
            var eventToSend = eventsList[selectedEventIndex]
            var eventAttendees = eventToSend.attendees as [EKParticipant]?
            var dictToSend = [String: String]()
            
            //Loop through the collection of partipants to form the dictionary object to send to the new View
            
            for eventAttendee in eventAttendees! {
                dictToSend[eventAttendee.name!] = eventAttendee.URL.resourceSpecifier
            }
            
            
            if segueIdentifier == "hierarchical" {
                return [dictToSend]
            }
            else {
                return ["segue": "", "data": ""]
            }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        
        super.awakeWithContext(context)
        
        var templateName = (context as! NSDictionary)["tempName"] as? String
        var templateId = (context as! NSDictionary)["tempId"] as? String
        
        
         //Working with EventKit
        
        let eventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            granted, error in
            
            print(error)
        })
        
        var calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
        
        var startDate = getFloatingDate(-5)!
        var endDate = getFloatingDate(5)!
        
        
        var pred = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: calendars)
        var events = eventStore.eventsMatchingPredicate(pred) as [EKEvent]
        
        var pickerItems: [WKPickerItem] = []
        for event in events {
            if (event.attendees?.count > 0){
                
                var evTitle = event.title
                var evStartDate = event.startDate
                var participants = event.attendees
                
                
                let item = WKPickerItem()
                item.title = event.title as! String
                pickerItems.append(item)
                
                eventsList.append(event)
                
            }
            
        }
        self.eventPicker.setItems(pickerItems)
        
        for calendar in calendars as [EKCalendar] {
            print("Calendar = \(calendar.title)")
            
            
            //var event = eventStore.eventsMatchingPredicate(<#T##predicate: NSPredicate##NSPredicate#>)
            
        }
        
        

    
    
    }
    
    @IBAction func Event_Tapped() {
    }
    
    func getFloatingDate(daysToAdd: Int) -> NSDate?  {
        let userCalendar = NSCalendar.currentCalendar()
        let currentDate = NSDate()
        let components = NSDateComponents()
        let calOptions = NSCalendarOptions()
        components.day = daysToAdd
        return userCalendar.dateByAddingComponents(components, toDate: currentDate, options: calOptions) as NSDate?
        
    }
    
   
}