//
//  Skater.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 16/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import Foundation

class Skater{
    var id: Int = 0
    var familyName : String = ""
    var givenName : String = ""
    var country : String = ""
    var gender : String = ""
    var category: String = ""
   
    init(){}
    init(skaterJson : [String:AnyObject]){
        
        if let id = skaterJson["id"] as? Int {
            self.id =  id
        }
        
        if let familyName = skaterJson["familyname"] as? String {
            self.familyName =  familyName
        }
        
        if let givenName = skaterJson["givenname"] as? String {
            self.givenName =  givenName
        }
        
        if let country = skaterJson["country"] as? String {
            self.country =  country
        }
        
        if let gender = skaterJson["gender"] as? String {
            self.gender =  gender
        }
        
        if let category = skaterJson["category"] as? String {
            self.category =  category
        }
        
        if let category = skaterJson["category"] as? Int {
            self.category =  String(category)
        }
    }
    
    static func GetSkatersFromJson(jsonData: NSData) -> [Skater]{
        
        var skaters = [Skater]()
        
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments)
            
            if let skatersJson = json["skaters"] as? [[String: AnyObject]]{
            
                for skaterJson in skatersJson {
                    
                    skaters.append(Skater(skaterJson: skaterJson))
                
                }
            }
            
            
        }catch{
            print("error serializing JSON: \(error)")
        }
        
        return skaters
        
    }
}