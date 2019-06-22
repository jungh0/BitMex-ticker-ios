//
//  data_alertPresenter.swift
//  margin
//
//  Created by USER on 19/06/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol data_alert_view: NSObjectProtocol {

    func show_dialog(price:String)
    func set_main_text(str:String)
    func set_main_color(color:UIColor)
    func set_dollar_text(str:String)
    func set_field(str:String)
    
}

class data_alertPresenter{
    
    private var userView : data_alert_view?
    private var timer:Timer!
    private var check = -1
    
    init(){
        if (check == -1){
            for i in 0 ... get_c_list().count - 1 {
                if (get_c_list()[i][0].contains(sok.chart_symbol)){
                    check = i
                    break
                }
            }
        }
    }
    
    func get_c_list() -> [[String]]{
        return sok.c_list
    }
    
    func timer1_start(){
        set_field_init()
        set_price()
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 1, target: self, selector: #selector(set_price), userInfo: nil, repeats:true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    func set_field_init(){
        let info = get_c_list()[check]
        userView?.set_field(str: info[1])
    }
    
    @objc func set_price(){
        let info = get_c_list()[check]
        userView!.set_main_text(str: info[1])
        userView!.set_main_color(color: find_main_color(str: info[4]))
        userView!.set_dollar_text(str: make_dollar_text(str: info[1]))
    }
    
    func attachView(view:data_alert_view){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func subscribe(price:String){
        Messaging.messaging().subscribe(toTopic: price) { error in
            print("Subscribed to weather topic")
            self.userView?.show_dialog(price: price)
        }
    }
    
    private func find_main_color(str:String) -> UIColor{
        if (str.contains("g")){
            return UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1)
        }
        else if (str.contains("r")){
            return UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1)
        }
        else{
            return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        }
    }
    
    private func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    private func make_dollar_text(str:String) -> String{
        let to_num = NSString(string: str)
        if (to_num.doubleValue > 1){
            return str
        }else{
            let dollar_ = NSString(string: get_c_list()[0][1])
            let to_d = to_num.doubleValue * dollar_.doubleValue
            let new = roundToPlaces(value: Double(to_d.description) ?? 0.0,places: 4).description
            return new
        }
    }
   
}
