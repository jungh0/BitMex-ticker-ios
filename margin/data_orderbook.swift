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


class data_orderbook: UITableViewController {
    @IBOutlet var tableview: UITableView!
    var timer:Timer!
    
    //새로고침
    @objc func timerDidFire(){
        tableview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let msg = "{\"op\": \"subscribe\", \"args\": [\"orderBook10:" + chart_symbol + "\"]}"
        ws.send(msg)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let msg = "{\"op\": \"unsubscribe\", \"args\": [\"orderBook10:" + chart_symbol + "\"]}"
        ws.send(msg)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderbook.removeAll()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 1, target: self, selector: #selector(data_chart.timerDidFire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderbook.count
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "order_cell", for: indexPath) as! order_cell
        cell.asks_c.text = orderbook[indexPath.row][0]
        cell.price.text = orderbook[indexPath.row][1]
        cell.bids_c.text = orderbook[indexPath.row][2]
        
        if (orderbook[indexPath.row][2].contains("-")){
            cell.price.textColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1) as UIColor
            cell.bids_c.text = ""
        }
        if (orderbook[indexPath.row][0].contains("-")){
            cell.price.textColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1) as UIColor
            cell.asks_c.text = ""
        }
        
        return cell
    }
}

class order_cell: UITableViewCell {
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bids_c: UILabel!
    @IBOutlet weak var asks_c: UILabel!
}
