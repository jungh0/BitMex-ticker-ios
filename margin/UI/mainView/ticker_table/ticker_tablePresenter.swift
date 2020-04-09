//
//  ticker_tablePresenter.swift
//  margin
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol UserView: NSObjectProtocol {
    
    func set_ad()
    
    func set_theme()
    func recent_list()
    func info_change(cap:String,domin:String)
    func setTopBtn()
    
}

class ticker_tablePresenter{
    
    private var userView : UserView?
    private var is_scroll = 0
    
    init(){
        self.request_coin()
    }
    
    func attachView(_ view:UserView){
        userView = view
        userView?.set_theme()
        ad_check()
    }
    
    func detachView() {
        userView = nil
    }
    
    private func request_coin(){
        let randNum = arc4random_uniform(10000).description
        let url = "https://api.coingecko.com/api/v3/global?" + randNum
        requestHTTP(url: url,completion: { result in
            var cap = ""
            var domin = ""

            if let jsonData = getAnyJson(json: result,str: "data")  as? [String:AnyObject] {
                if(jsonData.description != "[]"){
                    let total = jsonData["market_cap_change_percentage_24h_usd"]
                    let tmpT = total?.description?.replace(" ", "").replace("\n", "")
                    cap =  (tmpT ?? "---" )
                    cap = cap.prefix(5) + "%"
                    
                    let per = jsonData["market_cap_percentage"]
                    let tmpP = per?.description?.replace(" ", "").replace("\n", "").split_("btc=\"")[1].split_("\"")[0]
                    domin =  (tmpP ?? "---" )
                    domin = domin.prefix(5) + "%"
                }
            }
   
            DispatchQueue.main.async {
                self.userView?.info_change(cap: cap, domin: domin)
            }
        })
    }
    
    func updateList(){
        self.userView?.recent_list()
        sok.setPriceComplete(completion: { result in
            //print("aa")
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
        userView?.set_ad()
    }
    
    func get_c_list() -> [[String]]{
        return sok.c_list
    }
    
    
}
