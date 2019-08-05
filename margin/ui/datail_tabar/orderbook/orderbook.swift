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
    
    @IBOutlet var askLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var bidLabel: UILabel!
    
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
        
        userPresenter.orderbook_reset()
        userPresenter.timer_start()
        
        tableview.dataSource = self
        tableview.delegate = self
        
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
            cell.backgroundColor = UIColor.appColor(.detail_table_in)
        }else{
            cell.backgroundColor = UIColor.white
        }
        return cell
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
    
    func set_theme(){
        self.view1.layer.cornerRadius = 3
        self.view1.layer.borderWidth = 1
        self.view2.layer.cornerRadius = 3
        self.view2.layer.borderWidth = 1
        
        askLabel.layer.masksToBounds = true
        askLabel.layer.cornerRadius = 5
        priceLabel.layer.masksToBounds = true
        priceLabel.layer.cornerRadius = 5
        bidLabel.layer.masksToBounds = true
        bidLabel.layer.cornerRadius = 5
        
        tableview.backgroundColor = UIColor.appColor(.detail_table_in)
        view1.backgroundColor = UIColor.appColor(.detail_table_in)
        view1.layer.borderColor = UIColor.appColor(.border)?.cgColor
        view2.backgroundColor = UIColor.appColor(.detail_table_in)
        view2.layer.borderColor = UIColor.appColor(.border)?.cgColor
        view.backgroundColor = UIColor.appColor(.table_out)
    }
    
}
