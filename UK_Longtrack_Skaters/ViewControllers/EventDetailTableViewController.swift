//
//  EventDetailTableViewController.swift
//  uk_longtrack_skaters
//
//  Created by Anton Carter on 22/05/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

class EventDetailTableViewController: UITableViewController {

    private struct CellTags{
    static let ImageView = 401
        static let Title = 402
        static let Location = 403
        static let Day = 404
        static let Month = 405
        static let Details = 406
    }
    
    var EventDetail: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("eventDetailCell", forIndexPath: indexPath)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        
        

        if let event = EventDetail {
            if let control = cell.viewWithTag(CellTags.Title) as? UILabel {
                if let value = event.EventTitle {
                    control.text = value
                }
            }
            
            if let control = cell.viewWithTag(CellTags.Location) as? UILabel {
                if let value = event.LocationName {
                    control.text = value
                }
            }

            if let control = cell.viewWithTag(CellTags.Details) as? UITextView {
                if let value = event.EventDetails {
                    control.text = value
                }
            }
            
            if let value = event.EventDate {
                let calendar = NSCalendar.currentCalendar()
                let day = calendar.component(NSCalendarUnit.Day, fromDate: value)
                let month = calendar.component(NSCalendarUnit.Month, fromDate: value)
                let months = dateFormatter.shortMonthSymbols
                
                if let control = cell.viewWithTag(CellTags.Day) as? UILabel {
                    control.text = String(day)
                }
                if let control = cell.viewWithTag(CellTags.Month) as? UILabel {
                    control.text = months[month-1]
                }
            }

            
            if let imageView = cell.viewWithTag(CellTags.ImageView) as? UIImageView {
                if let value = event.EventImageUrl {
                  ImageManager.fetchImage(value, imageView:imageView)
                }
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
