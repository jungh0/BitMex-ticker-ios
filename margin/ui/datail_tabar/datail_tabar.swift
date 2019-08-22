//
//  tabbar.swift
//  margin
//
//  Created by User on 30/12/2018.
//  Copyright © 2018 jungho. All rights reserved.
//

import UIKit
import Foundation

class datail_tabar: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
         
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = sok.chart_symbol
        self.delegate = self
        if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let
            tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            
//            if(!beta){
//                tabBarItem.isEnabled = false
//                tabBarItem.title = "Alert(PRO)"
//            }
        }
    }

    /*
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 2 {
            showAlert(self,"","This feature is available only on XBTUSD")
        }
    }*/

}
