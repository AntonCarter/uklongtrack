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
    var searchData = [NSData]()
    
    static let speedskatingResultUrl = "http://speedskatingresults.com/"
    let baseURL = speedskatingResultUrl + "/api/json/"

    internal static func GetWebUrl() -> NSURL {
        let url = NSURL(string: speedskatingResultUrl)
        return url!
    }

    
    func GetPersonalBests(skaterId: Int, completionHandler: (response: NSData) ->()){
        let search = baseURL + "personal_records.php?skater=\(skaterId)"
        makeHTTPGetRequest(search, completionHandler:   completionHandler)
    }
    
    func GetSeasonBests(skaterId: Int, completionHandler: (response: NSData) ->()){
        let search = baseURL + "season_bests.php?skater=\(skaterId)"
        makeHTTPGetRequest(search, completionHandler:   completionHandler)
    }
    
    func SearchSkatersJson(searchText: String, completionHandler: (response: NSData) -> ()){
        
        let trimmedSearchText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let fullNameArr = trimmedSearchText.characters.split(" ", maxSplit: 2, allowEmptySlices: false).map(String.init)
        
        if (fullNameArr.count==1){
            
            let countryCode = "GBR"
            let ukSkatersUrlFamilyNameSearch = baseURL + "skater_lookup.php?country=\(countryCode)&familyname=\(trimmedSearchText)"
            let ukSkatersUrlGivenNameSearch = baseURL + "skater_lookup.php?country=\(countryCode)&givenname=\(trimmedSearchText)"
            
            makeHTTPGetRequest(ukSkatersUrlFamilyNameSearch, completionHandler:   completionHandler)
            makeHTTPGetRequest(ukSkatersUrlGivenNameSearch, completionHandler:   completionHandler)
        }
        
        if (fullNameArr.count==2){
            
            let countryCode = "GBR"
            let ukSkatersUrlFamilyNameSearch = baseURL + "skater_lookup.php?country=\(countryCode)&familyname=\(fullNameArr[1])&givenname=\(fullNameArr[0])"
            
            makeHTTPGetRequest(ukSkatersUrlFamilyNameSearch, completionHandler:   completionHandler)
            
        }
    }
    
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
        //print (path)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print(responseString)
            if(data != nil){
                completionHandler(response: data!)
            }
            
        }
        
        task.resume()
    }
}