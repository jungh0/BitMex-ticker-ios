//
//  ticker_tablePresenter.swift
//  margin
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

protocol UserView: NSObjectProtocol {
    
    func show_ad()
    func show_hud()
    func dissmiss_hud()

    func set_theme()
    func showUpdateStr()
    
    func recent_list()
    
    func info_change(cap:String,domin:String)
    
}

class ticker_tablePresenter {
    
    private var userView : UserView?
    private var timer:Timer!
    private var is_scroll = 0
    
    init(){
        self.request_coin()
    }
    
    func attachView(_ view:UserView){
        userView = view
        userView?.showUpdateStr()
        userView?.show_hud()
        userView?.set_theme()
        self.ad_check()
        self.timer_start()
    }
    
    func detachView() {
        userView = nil
    }
    
    private func request_coin(){
        let randNum = arc4random_uniform(10000).description
        var url = "http://wiffy.io/bitmex/?" + randNum
        requestHTTP(url: url,completion: { result in
            var get_table_data = result.split_("\n")
            for i in 0 ... get_table_data.count - 1 {
                var dataa = get_table_data[i].split_(",")
                sok.c_list_append(list: [dataa[0],dataa[1],dataa[2],dataa[3],dataa[4],dataa[5],dataa[6]])
            }
            DispatchQueue.main.async {
                sok.start()
            }
        })
        url = "https://api.coinmarketcap.com/v1/global/"
        requestHTTP(url: url,completion: { result in
            var cap = ""
            var domin = ""
            if let jsonData = getAnyJson(json: result,str: "total_market_cap_usd") as? Double{
                cap = Int(jsonData).delimiter
            }
            if let jsonData = getAnyJson(json: result,str: "bitcoin_percentage_of_market_cap") as? Double{
                domin = jsonData.description + "%"
            }
            DispatchQueue.main.async {
                self.userView?.info_change(cap: "$" + cap, domin: domin)
            }
        })
        url = "http://wiffy.io/bitmex/hello?" + randNum
        requestHTTP(url: url,completion: { result in
            if (result.contains("642537883523")){
                beta = true
            }else{
                beta = false
                let isnoti = UserDefaults.standard.value(forKey: "betanoti")
                if (isnoti == nil){
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("aa", forKey: "betanoti")
                        showAlert(self.userView as? UIViewController, "Beta closed",
                                  "Price notifications are now available in Pro version. Please update your app")
                    }
                }
            }
            print("beta:" + beta.description)
        })
    }
    
    private func timer_start(){
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 0.5, target: self,selector: #selector(recent_trade),
                      userInfo:nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func recent_trade(){
        if (sok.is_waiting){
            userView?.show_hud()
        }else{
            userView?.dissmiss_hud()
        }
        if (is_scroll == 0){
            userView?.recent_list()
        }
    }
    
    func BeginDragging(){
        is_scroll = 1
    }
    
    func EndDragging(){
        is_scroll = 1
        let time = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.is_scroll = 0
        }
    }
    
    private func ad_check(){
        if (!world_pr){
            //userView?.show_ad()
        }
        //userView?.show_ad()
    }
    
    func get_c_list() -> [[String]]{
        return sok.c_list
    }
    
    func inapp(){
        print("aa")
        let iapObserver = StoreObserver()
        SKPaymentQueue.default().add(iapObserver)
    }
    
}
