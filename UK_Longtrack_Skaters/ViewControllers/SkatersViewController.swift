//
//  SkatersViewController.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 15/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

class SkatersViewController: UITableViewController, UISearchBarDelegate {

    var _skaters:[Skater] = []
    var _filteredSkaters:[Skater] = []
    var _searchActive = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SpeedSkatingResultsApi.sharedInstance.GetSkatersJson(handleSkaters)

        searchBar.showsCancelButton = true
        searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func handleSkaters(skaterData:NSData) {
        
        let newSkaters = Skater.GetSkatersFromJson(skaterData)
        
        if(newSkaters.count>0){
            _filteredSkaters.appendContentsOf(newSkaters)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let search = searchBar.text{
            _searchActive = true;
            _filteredSkaters = [Skater]()
            SpeedSkatingResultsApi.sharedInstance.SearchSkatersJson(search, completionHandler: handleSkaters)
        }
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismissKeyboard();
        _searchActive = false
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
        if(_searchActive){
            return _filteredSkaters.count
        }
        return _skaters.count
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBOutlet weak var search: UISearchBar!
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("skaterCell", forIndexPath: indexPath)
        var skater = Skater()
        
        if(_searchActive){
            skater = _filteredSkaters[indexPath.row];
        }else{
            skater = _skaters[indexPath.row];
        }
        
        
        let fn = skater.familyName
        let gn = skater.givenName
        
        // Configure the cell...
        if let nameLabel = cell.viewWithTag(100) as? UILabel {
            nameLabel.text = "\(gn) \(fn)"
        }

        if let genderLabel = cell.viewWithTag(101) as? UILabel {
            if(skater.gender == "m"){
                genderLabel.text = "Male"
            }else if(skater.gender == "f"){
                genderLabel.text = "Female"
            }
            else{
                genderLabel.text = ""
            }
        }
        
        if let categoryLabel = cell.viewWithTag(102) as? UILabel {
            categoryLabel.text = "\(skater.category)"
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
