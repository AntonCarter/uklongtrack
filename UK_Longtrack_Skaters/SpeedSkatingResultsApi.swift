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
    
    func GetBritishRecordsJson(completionHandler: (response: NSData) -> ()){
        
        let countryCode = "GBR"
        let ukSkatersUrl = baseURL + "country_records.php?country=\(countryCode)"
    
        makeHTTPGetRequest(ukSkatersUrl, completionHandler: completionHandler)
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