//
//  data_alert.swift
//  margin
//
//  Created by USER on 13/06/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD

class alertCell: UITableViewCell {
    @IBOutlet var cellPrice: UILabel!
    @IBOutlet var add_alert_: UIButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (self.subviews.count < 3){
            let separator = UIView()
            separator.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height - 1,
                                     width: self.frame.size.width, height: 2)
            separator.backgroundColor = UIColor.appColor(.table_click)
            self.addSubview(separator)
        }
    }
}

class data_alert: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let userPresenter = data_alertPresenter()
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet var view0: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var m_price: UILabel!
    @IBOutlet var doll: UILabel!
    @IBOutlet var table: UITableView!
    
    @IBOutlet var add_alert_: UIButton!
    @IBOutlet var price_field: UITextField!
    @IBAction func add_alert(_ sender: Any) {
        self.view.endEditing(true)
        let price = price_field.text!
        userPresenter.subscribe(price: price)
    }
    
    override func viewWillAppear(_ animated: Bool){
        userPresenter.updateList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //userPresenter.detachView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPresenter.attachView(view: self)
        table.delegate = self
        table.dataSource = self
    }
    
    //섹션 별 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.getAlertList().count
    }
    
    //테이블 데이터 로드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! alertCell
        cell.cellPrice.text = sok.chart_symbol + " : " + userPresenter.getAlertList()[indexPath.row].description
        cell.cellPrice.textColor = UIColor.appColor(.title2)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.appColor(.table_click)
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = UIColor.appColor(.table_in)
        
        cell.add_alert_.addTarget(self, action: #selector(addAlertBtn), for: UIControl.Event.touchUpInside)
        cell.add_alert_.tag = indexPath.row
        cell.add_alert_.layer.cornerRadius = 3
        return cell
    }
    
    @objc func addAlertBtn(sender : UIButton!) {
        let row = sender.tag;
        userPresenter.delAlertList(alerV: userPresenter.getAlertList()[row])
    }
    
    //테이블 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //userPresenter.delAlertList(alerV: userPresenter.getAlertList()[indexPath.row])
        table.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func doneBtnClicked (sender: Any) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}

extension data_alert: data_alert_view {
    
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
    
    func reload_table(){
        self.table.reloadData()
    }
    
    func show_hud(){
        if (!hud.isVisible){
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
        }
    }
    
    func dissmiss_hud(){
        hud.dismiss(afterDelay: 0.0)
    }
    
    func set_theme(){
        view0.backgroundColor = UIColor.appColor(.table_out)
        
        view1.backgroundColor = UIColor.appColor(.table_in)
        //view1.layer.borderColor = UIColor.appColor(.border)?.cgColor
        view1.layer.cornerRadius = 5
        //view1.layer.borderWidth = 1
        
        view2.backgroundColor = UIColor.appColor(.table_in)
        //view2.layer.borderColor = UIColor.appColor(.border)?.cgColor
        view2.layer.cornerRadius = 5
        //view2.layer.borderWidth = 1
        
        table.backgroundColor = UIColor.appColor(.table_in)
        //table.layer.borderColor = UIColor.appColor(.border)?.cgColor
        table.layer.cornerRadius = 5
        //table.layer.borderWidth = 1
        
        doll.textColor = UIColor.appColor(.title2)
        add_alert_.layer.cornerRadius = 10
  
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnClicked))
        toolBarKeyboard.items = [btnDoneBar]
        toolBarKeyboard.tintColor = #colorLiteral(red: 0.231372549, green: 0.4784313725, blue: 0.8235294118, alpha: 1)
        
        price_field.inputAccessoryView = toolBarKeyboard
        price_field.textColor = UIColor.appColor(.title)
        price_field.layer.borderColor = UIColor.appColor(.table_in)?.cgColor
        price_field.backgroundColor = UIColor.appColor(.textfield_in)
        price_field.layer.masksToBounds = true
        price_field.layer.cornerRadius = 10
        price_field.layer.borderWidth = 1
    }
    
}
