//
//  SecondViewController.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 15/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

class BritishRecordsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SpeedSkatingResultsApi.sharedInstance.GetBritishRecordsJson(handler);
    }

   
    func handler(response: NSData){
        print(response)
        
        let records = NationalRecord.GetNationalRecordsFromJson(response)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

