//
//  data_chartPresenter.swift
//  margin
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit

protocol ChartView: NSObjectProtocol {
    
    func set_main_text(str:String)
    func set_main_color(color:UIColor)
    func set_dollar_text(str:String)
    
    func show_web(js:String)
    
    func bitstamp_hidden(ishidden:Bool)
    func bitstamp_text(str:String)
    func bitstamp_backgroundColor(b_color:UIColor)
    func bitstamp_textColor(t_color:UIColor)
    func bitstamp_price_text(str:String)
    
    func coinbase_hidden(ishidden:Bool)
    func coinbase_text(str:String)
    func coinbase_backgroundColor(b_color:UIColor)
    func coinbase_textColor(t_color:UIColor)
    func coinbase_price_text(str:String)
    
}

class data_chartPresenter{
    
    private var userView : ChartView?
    
    private var timer:Timer!
    private var timer2:Timer!
    
    private var bitstamp_last = "0"
    private var coinbase_last = "0"
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
    
    func make_web(str:String){
        var str3 = "Dark"
        var str2 = "rgba(18,31,48,1)"
        if (!dark_theme){
            str3 = "Light"
            str2 = "rgba(255,255,255,1)"
        }
        let js = "<!-- TradingView Widget BEGIN --><script type=\"text/javascript\" src=\"https://s3.tradingview.com/tv.js\"></script><script type=\"text/javascript\">new TradingView.widget({\"autosize\": true,\"symbol\": \"BITMEX:" + str + "\",\"interval\": \"60\",\"timezone\": \"exchange\",\"theme\": \"" + str3 + "\",\"style\": \"1\",\"locale\": \"en\",\"toolbar_bg\": \"" + str2 + "\",\"enable_publishing\": false,\"hide_top_toolbar\": false,\"save_image\": false,\"hide_legend\": true, \"studies\": [\"BB@tv-basicstudies\"],\"hideideas\": true});</script><!-- TradingView Widget END -->"
        userView?.show_web(js: js)
    }
    
    func attachView(_ view:ChartView){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func timer1_start(){
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 1, target: self, selector: #selector(set_premium), userInfo: nil, repeats:true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    func timer2_start(){
        if(timer2 != nil){timer.invalidate()}
        timer2 = Timer(timeInterval: 1, target: self, selector: #selector(get_premium), userInfo: nil, repeats:true)
        RunLoop.current.add(timer2, forMode: RunLoop.Mode.common)
    }
    
    @objc func set_premium(){
        let info = get_c_list()[check]
        userView!.set_main_text(str: info[1])
        userView!.set_main_color(color: find_main_color(str: info[4]))
        userView?.set_dollar_text(str: make_dollar_text(str: info[1]))
        
        bitstamp_label(info: info)
        coinbase_label(info: info)
    }
    
    @objc func get_premium(){
        get_http_bitstamp()
        get_http_coinbase()
    }
    
    func get_http_bitstamp(){
        let url3 = URL(string: "https://www.bitstamp.net/api/v2/ticker/" + sok.c_list[check][5] + "/")
        let request = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let data_j = text2.data(using: String.Encoding.utf8)
            do {
                if let data_j = data_j,
                    let json = try JSONSerialization.jsonObject(with: data_j, options:[]) as? [String: AnyObject] {
                    let last = json["last"] as? String
                    let tmp = last ?? "0"
                    if (tmp != "0"){
                        self.bitstamp_last = tmp
                    }
                } else {
                    print("No Data :/")
                }
            } catch {
            }
        }
        request.resume()
    }
    
    func get_http_coinbase(){
        let url4 = URL(string: "https://api.pro.coinbase.com/products/" + sok.c_list[check][6] + "/ticker")
        let request = URLSession.shared.dataTask(with: url4! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let data_j = text2.data(using: String.Encoding.utf8)
            do {
                if let data_j = data_j,
                    let json = try JSONSerialization.jsonObject(with: data_j, options:[]) as? [String: AnyObject] {
                    let last = json["price"] as? String
                    let tmp = last ?? "0"
                    if (tmp != "0"){
                        self.coinbase_last = tmp
                    }
                } else {
                    print("No Data :/")
                }
            } catch {
            }
        }
        request.resume()
    }
    
    func get_c_list() -> [[String]]{
        return sok.c_list
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
    
    private func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    private func find_premium(ori:String,new:String) -> Float{
        let rslt  = ((Float(ori)! - Float(new)!) / Float(new)! * 100)
        return round(rslt * pow(10.0, Float(2))) / pow(10.0, Float(2))
    }
    
    private func find_b_color(pre:Float) -> UIColor{
        if pre > Float(0) {
            return UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 0.1)
        }else if  pre < Float(0) {
            return UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 0.1)
        }else{
            return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.1)
        }
    }
    
    private func find_t_color(pre:Float) -> UIColor{
        if pre > Float(0) {
            return UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1.0)
        }else if  pre < Float(0) {
            return UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1.0)
        }else{
            return UIColor.gray
        }
    }
    
    private func find_text_plus(pre:Float) -> String{
        if pre > Float(0) {
            return "+" + pre.description
        }else{
            return pre.description
        }
    }
    
    private func bitstamp_label(info:[String]){
        if (bitstamp_last == "0"){
            userView?.bitstamp_hidden(ishidden: true)
        }else if (!info[1].contains("-")){
            let pre = find_premium(ori: info[1],new: bitstamp_last)
            userView?.bitstamp_backgroundColor(b_color: find_b_color(pre: pre))
            userView?.bitstamp_textColor(t_color: find_t_color(pre: pre))
            userView?.bitstamp_text(str: find_text_plus(pre: pre))
            userView?.bitstamp_price_text(str: bitstamp_last)
        }
    }
    
    private func coinbase_label(info:[String]){
        if (coinbase_last == "0"){
            userView?.coinbase_hidden(ishidden: true)
        }else if (!info[1].contains("-")){
            let pre = find_premium(ori: info[1],new: coinbase_last)
            userView?.coinbase_backgroundColor(b_color: find_b_color(pre: pre))
            userView?.coinbase_textColor(t_color: find_t_color(pre: pre))
            userView?.coinbase_text(str: find_text_plus(pre: pre))
            let tmp = NSNumber(value: Float(coinbase_last)!)
            userView?.coinbase_price_text(str: tmp.decimalValue.description)
        }
    }
    
}
