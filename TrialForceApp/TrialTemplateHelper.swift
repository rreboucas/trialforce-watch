//
//  TrialTemplateHelper.swift
//  TrialForceApp
//
//  Created by Rodrigo Reboucas on 8/3/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import Foundation
import WatchConnectivity

class TrialTemplateHelper: NSObject, WCSessionDelegate, SFRestDelegate {
    
    var session: WCSession!
    var recordId: String?
    var appName: String?
    
    func register() {
        
        print("TrialTemplateHelper registering for WatchKit sessions")
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
            
        }
    }
    
    class func fetchTrialTemplates(delegate: SFRestDelegate) {
        
        let sharedInstance = SFRestAPI.sharedInstance()
        let query = "SELECT Id,name, lc_trialforce__Active__c,lc_trialforce__Application_Logo__c,lc_trialforce__Connected_App_Callback_URL__c,lc_trialforce__Connected_App_Consumer_Key__c,lc_trialforce__Signup_Email_Suppressed__c,lc_trialforce__Subdomain__c,lc_trialforce__Trialforce_Template_ID__c,lc_trialforce__Version__c FROM lc_trialforce__Trial_App_Template__c ORDER BY Name, lc_trialforce__Version__c"
        let request = sharedInstance.requestForQuery(query) as SFRestRequest
        
        sharedInstance.send(request, delegate: delegate)
        
        
        }
    
    func createSignupRequests (appName:String, firstName: String, lastName: String, companyName:String, templateID:String, countryCode:String, cbURL:String?, subdomain:String?, username:String, email:String, consumKey:String?, emailSupressed:Bool?)-> Void {
        
        print("createSignupRequests main function")
        
        var objApiName: String! = "SignupRequest"
        var fieldsDict = [NSObject: AnyObject]()
        self.appName = appName
        
        
        //var fNameObj:NSObject = "FirstName"
        
        fieldsDict["FirstName"] = firstName
        fieldsDict["LastName"] = lastName
        fieldsDict["Company"] = companyName
        fieldsDict["TemplateId"] = templateID
        fieldsDict["Country"] = countryCode
        fieldsDict["ConnectedAppCallbackUrl"] = cbURL
        fieldsDict["Subdomain"] = subdomain
        fieldsDict["Username"] = username
        fieldsDict["SignupEmail"] = email
        fieldsDict["ConnectedAppConsumerKey"] = consumKey
        fieldsDict["IsSignupEmailSuppressed"] = emailSupressed
        
        
        var sharedInstance = SFRestAPI.sharedInstance()
        var request = sharedInstance.requestForCreateWithObjectType(objApiName, fields: fieldsDict)
        
        sharedInstance.send(request, delegate: self)
        
        
        
        
    }
    
    func request(request: SFRestRequest?, didLoadResponse jsonResponse: AnyObject) {
        
        var records = jsonResponse.objectForKey("records") as! NSArray?
        if records == nil{  // this is a record insert id
            recordId = jsonResponse.objectForKey("id") as! String?
            getTrialCreationStatus(recordId!)
        }
        else {
            
            // this is a return from a query
            var obj : AnyObject! =  records!.objectAtIndex(0)
            var status = obj.objectForKey("Status") as! String
            if status == "Success" {
                var orgId = obj.objectForKey("CreatedOrgId") as! String
                var orgInstance = obj.objectForKey("CreatedOrgInstance") as! String
                var application = appName as String?
                
                var trialDays = obj.objectForKey("TrialDays") as! Int
                var userName = obj.objectForKey("Username") as! String
                var email = obj.objectForKey("SignupEmail") as! String
                
                var notifBody = "\(application) Trial created for \(email) - Username: \(userName) - OrgId: \(orgId) - Instance: \(orgInstance)"
                templtHelper.createLocalIOSNotification(notifBody, fireDate: NSDate(timeIntervalSinceNow: 7))
                
            }
            else{
                getTrialCreationStatus(recordId!)
            }
        }
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func getTrialCreationStatus(recordId: String) -> Void {
        
        delay(20.0) {
            var sharedInstance = SFRestAPI.sharedInstance()
            
            
            var request = sharedInstance.requestForQuery("SELECT CreatedOrgId,CreatedOrgInstance,ErrorCode,Status,TrialDays,TrialSourceOrgId,Username,SignupEmail FROM SignupRequest where id = \'\(recordId)\'")
            
            
            
            sharedInstance.send(request, delegate: self)
        }
        
        
    }
    
    func createLocalIOSNotification (body: String, fireDate: NSDate) -> Void {
        
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = body// text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = fireDate // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)

        
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("heard a request")
        //make sure we are logged in
        if( SFUserAccountManager.sharedInstance().currentUser == nil) {
            print("not logged in")
            replyHandler(["error": "not logged in"])
        } else {
            
            print("prep request")
            let reqType = message["request-type"] as! String
            
            let sharedInstance = SFRestAPI.sharedInstance()
            
            if(reqType == "fetchall") {
                
                //let nextQtr = message["param1"] as! Bool
                //let maxAmt = message["param2"] as! Int
                
                //let query = getAllOpportunitiesQuery(self, nextQuarter: nextQtr, maxOpportunityAmount: maxAmt)
                let query = getAllTrialAppTemplatesQuery(self)
                
                sharedInstance.performSOQLQuery(query, failBlock: { error in
                    replyHandler(["error": error])
                    }) { response in  //success
                        print("sending successful response")
                        replyHandler(["success": response])
                }
                
            } else {
                replyHandler(["error": "no such request-type: "+reqType])
            }
        }
        




    }



    //Salesforce Mobile SDK calls

    func getAllTrialAppTemplatesQuery(delegate: SFRestDelegate) -> String{
        
        return "SELECT Id,name, lc_trialforce__Active__c,lc_trialforce__Application_Logo__c,lc_trialforce__Connected_App_Callback_URL__c,lc_trialforce__Connected_App_Consumer_Key__c,lc_trialforce__Signup_Email_Suppressed__c,lc_trialforce__Subdomain__c,lc_trialforce__Trialforce_Template_ID__c,lc_trialforce__Version__c FROM lc_trialforce__Trial_App_Template__c ORDER BY Name, lc_trialforce__Version__c"
        
        
    }
    
}
