//
//  HomeViewController.swift
//  TrialForceApp
//
//  Created by Rodrigo Reboucas on 8/4/15.
//  Copyright © 2015 Salesforce Inc. All rights reserved.
//


class HomeViewController: UIViewController, SFRestDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Loaded")
        // Do any additional setup after loading the view, typically from a nib.
        
        
        TrialTemplateHelper.fetchTrialTemplates(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: salesforce delegate events
    func request(request: SFRestRequest?, didLoadResponse jsonResponse: AnyObject) {
        //add response code here
        print(jsonResponse)
        
    }
    func request(request: SFRestRequest?, didFailLoadWithError error:NSError) {
        print("-->In Error: \(error)")
    }
    
    func requestDidCancelLoad(request: SFRestRequest) {
        print("In requestDidCancelLoad \(request)")
    }
    
    func requestDidTimeout(request: SFRestRequest) {
        print("In requestDidTimeout \(request)")
    }
    
    
    @IBOutlet weak var tblView: UITableView!
    
}
