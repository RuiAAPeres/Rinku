//
//  AppDelegate.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2014.
//  Copyright (c) 2014 Aphely. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        _ = Rinku.get("http://upload.wikimedia.org/wikipedia/commons/5/5b/Ultraviolet_image_of_the_Cygnus_Loop_Nebula_crop.jpg")
        
        Rinku.get("http://myservice.com/").completion({completion in
            
        })
        
        return true
    }
}

