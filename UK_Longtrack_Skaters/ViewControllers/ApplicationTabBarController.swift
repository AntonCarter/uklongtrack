//
//  ApplicationTabBarController.swift
//  uk_longtrack_skaters
//
//  Created by Anton Carter on 15/05/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

class ApplicationTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? PersonalBestsTableViewController {
            vc.thisSkater = AppSettings.AppSkater ?? Skater()
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    


    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController){
        print(tabBarController.selectedIndex)
        
        let nc = viewController as? UINavigationController
        
        if let vc = nc?.visibleViewController as? PersonalBestsTableViewController {
            
            if let skater = AppSettings.AppSkater {
                vc.thisSkater = skater
            }
            
        }
    }
}
