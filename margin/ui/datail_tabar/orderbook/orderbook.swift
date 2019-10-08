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

class order_cell2: UITableViewCell {
    @IBOutlet var red: UIView!
    @IBOutlet var green: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bids_c: UILabel!
    @IBOutlet weak var asks_c: UILabel!
    @IBOutlet var redLen: NSLayoutConstraint!
    @IBOutlet var greenLen: NSLayoutConstraint!
}

class orderbook: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let userPresenter = orderbookPresenter()
    
    @IBOutlet var cellBottom: UIView!
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
        //userPresenter.detachView()
        sok.send(str1: "unsubscribe",str2: "orderBook10",str3: sok.chart_symbol)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPresenter.setTableMax(max: Int(tableview.frame.width))
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
        let info = userPresenter.get_orderbook()[indexPath.row]
        cell.asks_c.text = userPresenter.set_order_text(str: info[0])
        cell.price.text = userPresenter.make_0(str: info[1])
        cell.bids_c.text = userPresenter.set_order_text(str: info[2])
        cell.price.textColor = userPresenter.set_order_color(str: info[0],str2:info[2])
        if (dark_theme){
            cell.backgroundColor = UIColor.appColor(.table_in)
        }else{
            cell.backgroundColor = UIColor.white
        }
        
        if(cell.asks_c.text == ""){
            cell.red.isHidden = true
            cell.green.isHidden = false
            cell.greenLen.constant = CGFloat(userPresenter.bigpercent2(str: cell.bids_c.text!))
        }else{
            cell.red.isHidden = false
            cell.green.isHidden = true
            cell.redLen.constant = CGFloat(userPresenter.bigpercent2(str: cell.asks_c.text!))
        }
        
        return cell
    }
    
    // willDisplay function
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleRows = tableView.indexPathsForVisibleRows, let lastRow = visibleRows.last?.row, let lastSection = visibleRows.map({$0.section}).last {
            if indexPath.row == lastRow && indexPath.section == lastSection {
                userPresenter.tableDone()
            }
        }
    }
    
    //스크롤시 새로고침 잠금
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userPresenter.BeginDragging()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        userPresenter.EndDragging()
    }
    
}

extension orderbook: OrderView2 {
    
    func recent_text(str: String){
        resent_trade.text = str
    }
    
    func show_hud(){
        margin.show_hud(self.view,"Loading")
        
    }
    
    func dissmiss_hud(){
        margin.dissmiss_hud()
    }
    
    func reload_table(){
        self.tableview.reloadData()
    }
    
    func set_theme(){
        view1.layer.cornerRadius = 5
        //self.view1.layer.borderWidth = 1
        view2.layer.cornerRadius = 5
        //tableview.layer.cornerRadius = 5
        //self.view2.layer.borderWidth = 1
        
        askLabel.layer.masksToBounds = true
        askLabel.layer.cornerRadius = 5
        priceLabel.layer.masksToBounds = true
        priceLabel.layer.cornerRadius = 5
        bidLabel.layer.masksToBounds = true
        bidLabel.layer.cornerRadius = 5
        
        tableview.backgroundColor = UIColor.appColor(.table_in)
        view1.backgroundColor = UIColor.appColor(.table_in)
        //view1.layer.borderColor = UIColor.appColor(.border)?.cgColor
        view2.backgroundColor = UIColor.appColor(.table_in)
        //view2.layer.borderColor = UIColor.appColor(.border)?.cgColor
        view.backgroundColor = UIColor.appColor(.table_out)
        
        cellBottom.layer.cornerRadius = 5
        cellBottom.backgroundColor = UIColor.appColor(.table_in)
    }
    
}
