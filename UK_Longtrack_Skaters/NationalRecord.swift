//
//  NationalRecord.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 17/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import Foundation

class NationalRecord{
    
    var id: Int = 0
    var date : String = ""
    var time : String = ""
    var location : String = ""
    var distance : Int = 0
    var age : String = ""
    var gender: String = ""
    var skater: Skater = Skater()
    
    init(){}
    init(json: [String:AnyObject]){
        
        if let gender = json["gender"] as? String {
            self.gender =  gender
        }
        
        if let date = json["date"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let actualDate = formatter.dateFromString(date)
            formatter.dateFormat = "dd MMMM yyyy"
            self.date =  formatter.stringFromDate(actualDate!)
        }

        if let time = json["time"] as? String {
            self.time =  time
        }

        if let location = json["location"] as? String {
            self.location =  location
        }

        if let distance = json["distance"] as? Int {
            self.distance =  distance
        }
        
        if let age = json["age"] as? String {
            self.age =  age
        }
        
        if let skater = json["skater"] as? [String:AnyObject] {
            self.skater =  Skater(skaterJson: skater)
        }
        
    }
    
    static func GetNationalRecordsFromJson(jsonData: NSData) -> [NationalRecord]{
        
        var skaters = [NationalRecord]()
        
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
            
            if let nationRecords = json["records"] as? [[String: AnyObject]]{
                
                for record in nationRecords {
                    
                    skaters.append(NationalRecord(json: record))
                    
                }
            }
            
            
        }catch{
            print("error serializing JSON: \(error)")
        }
        
        return skaters
        
    }
    
}