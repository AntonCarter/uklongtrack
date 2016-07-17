//
//  Event.swift
//  uk_longtrack_skaters
//
//  Created by Anton Carter on 21/05/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import Foundation

class Event {
    private var _address: String?
    private var _locationName: String?
    private var _detailsWithLocation: String?
    
    var EventTitle: String?
    var EventDate: NSDate?
    var EventLocation: String?
    var EventImageUrl: NSURL?
    var EventDetails: String?
    var DetailsWithLocation: String? {
        get {
            if _detailsWithLocation == nil {
                _detailsWithLocation = EventDetails! + EventAddress!
            }
            return _detailsWithLocation
        }
    }
    
    var EventAddress: String? {
        get{
            
            if(_address == nil){
                _address = ParseAddressFromLocation(EventLocation!);
            }
            return _address
        }
    }
    var LocationName: String?{
        get{
            if _locationName == nil{
                _locationName = ParseLocationNameFromLocation(EventLocation!)
            }
            return _locationName
        }
    }
    
    func ParseAddressFromLocation(location: String) -> String {
        if let startOfAddress = location.rangeOfString("@", options: NSStringCompareOptions.LiteralSearch) {
            let addressRange = Range(startOfAddress.endIndex.advancedBy(1)..<location.endIndex)
         
            
                let address = location[addressRange]
                return address
            
        }
        
        return "";
    }
    
    func ParseLocationNameFromLocation(location: String) -> String {
        if let endOfName = location.rangeOfString("@", options: NSStringCompareOptions.LiteralSearch) {
            let nameRange = Range( location.startIndex..<endOfName.endIndex.advancedBy(-1) )
            
            
            let name = location[nameRange]
            return name
            
        }
        
        return "";
    }
    
}