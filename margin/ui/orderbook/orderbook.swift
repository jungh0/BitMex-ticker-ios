//
//  orderbook.swift
//  margin
//
//  Created by USER on 31/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit
import SwiftWebSocket
import JGProgressHUD

class order_cell2: UITableViewCell {
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bids_c: UILabel!
    @IBOutlet weak var asks_c: UILabel!
}

class orderbook: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let userPresenter = orderbookPresenter()
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet var resent_trade: UILabel!
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        userPresenter.attachView(self)
        sok.send(str1: "subscribe",str2: "orderBook10",str3: sok.chart_symbol)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userPresenter.detachView()
        sok.send(str1: "unsubscribe",str2: "orderBook10",str3: sok.chart_symbol)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set_theme()
        self.show_hud()
        userPresenter.orderbook_reset()
        userPresenter.timer_start()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        //ask_label.layer.cornerRadius = 2
        //ask_label.layer.masksToBounds = true
        //bid_label.layer.cornerRadius = 2
        //bid_label.layer.masksToBounds = true
        
    }
    
    //섹션 별 개수
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.get_orderbook().count
    }
    
    //테이블 데이터 로드
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "order_cell2", for: indexPath) as! order_cell2
        var info = userPresenter.get_orderbook()[indexPath.row]
        cell.asks_c.text = userPresenter.set_order_text(str: info[0])
        cell.price.text = userPresenter.make_0(str: info[1])
        cell.bids_c.text = userPresenter.set_order_text(str: info[2])
        cell.price.textColor = userPresenter.set_order_color(str: info[0],str2:info[2])
        if (dark_theme){
            cell.backgroundColor = UIColor.appColor(.dark_table_out)
        }else{
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func set_theme(){
        self.view1.layer.cornerRadius = 3
        self.view1.layer.borderWidth = 1
        self.view2.layer.cornerRadius = 3
        self.view2.layer.borderWidth = 1
        
        if (dark_theme){
            tableview.backgroundColor = UIColor.appColor(.dark_table_out)
            view1.backgroundColor = UIColor.appColor(.dark_table_out)
            view1.layer.borderColor = UIColor(red:54/255, green:60/255, blue:77/255, alpha: 1).cgColor
            view2.backgroundColor = UIColor.appColor(.dark_table_out)
            view2.layer.borderColor = UIColor(red:54/255, green:60/255, blue:77/255, alpha: 1).cgColor
            view.backgroundColor = UIColor.appColor(.dark_table_out)
        }else{
            tableview.backgroundColor = UIColor.white
            view1.backgroundColor = UIColor.white
            view1.layer.borderColor = UIColor(red:220/255, green:220/255, blue:220/255, alpha: 1).cgColor
            view2.backgroundColor = UIColor.white
            view2.layer.borderColor = UIColor(red:220/255, green:220/255, blue:220/255, alpha: 1).cgColor
            view.backgroundColor = UIColor.appColor(.light_table_out)
        }
    }
    
}

extension orderbook: OrderView2 {
    
    func recent_text(str: String){
        resent_trade.text = str
    }
    
    func show_hud(){
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
    }
    
    func dissmiss_hud(){
        hud.dismiss(afterDelay: 0.0)
    }
    
    func reload_table(){
        self.tableview.reloadData()
    }
    
}
