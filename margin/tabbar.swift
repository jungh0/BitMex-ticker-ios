//
//  tabbar.swift
//  margin
//
//  Created by User on 30/12/2018.
//  Copyright © 2018 jungho. All rights reserved.
//

import UIKit
import Foundation
import SwiftWebSocket


class tabbar: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = chart_symbol


        //tableview.dataSource = self
        //tableview.delegate = self
    }
    
    
    
}
