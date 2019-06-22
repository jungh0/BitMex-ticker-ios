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
import ZAlertView
import Firebase

var sok = socket(wss: "wss://www.bitmex.com/realtime")
var dark_theme = false

class adView: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZAlertView.positiveColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 0.9)
        do {
            let tmp = try? (UserDefaults.standard.value(forKey: "theme2")) as? Int
            if (tmp == 0){
                dark_theme = false
            }else{
                dark_theme = true
            }
        }
        
        /*
        Messaging.messaging().subscribe(toTopic: "weather2") { error in
            print("Subscribed to weather topic")
        }
        
        Messaging.messaging().unsubscribe(fromTopic: "weather2") { error in
            print("unSubscribed to weather topic")
        }*/
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
}
