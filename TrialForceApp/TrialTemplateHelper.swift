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
        
/*var replyHandler: [String : AnyObject]
replyHandler = ["": ""]

sharedInstance.performSOQLQuery(query, failBlock: { error in
replyHandler = ["error": error]
}) { response in  //success
print("sending successful response")
replyHandler = ["success": response]
}



return replyHandler

*/



    }



    //Salesforce Mobile SDK calls

    func getAllTrialAppTemplatesQuery(delegate: SFRestDelegate) -> String{
        
        return "SELECT Id,name, lc_trialforce__Active__c,lc_trialforce__Application_Logo__c,lc_trialforce__Connected_App_Callback_URL__c,lc_trialforce__Connected_App_Consumer_Key__c,lc_trialforce__Signup_Email_Suppressed__c,lc_trialforce__Subdomain__c,lc_trialforce__Trialforce_Template_ID__c,lc_trialforce__Version__c FROM lc_trialforce__Trial_App_Template__c ORDER BY Name, lc_trialforce__Version__c"
        
        
    }
    
}
