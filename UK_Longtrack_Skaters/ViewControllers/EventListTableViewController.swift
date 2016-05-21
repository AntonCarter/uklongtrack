//
//  EventListTableViewController.swift
//  uk_longtrack_skaters
//
//  Created by Anton Carter on 21/05/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import UIKit

class EventListTableViewController: UITableViewController, NSXMLParserDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private struct CellTags{
        static let Title = 301
        static let Date = 302
        static let Location = 303
        static let ImageView = 304
    }
    var dataloaded = false
    
    private var _eventData : [Event] = []
    var parser = NSXMLParser()
    var element = NSString()
    var isEventElement = false
    
    struct Elements {
        static let Event = "vevent"
        static let EventStart = "dtstart"
        static let Title = "summary"
        static let Locaion = "location"
        static let ImageUrl = "x-wp-images-url"
    }
    
    var eventElements = [Elements.EventStart: "", Elements.Title: "", Elements.Locaion: "", Elements.ImageUrl: ""]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //_eventData = DemoData.GetEvents()

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {

        beginParsing()
        
    }
    
    func beginParsing()
    {
        if !dataloaded {
            
    
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            self.spinner?.startAnimating()
            self.parser = NSXMLParser(contentsOfURL:(NSURL(string:DemoData.CalendarUrl))!)!
            self.parser.delegate = self
            self.parser.parse()
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView!.reloadData()
                self.spinner?.stopAnimating()
            }
        }
    }
        
        
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if element == Elements.Event {
            isEventElement = true
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if isEventElement {
            print(element)
            eventElements[element as String]?.appendContentsOf(string)
        }
        
        
        //        if element.isEqualToString(Elements.Title) {
        //
        //        } else if element.isEqualToString(Elements.Locaion) {
        //            if(
        //            parseEvent.EventLocation = string
        //        } else if element.isEqualToString(Elements.EventStart) {
        //            let formatter = NSDateFormatter()
        //            formatter.dateFormat = "yyyyMMdd"
        //            parseEvent.EventDate = formatter.dateFromString(string)
        //        }
    }
    
    func ParseImageUrl(url: String) -> NSURL {
        if let rangeOfThumbnail = url.rangeOfString("thumbnail", options: NSStringCompareOptions.LiteralSearch) {
            if let endOfUrl = url.rangeOfString("?") {
                let range = Range(rangeOfThumbnail.endIndex.advancedBy(1)..<endOfUrl.endIndex.advancedBy(-1))
                let thumb = url[range]
                return  NSURL(string: thumb) ?? NSURL()
            }
        }
        
        return NSURL()
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString(Elements.Event) {
            let e = Event()
            e.EventTitle = eventElements[Elements.Title]
            e.EventLocation = eventElements[Elements.Locaion]
            e.EventImageUrl = ParseImageUrl(eventElements[Elements.ImageUrl] ?? "")
            if let dateString = eventElements[Elements.EventStart] {
                            let formatter = NSDateFormatter()
                            formatter.dateFormat = "yyyyMMdd\n"
                            e.EventDate = formatter.dateFromString(dateString)
                
                
            }
            
            
            
            _eventData.append(e)
            isEventElement = false
            
            for key in eventElements.keys {
                eventElements[key] = ""
            }
            
        }
    }
    func parserDidEndDocument(parser: NSXMLParser) {
        dataloaded = true
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
        return _eventData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        
        let event = _eventData[indexPath.row]
        // Configure the cell...
        if let distanceLabel = cell.viewWithTag(CellTags.Title) as? UILabel {
            if let value = event.EventTitle {
                distanceLabel.text = value
            }
        }
        
        if let timeLabel = cell.viewWithTag(CellTags.Date) as? UILabel {
            if let value = event.EventDate {
                timeLabel.text = formatter.stringFromDate(value)
            }
            
        }
        
        if let locationLabel = cell.viewWithTag(CellTags.Location) as? UILabel {
            if let value = event.EventLocation {
                locationLabel.text = value
            }
        }
        
        if let imageView = cell.viewWithTag(CellTags.ImageView) as? UIImageView {
            if let value = event.EventImageUrl {
                fetchImage(value, imageView:imageView)
            }
        }
        
        return cell
    }
    
    private func fetchImage(imageURL: NSURL?, imageView: UIImageView) {
        
        if let url = imageURL {
            // fire up the spinner
            // because we're about to fork something off on another thread
            // spinner?.startAnimating()
            // put a closure on the "user initiated" system queue
            // this closure does NSData(contentsOfURL:) which blocks
            // waiting for network response
            // it's fine for it to block the "user initiated" queue
            // because that's a concurrent queue
            // (so other closures on that queue can run concurrently even as this one's blocked)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let contentsOfURL = NSData(contentsOfURL: url) // blocks! can't be on main queue!
                // now that we got the data from the network
                // we want to put it up in the UI
                // but we can only do that on the main queue
                // so we queue up a closure here to do that
                dispatch_async(dispatch_get_main_queue()) {
                    // since it could take a long time to fetch the image data
                    // we make sure here that the image we fetched
                    // is still the one this ImageViewController wants to display!
                    // you must always think of these sorts of things
                    // when programming asynchronously
                    
                    if let imageData = contentsOfURL {
                        imageView.image = UIImage(data: imageData)!
                        //  imageView.setNeedsDisplay()
                        // image's set will stop the spinner animating
                    }
                }
            }
        }
        
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
