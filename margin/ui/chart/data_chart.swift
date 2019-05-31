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
    
    @IBOutlet var web: UIWebView!
    @IBOutlet var main_price: UILabel!
    @IBOutlet var dollar: UILabel!
    @IBOutlet var bitstamp: UILabel!
    @IBOutlet var premium: UILabel!
    @IBOutlet var premium2: UILabel!
    @IBOutlet var coinbase: UILabel!
    
    @IBOutlet var view1: UIView!
    
    
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sok.chart_symbol
        
        self.view1.layer.cornerRadius = 2
        self.view1.layer.borderWidth = 1
        self.view1.layer.borderColor = UIColor(red:54/255, green:60/255, blue:77/255, alpha: 1).cgColor

        
        userPresenter.attachView(self)
        userPresenter.timer1_start()
        userPresenter.timer2_start()
        userPresenter.make_web(str: sok.chart_symbol)

        bitstamp.layer.cornerRadius = 2
        bitstamp.layer.masksToBounds = true
        premium.layer.cornerRadius = 2
        premium.layer.masksToBounds = true
        
        userPresenter.set_premium()
        userPresenter.get_premium()
    }
}

extension data_chart: ChartView {
    
    func show_web(js:String){
        web.isOpaque = false
        web.scrollView.isScrollEnabled = false;
        web.scrollView.bounces = false;
        self.web.loadHTMLString(js, baseURL: nil)
    }
    
    func set_main_text(str:String){
        main_price.text = str
    }
    
    func set_main_color(color:UIColor){
        main_price.textColor = color
    }
    
    func set_dollar_text(str:String){
        dollar.text = "≈ " + str + " $"
    }
    
    func bitstamp_hidden(ishidden:Bool){
        //self.bitstamp.isHidden = ishidden
        //self.premium.isHidden = ishidden
        self.bitstamp.text = "no data"
        self.premium.text = "---"
    }
    
    func bitstamp_text(str:String){
        self.premium.text = "" + str + "%"
    }
    
    func bitstamp_backgroundColor(b_color:UIColor){
        self.premium.backgroundColor = b_color
    }
    
    func bitstamp_textColor(t_color:UIColor){
        self.premium.textColor = t_color
    }
    
    func bitstamp_price_text(str:String){
        self.bitstamp.text = "" + str + ""
    }
    
    func coinbase_hidden(ishidden:Bool){
        //self.premium2.isHidden = ishidden
        //self.coinbase.isHidden = ishidden
        self.coinbase.text = "no data"
        self.premium2.text = "---"
    }
    
    func coinbase_text(str:String){
        self.premium2.text = "" + str + "%"
    }
    
    func coinbase_backgroundColor(b_color:UIColor){
        self.premium2.backgroundColor = b_color
    }
    
    func coinbase_textColor(t_color:UIColor){
        self.premium2.textColor = t_color
    }
    
    func coinbase_price_text(str:String){
        self.coinbase.text = "" + str + ""
    }
    
}


