//
//  symbol_ratio.swift
//  margin
//
//  Created by User on 30/12/2018.
//  Copyright © 2018 jungho. All rights reserved.
//

import UIKit
import Foundation
import SwiftWebSocket
import JGProgressHUD

class order_cell: UITableViewCell {
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bids_c: UILabel!
    @IBOutlet weak var asks_c: UILabel!
    @IBOutlet var ask_bar: NSLayoutConstraint!
    @IBOutlet var bid_bar: NSLayoutConstraint!
    @IBOutlet var ask_view: UIView!
    @IBOutlet var bid_view: UIView!
}

class data_orderbook: UITableViewController {
    
    let userPresenter = data_orderbookPresenter()
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var ask_label: UILabel!
    @IBOutlet var bid_label: UILabel!
    @IBOutlet var recent_t: UILabel!
    

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
        
        self.show_hud()
        userPresenter.orderbook_reset()
        userPresenter.timer_start()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        ask_label.layer.cornerRadius = 2
        ask_label.layer.masksToBounds = true
        bid_label.layer.cornerRadius = 2
        bid_label.layer.masksToBounds = true
    }
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.get_orderbook().count
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "order_cell", for: indexPath) as! order_cell
        var info = userPresenter.get_orderbook()[indexPath.row]
        cell.asks_c.text = userPresenter.set_order_text(str: info[0])
        cell.price.text = userPresenter.make_0(str: info[1])
        cell.bids_c.text = userPresenter.set_order_text(str: info[2])
        cell.price.textColor = userPresenter.set_order_color(str: info[0],str2:info[2])
        return cell
    }

}

extension data_orderbook: OrderView {
    
    func recent_text(str: String){
        recent_t.text = str
    }
    
    func show_hud(){
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
    }
    
    func dissmiss_hud(){
        hud.dismiss(afterDelay: 0.0)
    }
    
    func reload_table(){
        self.tableView.reloadData()
    }
    
}
