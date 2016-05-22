//
//  SkatersViewController.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 15/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

class SkatersViewController: UITableViewController, UISearchBarDelegate, UIViewControllerPreviewingDelegate {

    var _skaters:[Skater] = []
    var _filteredSkaters:[Skater] = []
    var _searchActive = false
    var _updatingResults = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if( traitCollection.forceTouchCapability == .Available){
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
        
        //SpeedSkatingResultsApi.sharedInstance.GetSkatersJson(handleSkaters)

        searchBar.showsCancelButton = true
        searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func resultsLinkClicked(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(SpeedSkatingResultsApi.GetWebUrl())
        
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func removeDuplicates(skaters: [Skater]) -> [Skater] {
        
        var newSkaters: [Skater] = []
        var ids : [Int] = []
        
        for skater in skaters {
            if(!ids.contains(skater.id)){
                    ids.append(skater.id)
                    newSkaters.append(skater)
            }
            
        }
        
        return newSkaters
        
    }
    
    func handleSkaters(skaterData:NSData) {
        
        let newSkaters = Skater.GetSkatersFromJson(skaterData)//.sort(){$0.givenName > $1.givenName}
        
        if(newSkaters.count>0){
            var r = [Skater]()
            r.appendContentsOf(_filteredSkaters)
            r.appendContentsOf(newSkaters)
            r = removeDuplicates(r)
          
            r.sortInPlace({$0.familyName < $1.familyName})
            _filteredSkaters = r
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        

    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location) else {return nil}
        
        
   
            
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            previewingContext.sourceRect = cell.frame
        }
            
        
        let skater = _filteredSkaters[indexPath.row]
        
       
        if let resultController = storyboard!.instantiateViewControllerWithIdentifier("PBViewController") as? PersonalBestsTableViewController {
            
            resultController.thisSkater = skater
            return resultController
          
        }
    
        return nil;
        
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
  
        
        showViewController(viewControllerToCommit, sender: self)
        
        
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let search = searchBar.text{
            _searchActive = true;
            _filteredSkaters = [Skater]()
            SpeedSkatingResultsApi.sharedInstance.SearchSkatersJson(search, completionHandler: handleSkaters)
        }
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        _skaters = _filteredSkaters;
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
    
    override func tableView(tableView: UITableView,
                              willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        dismissKeyboard()
        return indexPath
        
    }
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true);
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("skaterCell", forIndexPath: indexPath)
        let rowIndex = indexPath.row
        
        if rowIndex < _filteredSkaters.count {
            var skater = Skater()
            
            if(_searchActive){
                skater = _filteredSkaters[rowIndex
                ];
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
        }
        
        
        
        return cell
    }

    private func selectedSkater() -> Skater? {
        var skater: Skater?
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            
            if(_searchActive){
                skater = _filteredSkaters[indexPath.row];
            }else{
                skater = _skaters[indexPath.row];
            }
        }
        
        return skater
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        segue.destinationViewController.title = "\(_selectedSkater.givenName) \(_selectedSkater.familyName)"

        var destinationvc = segue.destinationViewController
        if let nc = destinationvc as? UINavigationController {
            destinationvc = nc.visibleViewController ?? destinationvc
        }
        
        if let vc = destinationvc as? PersonalBestsTableViewController {
            vc.thisSkater = selectedSkater()
        }
        
    }


}
