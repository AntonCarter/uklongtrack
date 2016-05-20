//
//  PersonalBestsTableViewController.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 19/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

extension UIViewController{
    var contentViewController:UIViewController{
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        } else{
            return self
        }
    }
}

class PersonalBestsTableViewController: UITableViewController {

    private var currentSkater : Skater?
    private var _records : [NationalRecord] = []
    
    var thisSkater : Skater? {
        get {
            return currentSkater
        }
        set
        {
            var reloadData = false
            
            if newValue == nil{
                clearCurrentSkater()
            }
            else {
                if newValue?.id != currentSkater?.id {
                    reloadData = true
                }
            }
            
            currentSkater = newValue

            setUiForSkater()
            
            if reloadData {
                
                loadSkaterData()
            }
        }
        
    }
    @IBOutlet weak var NoSkaterLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
//        print (self.navigationItem.hidesBackButton)
//        if let backButton = self.navigationItem.backBarButtonItem {
//            //backButton.title = "Back"
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        

        if isCurrentSkater && !isCurrentApplicationSkater {
            thisSkater = AppSettings.AppSkater

        }
        else{
            setUiForSkater()
        }
        


        

        
    }
    @IBOutlet weak var NoSkaterSelectedView: InformationView!
    
    private func setUiForSkater()
    {
        meButton.hidden = false
        self.title = thisSkater?.FullName
        
        if(isCurrentSkater){
         
            if isCurrentApplicationSkater{
                
                self.navigationController?.tabBarItem.title = thisSkater?.givenName
                meButton.setTitle("Not Me", forState: UIControlState.Normal)
            }
            else{
                self.navigationController?.tabBarItem.title = "Current Skater"
                self.navigationItem.title = nil
                meButton.hidden = true
            }
        }else
        {
            if isCurrentApplicationSkater{
                meButton.setTitle("Not Me", forState: UIControlState.Normal)
            }
            else{
                
                meButton.setTitle("Me", forState: UIControlState.Normal)
            }
        }
        
        if(NoSkaterLabel != nil){
       
        if thisSkater == nil{
            NoSkaterLabel.hidden = false
        }
        else{
            NoSkaterLabel.hidden = true
        }
        }
    }
    
    private func loadSkaterData(){
        if let skater = thisSkater {
            SpeedSkatingResultsApi.sharedInstance.GetPersonalBests(skater.id, completionHandler: pbHandler)
        }
        
    }
    
    private func clearCurrentSkater(){
        print ("I am a \(self.description)")
        if isCurrentSkater {
            self._records = []
            self.reloadTableData()
//            self.navigationItem.title = ""
//            self.navigationController?.tabBarItem.title = "Current Skater"
            //self.tabBarItem.title = "Current Skater"
            self.view.setNeedsDisplay()
        }

    }

    var isCurrentApplicationSkater: Bool {
        if let appSkater = AppSettings.AppSkater {
            if let skater = thisSkater{
                return skater.id == appSkater.id
            }
        }
        return false;
    }
    
    var isCurrentSkater : Bool {

        if self.navigationController?.tabBarItem is CurrentSkaterTabBarItem {
            return true
        }
        return false
        
    }



    
    @IBOutlet weak var meButton: UIButton!

    @IBAction func setCurrentSkater(sender: UIButton) {
        
        switch(sender.currentTitle ?? ""){
        
        case "Me":
            sender.setTitle("Not Me", forState: UIControlState.Normal)
            AppSettings.AppSkater = thisSkater
            setUiForSkater()


            
        case "Not Me":
            sender.setTitle("Me", forState: UIControlState.Normal)
            AppSettings.AppSkater = nil
            if isCurrentSkater{
                thisSkater = nil
            }
    
            


        
        default : break
        }
       
    }
    
    func pbHandler(jsonData:NSData){
        
        _records = NationalRecord.GetNationalRecordsFromJson(jsonData)
        reloadTableData()
    }
    
    func reloadTableData () {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return _records.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recordCell", forIndexPath: indexPath)
        
        let record = _records[indexPath.row]
        // Configure the cell...
        if let distanceLabel = cell.viewWithTag(201) as? UILabel {
            distanceLabel.text = String(record.distance)
        }

        if let timeLabel = cell.viewWithTag(202) as? UILabel {
            timeLabel.text = String(record.time)
        }

        if let locationLabel = cell.viewWithTag(203) as? UILabel {
            locationLabel.text = record.location
        }
        
        if let dateLabel = cell.viewWithTag(204) as? UILabel {
            dateLabel.text = record.date
        }
        
        // Configure the cell...

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if ((sender?.isKindOfClass(UITableViewCell)) != nil){
            print("cell")
        }
        
    }
     */

}
