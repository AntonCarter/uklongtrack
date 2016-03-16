//
//  SpeedSkatingResultsApi.swift
//  UK_Longtrack_Skaters
//
//  Created by Anton Carter on 15/03/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import Foundation

class SpeedSkatingResultsApi  {
    static let sharedInstance = SpeedSkatingResultsApi()
    
    let baseURL = "http://speedskatingresults.com/api/json/"

    
    func GetSkatersJson(completionHandler: (response: NSData) -> ()){
        let countryCode = "GBR"
        let ukSkatersUrl = baseURL + "skater_lookup.php?country=\(countryCode)"
        
        makeHTTPGetRequest(ukSkatersUrl, completionHandler: completionHandler)
        
    }
    
    func GetSkaters (handler: (skaters: [Skater]) ->()){
        
        var skaters = [Skater]()
        
                GetSkatersJson({(data: NSData) -> () in
        
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        
                        if let skatersJson = json["skaters"] as? [[String: AnyObject]]{
                            for skaterJson in skatersJson {
                                let skater = Skater()
        
                                if let id = skaterJson["id"] as? Int {
                                    skater.id =  id
                                }
        
                                if let familyName = skaterJson["familyname"] as? String {
                                    skater.familyName =  familyName
                                }
        
                                if let givenName = skaterJson["givenname"] as? String {
                                    skater.givenName =  givenName
                                }
        
                                if let country = skaterJson["country"] as? String {
                                    skater.country =  country
                                }
        
                                if let gender = skaterJson["gender"] as? String {
                                    skater.gender =  gender
                                }
        
                                if let category = skaterJson["category"] as? String {
                                    skater.category =  category
                                }
                                
                                if let category = skaterJson["category"] as? Int {
                                    skater.category =  String(category)                                }
        
                                skaters.append(skater)
                            }
                        }
                        
                    }catch{
                     print("error serializing JSON: \(error)")
                    }
                    
                    }
                    
                )
        
        
        
        handler(skaters: skaters)
    }

    func makeHTTPGetRequest(path: String, completionHandler: (response: NSData) -> ()) {

        let url = NSURL(string:path)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
            completionHandler(response: data!)
        }
        
        task.resume()
    }
}