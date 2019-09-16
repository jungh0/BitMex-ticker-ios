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
import Firebase
import JGProgressHUD

var sok = socket(wss: "wss://www.bitmex.com/realtime")
var dark_theme = false
var world_pr = false//pro
var beta = false
var closeiap = false

class mainView: UINavigationController {
    
    let hud = JGProgressHUD(style: .dark)
    
    private var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        show_hud(self.view)
        aliveTimer()
        showUpdateStr()
        
        do {
            let tmp = Int(getData("theme2"))
            if (tmp == 0){
                dark_theme = false
            }else if (tmp == 1){
                dark_theme = true
            }else{
                dark_theme = false
            }
        }
        
    }
    
    private func showUpdateStr(){
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let isnoti = UserDefaults.standard.value(forKey: appVersion)
        if (isnoti == nil){
            UserDefaults.standard.set("aa", forKey: appVersion)
            DispatchQueue.main.async {
                showAlert(self, "Update History",
                          "Bugs fixed")
            }
        }
    }
    
    func show_hud(_ hudview:UIView){
        if (!hud.isVisible){
            hud.textLabel.text = "Connecting"
            hud.show(in: hudview)
        }
    }
    func dissmiss_hud(){
        hud.dismiss(afterDelay: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
    private func aliveTimer(){
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 1, target: self,selector: #selector(checkAlive),
                      userInfo:nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    @objc func checkAlive(){
        if (sok.is_waiting){
            show_hud(self.view)
        }else{
            dissmiss_hud()
        }
        if(sok.errormsg != ""){
            sok.errormsg = ""
            DispatchQueue.main.async {
                showAlertNO(self, "ERROR",
                          "Too Many Requests\nPlease close the app and try again later")
            }
        }
    }
    
}
