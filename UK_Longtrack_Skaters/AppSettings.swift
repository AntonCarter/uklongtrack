// APP Settings
//  UserDefaults.swift
//  skatestart
//
//  Created by Anton Carter on 13/02/2016.
//  Copyright © 2016 roncarterltd. All rights reserved.
//

import Foundation

class AppSettings {
    
    private struct Keys{
        static let GivenName = "GivenName"
        static let FamilyName = "FamilyName"
        static let SkaterId = "SkaterId"
    }
    
    private static var givenName : String?{
        get{
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.stringForKey(Keys.GivenName)
        }
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: Keys.GivenName)        }
    }
    
    private static var familyName : String?{
        get{
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.stringForKey(Keys.FamilyName)
        }
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(newValue, forKey: Keys.FamilyName)        }
    }
    
    private static var skaterId : Int? {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            let v = defaults.integerForKey(Keys.SkaterId)
            if(v==0){
                return nil;
            }
            return v
            
        }
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            if newValue == nil {
                defaults.removeObjectForKey(Keys.SkaterId)
            }
            else{
                defaults.setInteger(newValue!, forKey: Keys.SkaterId)
            }
            
        }
    }
    
    static var AppSkater : Skater? {
        get{
            
            if let id = skaterId {
                let skater = Skater()
                skater.id = id
                skater.familyName = familyName ?? ""
                skater.givenName = givenName ?? ""
                return skater
            }
            return nil
        }
        set{
            if(newValue==nil){
                skaterId = nil
                familyName = nil
                givenName = nil
            }
            else{
                skaterId = newValue?.id
                familyName = newValue?.familyName
                givenName = newValue?.givenName
            }
        }
    }
    
}