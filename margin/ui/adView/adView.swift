//
//  adView.swift
//  margin
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

var sok = socket(wss: "wss://www.bitmex.com/realtime")
var dark_theme = false

class adView: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dark_theme = (UserDefaults.standard.value(forKey: "theme") != nil) // Load
        //UserDefaults.standard.set(value, forKey: "CustomKey") // Save
        //UserDefaults.standard.value(forKey: "CustomKey") // Load
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
}
