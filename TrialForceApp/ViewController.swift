//
//  ViewController.swift
//  TrialForceApp
//
//  Created by Rodrigo Reboucas on 8/3/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SFAuthenticationManagerDelegate {

    @IBOutlet weak var btnConnectSFDC: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnConnectSFDC_Click(sender: AnyObject) {
        
        //SalesforceSDKManager.sharedManager().launch()
    }
    
    func authManagerDidFinish(manager: SFAuthenticationManager!, info: SFOAuthInfo!) {
        
        //need to perform this check at the end of the authmanager lifecycle
        //because SFRootViewManager removes the current view after didAUthenticate gets called :(
        print("Chegou aqui antes do if")
        
        if !SFUserAccountManager.sharedInstance().currentUser.userName.isEmpty {
            print("Chegou aqui depois do if")
            self.performSegueWithIdentifier("loggedIn", sender: nil)
            
            /* old watchos way of comms
            print(appGroupID)
            
            
            if let defaults = NSUserDefaults(suiteName: appGroupID) {
            defaults.setValue(SFUserAccountManager.sharedInstance().currentUser.userName, forKey: "username")
            defaults.synchronize()
            }
            */
            
            
        }
        //TrialTemplateHelper.fetchTrialTemplates();
        
        
    }

}

