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

    
    func GetSkaters(completionHandler: (response: String) -> ()){
        let countryCode = "GBR"
        let ukSkatersUrl = baseURL + "skater_lookup.php?country=\(countryCode)"
        
        makeHTTPGetRequest(ukSkatersUrl, completionHandler: completionHandler)
        
    }
    
    func GetSkaterPrs(skaterId:Int, completionHandler:(response: String) -> ()){
        let ukSkatersUrl = baseURL + "personal_records.php?skater=\(skaterId)"
        makeHTTPGetRequest(ukSkatersUrl, completionHandler: completionHandler)
    }
    
    func makeHTTPGetRequest(path: String, completionHandler: (response: String) -> ()) {

        let url = NSURL(string:path)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
            completionHandler(response: responseString! as String)
        }
        
        task.resume()
    }
}