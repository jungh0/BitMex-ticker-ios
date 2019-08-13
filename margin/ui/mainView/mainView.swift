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

class mainView: UINavigationController {
    
    let randNum = arc4random_uniform(10000).description
    let hud = JGProgressHUD(style: .dark)
    private var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        show_hud()
        aliveTimer()
        showUpdateStr()
        coinlist()
        
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

        //inapp check
        /*
        do {
            let tmp = Int(getData("world"))
            if (tmp == 97970505){
                world_pr = true
            }else{
                world_pr = false
            }
        }*/
        
    }
    
    private func coinlist(){
        let url = "http://wiffy.io/bitmex/?" + randNum
        requestHTTP(url: url,completion: { result in
            if (result.contains("-NOTICE-")){
                DispatchQueue.main.async {
                    showAlert(self, "-NOTICE-",
                              result.replace("-NOTICE-", ""))
                }
            }else{
                let get_table_data = result.split_("\n")
                for i in get_table_data{
                    var dataa = i.split_(",")
                    sok.c_list_append(list: [dataa[0],dataa[1],dataa[2],dataa[3],dataa[4],dataa[5],dataa[6]])
                }
            }
            
            DispatchQueue.main.async {
                sok.start()
            }
            self.betacheck()
        })
    }
    
    private func betacheck(){
        let url = "http://wiffy.io/bitmex/hello?" + randNum
        requestHTTP(url: url,completion: { result in
            if (result.contains("642537883523")){
                beta = true
            }else{
                beta = false
                let isnoti = UserDefaults.standard.value(forKey: "betanoti")
                if (isnoti == nil){
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("aa", forKey: "betanoti")
                        showAlert(self, "Beta closed",
                                  "Price notifications are now available in Pro version. Please update your app")
                    }
                }
                for (_,iList) in sok.c_list.enumerated() {
                    print(iList[0])
                    let array = UserDefaults.standard.value(forKey: iList[0] + "_AlertList") as? [String] ?? [String]()
                    for aa in array{
                        DispatchQueue.main.async {
                            Messaging.messaging().unsubscribe(fromTopic: iList[0] + "_" + aa) { error in
                                print(iList[0] + "_" + aa)
                            }
                        }
                    }
                    UserDefaults.standard.set([String](), forKey: iList[0] + "_AlertList")
                }
            }
            print("beta:" + beta.description)
        })
    }
    
    private func showUpdateStr(){
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let isnoti = UserDefaults.standard.value(forKey: appVersion)
        if (isnoti == nil){
            UserDefaults.standard.set("aa", forKey: appVersion)
            DispatchQueue.main.async {
                showAlert(self, "Update History",
                          "Price notification for all items (XBT, ADA, BCH,EOS, ETH, LTC, TRX, XRP)\n" +
                    "(It is provided as a PRO function after the beta test.)\nOrderbook Visualization")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sok.is_waiting = true
    }
    
    func show_hud(){
        if (!hud.isVisible){
            hud.textLabel.text = "Connecting"
            hud.show(in: self.view)
        }
    }
    
    func dissmiss_hud(){
        hud.dismiss(afterDelay: 0.0)
    }
    
    private func aliveTimer(){
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 1, target: self,selector: #selector(checkAlive),
                      userInfo:nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    @objc func checkAlive(){
        if (sok.is_waiting){
            show_hud()
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
