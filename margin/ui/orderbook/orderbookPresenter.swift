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
    
}

class orderbookPresenter{
    
    private var userView : OrderView2?
    private var timer:Timer!
    private var price_length = 0
    
    init(){
        
    }
    
    func attachView(_ view:OrderView2){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func timer_start(){
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 1, target: self, selector: #selector(recent_trade), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc private func recent_trade(){
        userView?.reload_table()
        if(get_orderbook().count > 5){
            userView?.dissmiss_hud()
        }
        let tmp = sok.chart_symbol
        if (sok.recent_str_order.contains(tmp)){
            let aa = sok.recent_str_order.replacingOccurrences(of: tmp + " : ", with: "")
            userView?.recent_text(str: aa)
        }
    }
    
    func get_orderbook() -> [[String]]{
        return sok.orderbook
    }
    
    func orderbook_reset(){
        sok.orderbook_reset()
    }
    
    func make_0(str:String) -> String{
        if(str.count > price_length){
            price_length = str.count
        }
        if(str.count < price_length){
            if(str.contains(".")){
                return str + "0"
            }else{
                return str + ".0"
            }
        }
        return str
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
    
}
