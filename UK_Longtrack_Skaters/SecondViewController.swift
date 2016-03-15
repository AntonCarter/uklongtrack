//
//  SecondViewController.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 15/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SpeedSkatingResultsApi.sharedInstance.GetSkaters(handler)
        SpeedSkatingResultsApi.sharedInstance.GetSkaterPrs(51300, completionHandler: handler)
    }

    func handler(response: String){
        print(response)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

