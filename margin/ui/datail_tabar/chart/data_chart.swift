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
    
    let userPresenter = data_chartPresenter()
    
    @IBOutlet var main_price: UILabel!
    @IBOutlet var dollar: UILabel!
    
    @IBOutlet var bitstamp_r_l: UILabel!
    @IBOutlet var bitstamp: UILabel!
    @IBOutlet var premium: UILabel!
    
    @IBOutlet var coinbase_r_l: UILabel!
    @IBOutlet var coinbase: UILabel!
    @IBOutlet var premium2: UILabel!
    
    @IBOutlet var view_background: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var web: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sok.chart_symbol
        userPresenter.attachView(self)
    }
}

extension data_chart: ChartView {
    
    func show_web(js:String){
        web.isOpaque = false
        web.scrollView.isScrollEnabled = false;
        web.scrollView.bounces = false;
        self.web.loadHTMLString(js, baseURL: nil)
    }
    
    func set_main_text(str:String,color:UIColor){
        main_price.text = str
        main_price.textColor = color
    }

    func set_dollar_text(str:String){
        dollar.text = "≈ " + str + " $"
    }
    
    func bitstamp_hidden(ishidden:Bool){
        self.bitstamp.text = "no data"
        self.premium.text = "---"
    }
    
    func bitstamp_pre_text(_ str:String,_ b_color:UIColor,_ t_color:UIColor){
        self.premium.text = "" + str + "%"
        self.premium.backgroundColor = b_color
        self.premium.textColor = t_color
    }
    
    func bitstamp_price_text(str:String){
        self.bitstamp.text = "" + str + ""
    }
    
    func coinbase_hidden(ishidden:Bool){
        self.coinbase.text = "no data"
        self.premium2.text = "---"
    }
    
    func coinbase_pre_text(_ str:String,_ b_color:UIColor,_ t_color:UIColor){
        self.premium2.text = "" + str + "%"
        self.premium2.backgroundColor = b_color
        self.premium2.textColor = t_color
    }
    
    func coinbase_price_text(str:String){
        self.coinbase.text = "" + str + ""
    }
    
    func set_theme(){
        view1.layer.cornerRadius = 3
        view1.layer.borderWidth = 1
        
        bitstamp.layer.cornerRadius = 3
        bitstamp.layer.masksToBounds = true
        premium.layer.cornerRadius = 3
        premium.layer.masksToBounds = true
        
        coinbase.layer.cornerRadius = 3
        coinbase.layer.masksToBounds = true
        premium2.layer.cornerRadius = 3
        premium2.layer.masksToBounds = true
        
        if (dark_theme){
            self.navigationController?.navigationBar.tintColor = .white
            self.tabBarController?.tabBar.barStyle = .black
            self.tabBarController?.tabBar.barTintColor = UIColor.appColor(.navi)
        }else{
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.tabBarController?.tabBar.barStyle = .default
            self.tabBarController?.tabBar.barTintColor = UIColor.white
        }
        web.backgroundColor = UIColor.appColor(.table_out)
        dollar.textColor = UIColor.appColor(.title2)
        
        view1.backgroundColor = UIColor.appColor(.table_in)
        view1.layer.borderColor = UIColor.appColor(.border)?.cgColor
        view_background.backgroundColor = UIColor.appColor(.table_out)
        
        bitstamp_r_l.textColor = UIColor.appColor(.title2)
        coinbase_r_l.textColor = UIColor.appColor(.title2)
    }
    
}


