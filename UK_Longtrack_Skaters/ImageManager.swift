//
//  ImageManager.swift
//  uk_longtrack_skaters
//
//  Created by Anton Carter on 22/05/2016.
//  Copyright © 2016 ___ANTONCARTER___. All rights reserved.
//

import Foundation
import UIKit
class ImageManager {
    
    static func fetchImage(imageURL: NSURL?, imageView: UIImageView) {
        
        if let url = imageURL {

            // fire up the spinner
            // because we're about to fork something off on another thread
            // spinner?.startAnimating()
            // put a closure on the "user initiated" system queue
            // this closure does NSData(contentsOfURL:) which blocks
            // waiting for network response
            // it's fine for it to block the "user initiated" queue
            // because that's a concurrent queue
            // (so other closures on that queue can run concurrently even as this one's blocked)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let contentsOfURL = NSData(contentsOfURL: url) // blocks! can't be on main queue!
                // now that we got the data from the network
                // we want to put it up in the UI
                // but we can only do that on the main queue
                // so we queue up a closure here to do that
                dispatch_async(dispatch_get_main_queue()) {
                    // since it could take a long time to fetch the image data
                    // we make sure here that the image we fetched
                    // is still the one this ImageViewController wants to display!
                    // you must always think of these sorts of things
                    // when programming asynchronously
                    
                    if let imageData = contentsOfURL {
                        imageView.image = UIImage(data: imageData)!
                        //  imageView.setNeedsDisplay()
                        // image's set will stop the spinner animating
                    }
                }
            }
        }
        
    }
    
}