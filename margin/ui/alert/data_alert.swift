//
//  data_alert.swift
//  margin
//
//  Created by USER on 13/06/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit
import ZAlertView
import Firebase

class data_alert: UIViewController{
    
    let userPresenter = data_alertPresenter()
    
    @IBOutlet var view0: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var m_price: UILabel!
    @IBOutlet var doll: UILabel!
    @IBOutlet var table: UITableView!
    
    @IBOutlet var add_alert_: UIButton!
    @IBOutlet var price_field: UITextField!
    @IBAction func add_alert(_ sender: Any) {
        let price = sok.chart_symbol + "-" + price_field.text!
        //userPresenter.subscribe(price: price)
    }

    override func viewWillDisappear(_ animated: Bool) {
        //userPresenter.detachView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view1.layer.cornerRadius = 3
        self.view1.layer.borderWidth = 1
        self.view2.layer.cornerRadius = 3
        self.view2.layer.borderWidth = 1
        self.table.layer.cornerRadius = 3
        self.table.layer.borderWidth = 1
        
        self.table.layer.cornerRadius = 3
        self.add_alert_.layer.cornerRadius = 3
        self.price_field.layer.cornerRadius = 3
        self.price_field.layer.borderWidth = 1
        
        
        set_theme()
        
        userPresenter.attachView(view: self)
        userPresenter.timer1_start()
    }
    
    func set_theme(){
        view0.backgroundColor = UIColor.appColor(.table_in)
        view1.backgroundColor = UIColor.appColor(.table_out)
        view1.layer.borderColor = UIColor.appColor(.border)?.cgColor
        view2.backgroundColor = UIColor.appColor(.table_out)
        view2.layer.borderColor = UIColor.appColor(.border)?.cgColor
        table.layer.borderColor = UIColor.appColor(.border)?.cgColor
        doll.textColor = UIColor.appColor(.title2)
        price_field.backgroundColor = UIColor.appColor(.table_in)
        price_field.textColor = UIColor.appColor(.title)
        price_field.layer.borderColor = UIColor.appColor(.border)?.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}

extension data_alert: data_alert_view {
    
    func show_dialog(price:String){
        let dialog = ZAlertView(title: "Success", message: "Subscribed " + price, closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
        })
        dialog.show()
    }
    
    func set_main_text(str:String){
        m_price.text = str
    }
    
    func set_main_color(color:UIColor){
        m_price.textColor = color
    }
    
    func set_dollar_text(str:String){
        doll.text = "≈ " + str + " $"
    }
    
    func set_field(str:String){
        price_field.text = str
    }
    
}
