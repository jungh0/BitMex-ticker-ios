//
//  orderbookPresenter.swift
//  margin
//
//  Created by USER on 31/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit

protocol OrderView2: NSObjectProtocol {
    
    func recent_text(str: String)
    func show_hud()
    func dissmiss_hud()
    func reload_table()
    func set_theme()
    
}

class orderbookPresenter{
    
    private var userView : OrderView2?
    private var price_length = 0
    private var orderbook = [[String]]()
    private var is_scroll = 0
    
    init(){
        
    }
    
    func attachView(_ view:OrderView2){
        userView = view
        userView?.set_theme()
        userView?.show_hud()
        sok.setOrderComplete(completion: { result in
            self.order_parse(str: result)
        })
    }
    
    func detachView() {
        userView = nil
    }
    
    private func order_parse(str:String){
        //print(str)
        if let jsonData = getAnyJson(json: str,str: "data") as? [[String:AnyObject]]{
            if(jsonData.description != "[]"){
                var asksJson = (jsonData[0]["asks"] as? [[Double]]) ?? []
                asksJson.reverse()
                let bidsJson = (jsonData[0]["bids"] as? [[Double]]) ?? []
                
                orderbook.removeAll()
                for asksJ in asksJson {
                    var askTmp = asksJ.map { $0.toString() }
                    askTmp.reverse()
                    orderbook.append(askTmp + ["-"])
                }
                for bidsJ in bidsJson {
                    let bidTmp = bidsJ.map { $0.toString() }
                    orderbook.append(["-"] + bidTmp)
                }
            }
        }
        reload_table()
    }
    
    private func reload_table(){
        for list in get_orderbook(){
            if(list[1].count > price_length){
                price_length = list[1].count
            }
        }
        if(self.is_scroll == 0){
            userView?.reload_table()
        }
        userView?.dissmiss_hud()
        let tmp = sok.chart_symbol
        if (sok.recent_str_order.contains(tmp)){
            let aa = sok.recent_str_order.replace(" : ", "").replace(tmp, "")
            userView?.recent_text(str: aa)
        }
    }
    
    func get_orderbook() -> [[String]]{
        return orderbook
    }
    
    func make_0(str:String) -> String{
        var tmp = str
        if(str.count < price_length){
            if(str.contains(".")){
                tmp = tmp + "0"
            }else{
                tmp = tmp + ".0"
            }
            while (tmp.count != price_length){
                tmp = tmp + "0"
            }
        }
        return tmp
    }
    
    func set_order_text(str:String) -> String{
        if (str.contains("-")){
            return ""
        }
        return str
    }
    
    func set_order_color(str:String,str2:String) -> UIColor?{
        if (str.contains("-")){
            return UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1)
        }
        if (str2.contains("-")){
            return UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1)
        }
        return nil
    }
    
    func BeginDragging(){
        is_scroll = 1
    }
    
    func EndDragging(){
        is_scroll = 1
        let time = DispatchTime.now() + .milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.is_scroll = 0
            self.userView?.reload_table()
        }
    }
    
}
