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
    
    func set_main_text(str:String)
    func set_main_color(color:UIColor)
    func set_dollar_text(str:String)
    func set_field(str:String)
    func reload_table()
    func show_hud()
    func dissmiss_hud()
    func set_theme()
    
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
    
    func attachView(view:data_alert_view){
        userView = view
        userView?.set_theme()
        set_field_init()
    }
    
    func detachView() {
        userView = nil
    }
    
    func get_c_list() -> [[String]]{
        return sok.c_list
    }
    
    func updateList(){
        set_price()
        sok.setPriceComplete(completion: { result in
            self.set_price()
        })
    }
    
    private func set_field_init(){
        let info = get_c_list()[check]
        userView?.set_field(str: info[1])
    }
    
    @objc func set_price(){
        let info = get_c_list()[check]
        userView?.set_main_text(str: info[1])
        userView?.set_main_color(color: find_main_color(str: info[4]))
        userView?.set_dollar_text(str: make_dollar_text(str: info[1]))
    }
    
    func subscribe(price:String){
        var result = ""
        if (price.isNumber){
            let priceDouble = ((price) as NSString).doubleValue
            let priceInt = ((price) as NSString).integerValue
            if (!price.contains(".")){
                result = price
            }
            else if (priceDouble == Double(priceInt)){
                result = price.split_(".")[0]
            }else{
                //result = priceDouble.description
                result = Double(price)!.toString()
            }
            //print(result)
            
            func someHandler(alert: UIAlertAction!) {
                DispatchQueue.main.async {
                    self.userView?.show_hud()
                }
                let url = "http://wiffy.io/bitmex/reg/?d=" + "alert_" + sok.chart_symbol + ":" + result
                requestHTTP(url: url,completion: { aa in
                    if (aa == "Result: OK"){
                        Messaging.messaging().subscribe(toTopic: sok.chart_symbol + "_" + result) { error in
                            DispatchQueue.main.async {
                                self.addAlertList(alerV: (result))
                                self.userView?.dissmiss_hud()
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.userView?.dissmiss_hud()
                            showAlert(self.userView as? UIViewController,"Fail","There is a problem ")
                        }
                    }
                })
            }
            
            if  (Double(price)! < Double(get_c_list()[check][1])! * 2 )  {
                someHandler(alert: nil)
            }else{
                selectAlert(self.userView as? UIViewController,
                            "Check price","Big difference with current price\nDo you really want to subscribe to this price?",
                            "Subscribe",someHandler)
            }
            
        }else{
            showAlert(self.userView as? UIViewController,"Fail","There is a problem with the input ")
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
    
    func delAlertList(alerV:String){
        func someHandler(alert: UIAlertAction!) {
            var array = UserDefaults.standard.value(forKey: sok.chart_symbol + "_AlertList") as? [String] ?? [String]()
            if let index = array.firstIndex(of:alerV) {
                DispatchQueue.main.async {
                    self.userView?.show_hud()
                }
                Messaging.messaging().unsubscribe(fromTopic: sok.chart_symbol + "_" + alerV) { error in
                    array.remove(at: index)
                    UserDefaults.standard.set(array, forKey: sok.chart_symbol + "_AlertList")
                    DispatchQueue.main.async {
                        self.userView?.dissmiss_hud()
                        self.userView?.reload_table()
                        showAlert(self.userView as? UIViewController,"Success","Unsubscribed " + alerV)
                    }
                }
            }
        }
        selectAlert(self.userView as? UIViewController,
                    "Unsubscribe",sok.chart_symbol + ":" + alerV,
                    "OK",someHandler)
        
    }
    
    private func addAlertList(alerV:String){
        var array = UserDefaults.standard.value(forKey: sok.chart_symbol + "_AlertList") as? [String] ?? [String]()
        if (!array.contains(alerV)){
            array.append(alerV)
            array.sort()
            array.reverse()
            UserDefaults.standard.set(array, forKey: sok.chart_symbol + "_AlertList")
            userView?.reload_table()
            showAlert(self.userView as? UIViewController,"Success","Subscribed " + alerV)
        }else{
            showAlert(self.userView as? UIViewController,"Fail","Subscription already exists")
        }
    }
    
    func getAlertList() -> [String]{
        return UserDefaults.standard.value(forKey: sok.chart_symbol + "_AlertList") as? [String] ?? [String]()
    }
}
