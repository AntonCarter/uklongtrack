//
//  DemoData.swift
//  uk_longtrack_skaters
//
//  Created by Anton Carter on 21/05/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import Foundation


struct DemoData
{
    //static let Stanford = "http://comm.stanford.edu/wp-content/uploads/2013/01/stanford-campus.png"
    
    static let EventImages = [
        "DeUithof" : "http://i0.wp.com/www.uklongtrack.org/wp-content/uploads/2016/05/Screen-Shot-2016-04-10-at-16.54.42.png",
        "BritishChampionships" : "http://i0.wp.com/www.uklongtrack.org/wp-content/uploads/2016/05/Screen-Shot-2016-04-10-at-16.54.42.png"
    ]
    
    static func EventImageNamed(imageName: String?) -> NSURL? {
        if let urlstring = EventImages[imageName ?? ""] {
            return NSURL(string: urlstring)
        } else {
            return nil
        }
    }
    
    static func GetEvents() -> [Event] {
        var _eventData = [Event]()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString("2016-05-27")
        
        let e1 = Event()
        e1.EventTitle = "Back on the ice training weekend"
        e1.EventLocation = "De Uithof"
        e1.EventDate = date
        e1.EventImageUrl = DemoData.EventImageNamed("DeUithof")
        
        let e2 = Event()
        e2.EventTitle = "British Championships"
        e2.EventLocation = "De Uithof"
        e2.EventDate = dateFormatter.dateFromString("2017-03-28")
        e2.EventImageUrl = DemoData.EventImageNamed("BritishChampionships")
        
        _eventData.append(e1)
        _eventData.append(e2)
        _eventData.append(e2)
        _eventData.append(e2)
        _eventData.append(e2)
        _eventData.append(e2)
        _eventData.append(e2)
        _eventData.append(e2)
        _eventData.append(e2)
        _eventData.append(e2)
        
        return _eventData
    }
}