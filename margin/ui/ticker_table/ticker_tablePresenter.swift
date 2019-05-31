//
//  ticker_tablePresenter.swift
//  margin
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit

protocol UserView: NSObjectProtocol {
    
    func recent_list()
    func recent_text(str: String)
    func show_ad()
    func show_hud()
    func dissmiss_hud()
    
}

class ticker_tablePresenter {
    
    private var userView : UserView?
    private var timer:Timer!
    private var is_scroll = 0
    
    init(){
        self.request_coin()
    }
    
    private func request_coin(){
        let url3 = URL(string: "http://jungh0.com/symbol")
        let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            var get_table_data = text2.components(separatedBy: "\n")
            for i in 0 ... get_table_data.count - 1 {
                var dataa = get_table_data[i].components(separatedBy: ",")
                sok.c_list_append(list: [dataa[0],dataa[1],dataa[2],dataa[3],dataa[4],dataa[5],dataa[6]])
            }
            DispatchQueue.main.async {
                sok.start()
            }
        }
        taskk2.resume()
    }
    
    func attachView(_ view:UserView){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func set_chartsymbol(str:String){
        sok.chart_symbol = str
    }
    
    func timer_start(){
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(recent_trade), userInfo:nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func recent_trade(){
        //print(sok.recent_str)
        if (sok.is_waiting){
            userView?.show_hud()
        }else{
            userView?.dissmiss_hud()
        }
        if (is_scroll == 0){
            userView?.recent_list()
        }
        userView?.recent_text(str: sok.recent_str)
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
    
    func ad_check(){
        let loadedData = UserDefaults.standard.value(forKey: "world")
        var letsgo = 0
        if (loadedData != nil){
            if ((loadedData as! Int) == 97970505){
                letsgo = 1 //print("thank you")
            }
        }
        if (letsgo == 0 || true){
            userView?.show_ad()
        }
    }
    
    func get_c_list() -> [[String]]{
        return sok.c_list
    }
    
    func find_color(str:String) -> UIColor{
        if (str.contains("g")){
            return UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 0.9) as UIColor
        }
        if (str.contains("r")){
            return UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 0.9) as UIColor
        }
        return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.7) as UIColor
    }
    
}
