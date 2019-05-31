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
        
        let tmp = (UserDefaults.standard.value(forKey: "theme2")) as! Int
        if (tmp == 0){
            dark_theme = false
        }else{
            dark_theme = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
}
