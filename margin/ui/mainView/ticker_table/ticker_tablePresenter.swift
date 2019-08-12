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
import Firebase

protocol UserView: NSObjectProtocol {
    
    func show_ad()
    func show_hud()
    func dissmiss_hud()

    func set_theme()
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
        userView?.show_hud()
        userView?.set_theme()
        ad_check()
        aliveTimer()
    }
    
    func detachView() {
        userView = nil
    }
    
    private func request_coin(){
        let randNum = arc4random_uniform(10000).description
        let url = "https://api.coinmarketcap.com/v1/global/?" + randNum
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
    }
    
    private func aliveTimer(){
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 1, target: self,selector: #selector(checkAlive),
                      userInfo:nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    @objc func checkAlive(){
        if (sok.is_waiting){
            userView?.show_hud()
        }else{
            userView?.dissmiss_hud()
        }
    }
    
    func updateList(){
        self.userView?.recent_list()
        sok.setPriceComplete(completion: { result in
            if (self.is_scroll == 0){
                self.userView?.recent_list()
            }
        })
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
        userView?.show_ad()
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
