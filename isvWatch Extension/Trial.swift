//
//  Trial.swift
//  TrialForceApp
//
//  Created by Rodrigo Reboucas on 8/12/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import Foundation
import EventKit

class Trial {
    
    var templateName:String? = ""
    var firstName:String? = ""
    var lastName:String? = ""
    var email:String? = ""
    var userName:String? = ""
    var trialTemplateID:String? = ""
    var companyName:String? = ""
    var countryCode:String? = ""
    var connectedAppCallBackURL:String? = ""
    var signupEmailSuppressed:Bool? = false
    var connectedAppConsummerKey:String? = ""
    var subdomain:String? = ""
    var attendees:[EKParticipant]? = []
    
    init() {}
    
    init(templateName:String?, trialTemplateID:String?, connectedAppCallBackURL:String?, signupEmailSuppressed:Bool?, connectedAppConsummerKey:String?, subdomain:String?) {
        self.templateName = templateName
        self.trialTemplateID = trialTemplateID
        self.connectedAppCallBackURL = connectedAppCallBackURL
        self.signupEmailSuppressed = signupEmailSuppressed
        self.connectedAppConsummerKey = connectedAppConsummerKey
        self.subdomain = subdomain
    }
    
}
