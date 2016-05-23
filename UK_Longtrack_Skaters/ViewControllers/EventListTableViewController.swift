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
    @IBOutlet weak var RefreshView: UIRefreshControl!
    
    @IBAction func RefreshData(sender: UIRefreshControl) {
        
        dataloaded = false;
        isRefreshing = true;
        _eventRefreshData = [Event]()
        beginParsing()
        
    }
    
    private struct CellTags{
        static let Title = 301
        static let Date = 302
        static let Location = 303
        static let ImageView = 304
    }
    
    private var dataloaded = false
    private var isRefreshing = false
    
    private var _eventData : [Event] = []
    private var _eventRefreshData : [Event] = []
    private var parser = NSXMLParser()
    private var element = NSString()
    private var isEventElement = false
    
    struct Elements {
        static let Event = "vevent"
        static let EventStart = "dtstart"
        static let Title = "summary"
        static let Locaion = "location"
        static let ImageUrl = "x-wp-images-url"
        static let Details = "description"
    }
    
    var eventElements = [
        Elements.EventStart: "",
        Elements.Title: "",
        Elements.Locaion: "",
        Elements.ImageUrl: "",
        Elements.Details: ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //_eventData = DemoData.GetEvents()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        RefreshView.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        if(!isRefreshing){
            beginParsing()
        }
        
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
                    self.RefreshView.endRefreshing()
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
            e.EventDetails = eventElements[Elements.Details]
            
            e.EventImageUrl = ParseImageUrl(eventElements[Elements.ImageUrl] ?? "")
            if let dateString = eventElements[Elements.EventStart] {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyyMMdd\n"
                e.EventDate = formatter.dateFromString(dateString)
                
                
            }
            
            
            
            _eventRefreshData.append(e)
            isEventElement = false
            
            for key in eventElements.keys {
                eventElements[key] = ""
            }
            
        }
    }
    func parserDidEndDocument(parser: NSXMLParser) {
        
        _eventData = _eventRefreshData
        isRefreshing = false
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
                ImageManager.fetchImage(value, imageView:imageView)
            }
        }
        
        return cell
    }
    
    private func selectedEvent() -> Event? {
        var event: Event?
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            event = _eventData[indexPath.row];
        }
        
        return event
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc = segue.destinationViewController
        if let nc = destinationvc as? UINavigationController {
            destinationvc = nc.visibleViewController ?? destinationvc
        }
        
        if let vc = destinationvc as? EventDetailTableViewController {
            vc.EventDetail = selectedEvent()
        }
    }
    
    
}
