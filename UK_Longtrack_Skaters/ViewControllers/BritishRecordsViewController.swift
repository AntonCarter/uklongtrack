//
//  BritishRecordsViewController.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 19/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

class BritishRecordsViewController: UITableViewController, UIViewControllerPreviewingDelegate {

     var _sections: [String] = ["Ladies", "Men", "Junior Ladies", "Junior Men"]
    
    var _seniorLadies : [NationalRecord] = []
    var _seniorMen : [NationalRecord] = []
    var _juniorLadies : [NationalRecord] = []
    var _juniorMen : [NationalRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if( traitCollection.forceTouchCapability == .Available){
            
            registerForPreviewingWithDelegate(self, sourceView: view)
            
        }
        
        SpeedSkatingResultsApi.sharedInstance.GetBritishRecordsJson(recordHandler)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    class Record: NSObject {
        let record: NationalRecord
        var section: Int?
        
        init(record: NationalRecord) {
            self.record = record
        }
    }
    
    class Section {
        var records: [NationalRecord] = []
        
        func addRecord(record: NationalRecord) {
            self.records.append(record)
        }
    }
    
//    var sections : [Section]{
//        if self._sections != nil {
//            return self._sections!
//        }
//        
//        var section = Section()
//        section.addRecord(NationalRecord)
//    }

    func recordHandler(json : NSData){
        
        let records = NationalRecord.GetNationalRecordsFromJson(json)
        
        
        let seniorMen = records.filter() {$0.age == "sr" && $0.gender == "m"}
        let seniorLadies = records.filter() {$0.age == "sr" && $0.gender == "f"}

        let juniorMen = records.filter() {$0.age == "jr" && $0.gender == "m"}
        let juniorLadies = records.filter() {$0.age == "jr" && $0.gender == "f"}
        
        _seniorLadies = seniorLadies
        _seniorMen = seniorMen
        _juniorLadies = juniorLadies
        _juniorMen = juniorMen
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        
        
    }
    
    func getDataForSection(section: Int) -> [NationalRecord] {
        if(section==0){
            return _seniorLadies
        }
        if(section==1){
            return _seniorMen
        }
        if(section==2){
            return _juniorLadies
        }
        if(section==3){
            return _juniorMen
        }
        
        return [NationalRecord]()
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location) else {return nil}
        
        let record = getDataForSection(indexPath.section)[indexPath.row]
    
        if let resultController = storyboard!.instantiateViewControllerWithIdentifier("PBViewController") as? PersonalBestsTableViewController {
            
            resultController.thisSkater = record.skater
            return resultController
            
        }
        
        return nil;
        
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return _sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section==0){
            return _seniorLadies.count;
        }
        if(section==1){
            return _seniorMen.count;
        }
        if(section==2){
            return _juniorLadies.count;
        }
        if(section==3){
            return _juniorMen.count;
        }
        
        return 0;
    }

    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
         
            if(section==0){
                return "Senior Ladies"
            }

            if(section==1){
                return "Senior Men"
            }
            
            if(section==2){
                return "Junior Ladies"
            }
            
            if(section==3){
                return "Junior Men"
            }
            return ""
    }
    
    @IBAction func resultsLinkClicked(sender: UIButton) {
        UIApplication.sharedApplication().openURL(SpeedSkatingResultsApi.GetWebUrl())
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nationalRecordCell", forIndexPath: indexPath)
            
            var record : NationalRecord?
            
            if(indexPath.section == 0){
                record = _seniorLadies[indexPath.row]
            }
            if(indexPath.section == 1){
                record = _seniorMen[indexPath.row]
            }
            if(indexPath.section == 2){
                record = _juniorLadies[indexPath.row]
            }
            if(indexPath.section == 3){
                record = _juniorMen[indexPath.row]
            }
            
            
            if (record !=  nil) {
                
                if let label = cell.viewWithTag(301) as? UILabel {
                    label.text = String(record!.distance)
                }
                
                if let label = cell.viewWithTag(302) as? UILabel {
                    label.text = record!.time
                }
                
                if let label = cell.viewWithTag(303) as? UILabel {
                    label.text = "\(record!.skater.givenName) \(record!.skater.familyName)"
                }
                
                if let label = cell.viewWithTag(304) as? UILabel {
                    label.text = record!.date
                }
                
                if let label = cell.viewWithTag(305) as? UILabel {
                    label.text = record!.location
                }

            }
   
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
    }
    */

}
