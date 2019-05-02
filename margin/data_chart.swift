//
//  data_chart.swift
//  margin
//
//  Created by User on 29/12/2018.
//  Copyright © 2018 jungho. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore
import WebKit

class data_chart: UIViewController  {
    
    @IBOutlet var web: UIWebView!
    @IBOutlet var main_price: UILabel!
    @IBOutlet var dollar: UILabel!
    @IBOutlet var bitstamp: UILabel!
    @IBOutlet var premium: UILabel!
    @IBOutlet var premium2: UILabel!
    @IBOutlet var coinbase: UILabel!
    
    var timer:Timer!
    var timer2:Timer!
    var check = -1
    var bitstamp_last = "0"
    var coinbase_last = "0"
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    @objc func timerDidFire(){
        main_price.text = list[check][1]
        if (list[check][4].contains("g")){
            main_price.textColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1) as UIColor
        }
        else if (list[check][4].contains("r")){
            main_price.textColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1) as UIColor
        }
        else{
            main_price.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1) as UIColor
        }
        
        
        let to_num = NSString(string: list[check][1])
        if (to_num.doubleValue > 1){
            dollar.text = "≈ " + list[check][1] + " $"
        }else{
            let dollar_ = NSString(string: list[0][1])
            let to_d = to_num.doubleValue * dollar_.doubleValue
            
            let doller__ = roundToPlaces(value: Double(to_d.description) ?? 0.0,places: 4).description
            dollar.text = "≈ " + doller__ + " $"
        }
        
        //bitstamp 프리미엄
        self.bitstamp.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.1)
        self.bitstamp.textColor = UIColor.gray
        if (!list[self.check][1].contains("-")){
            let rslt  = ((Float(list[self.check][1])! - Float(bitstamp_last)!) / Float(bitstamp_last)! * 100)
            var tmp2 = Float(0.0)
            tmp2 = round(rslt * pow(10.0, Float(2))) / pow(10.0, Float(2))
            
            var plus = ""
            if tmp2 > Float(0) {
                plus = "+"
                self.bitstamp.backgroundColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 0.1)
                self.bitstamp.textColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1.0)
            }else if  tmp2 < Float(0) {
                self.bitstamp.backgroundColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 0.1)
                self.bitstamp.textColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1.0)
            }
            self.bitstamp.text = "  Bitstamp : " + plus + tmp2.description + "%  "
            self.premium.text = "  " + bitstamp_last + "  "
        }
        if (bitstamp_last == "0"){
            self.bitstamp.isHidden = true
            self.premium.isHidden = true
        }else{
            self.bitstamp.isHidden = false
            self.premium.isHidden = false
        }
        
        //coinbase 프리미엄
        let number = NSNumber(value: Float(coinbase_last)!)
        self.coinbase.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.1)
        self.coinbase.textColor = UIColor.gray
        if (!list[self.check][1].contains("-")){
            let rslt  = ((Float(list[self.check][1])! - Float(coinbase_last)!) / Float(coinbase_last)! * 100)
            var tmp2 = Float(0.0)
            tmp2 = round(rslt * pow(10.0, Float(2))) / pow(10.0, Float(2))
            
            var plus = ""
            if tmp2 > Float(0) {
                plus = "+"
                self.coinbase.backgroundColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 0.1)
                self.coinbase.textColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1.0)
            }else if  tmp2 < Float(0) {
                self.coinbase.backgroundColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 0.1)
                self.coinbase.textColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1.0)
            }
            self.coinbase.text = "  Coinbase : " + plus + tmp2.description + "%  "
            self.premium2.text = "  " + number.decimalValue.description + "  "
        }
        if (coinbase_last == "0"){
            self.coinbase.isHidden = true
            self.premium2.isHidden = true
        }else{
            self.coinbase.isHidden = false
            self.premium2.isHidden = false
        }
    }
    
    @objc func timerDidFire2(){
        let url3 = URL(string: "https://www.bitstamp.net/api/v2/ticker/" + list[check][5] + "/")
        let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            //print(text2)
            let data_j = text2.data(using: String.Encoding.utf8)
            
            do {
                if let data_j = data_j,
                    let json = try JSONSerialization.jsonObject(with: data_j, options:[]) as? [String: AnyObject] {
                    let last = json["last"] as? String
                    self.bitstamp_last = last!
                } else {
                    print("No Data :/")
                }
            } catch {
                //print(text2)
                //print("Error, Could not parse the JSON request")
            }
            
        }
        taskk2.resume()
        
        let url4 = URL(string: "https://api.pro.coinbase.com/products/" + list[check][6] + "/ticker")
        let taskk3 = URLSession.shared.dataTask(with: url4! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            print(text2)
            let data_j = text2.data(using: String.Encoding.utf8)
            
            do {
                if let data_j = data_j,
                    let json = try JSONSerialization.jsonObject(with: data_j, options:[]) as? [String: AnyObject] {
                    let last = json["price"] as? String
                    self.coinbase_last = last ?? "0"
                } else {
                    print("No Data :/")
                }
            } catch {
                //print(text2)
                //print("Error, Could not parse the JSON request")
            }
            
        }
        taskk3.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (check == -1){
            for i in 0 ... list.count - 1 {
                if (list[i][0].contains(chart_symbol)){
                    check = i
                    break
                }
            }
        }
        
        bitstamp.layer.cornerRadius = 2
        bitstamp.layer.masksToBounds = true
        premium.layer.cornerRadius = 2
        premium.layer.masksToBounds = true
        
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(data_chart.timerDidFire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        if(timer2 != nil){timer2.invalidate()}
        timer2 = Timer(timeInterval: 10, target: self, selector: #selector(data_chart.timerDidFire2), userInfo: nil, repeats: true)
        RunLoop.current.add(timer2, forMode: RunLoop.Mode.common)
        
        self.title = chart_symbol
        
        web.isOpaque = false
        web.scrollView.isScrollEnabled = false;
        web.scrollView.bounces = false;
        
        let js = "<!-- TradingView Widget BEGIN --><script type=\"text/javascript\" src=\"https://s3.tradingview.com/tv.js\"></script><script type=\"text/javascript\">new TradingView.widget({\"autosize\": true,\"symbol\": \"BITMEX:" + chart_symbol + "\",\"interval\": \"60\",\"timezone\": \"exchange\",\"theme\": \"Dark\",\"style\": \"1\",\"locale\": \"en\",\"toolbar_bg\": \"rgba(18,31,48,1)\",\"enable_publishing\": false,\"hide_top_toolbar\": false,\"save_image\": false,\"hide_legend\": true, \"studies\": [\"BB@tv-basicstudies\"],\"hideideas\": true});</script><!-- TradingView Widget END -->"
        //ViewControllerUtils().showActivityIndicator(uiView: self.view)
        self.web.loadHTMLString(js, baseURL: nil)
        
        timerDidFire()
        timerDidFire2()
    }
    
    

}




