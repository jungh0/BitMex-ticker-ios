//
//  ticker_table.swift
//  margin
//
//  Created by User on 29/12/2018.
//  Copyright © 2018 jungho. All rights reserved.
//

import UIKit
import Foundation
import SwiftWebSocket

var chart_symbol = ""
var ws = WebSocket("wss://www.bitmex.com/realtime")
var list = [[String]]()

class ticker_table: UITableViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var recent: UILabel!
    
    var restart = 0
    var is_scroll = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationItem.prompt = "connecting server..."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.append(["XBTUSD","---","n","Bitcoin | Perpetual (100x)","n"])
        list.append(["ADAH19","---","n","Cardano | Mar 29 (20x)","n"])
        list.append(["BCHH19","---","n","BitcoinCash | Mar 29 (20x)","n"])
        list.append(["EOSH19","---","n","EOS | Mar 29 (20x)","n"])
        list.append(["ETHUSD","---","n","Ethereum | Perpetual (50x)","n"])
        list.append(["ETHH19","---","n","Ethereum | Mar 29 (20x)","n"])
        list.append(["LTCH19","---","n","Litecoin | Mar 29 (20x)","n"])
        list.append(["TRXH19","---","n","Tron | Mar 29 (20x)","n"])
        list.append(["XRPH19","---","n","Ripple | Mar 29 (20x)","n"])
        
        ws_()

        tableview.dataSource = self
        tableview.delegate = self
    }
  
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ticker_cell", for: indexPath) as! ticker_cell
        cell.symbol.text = list[indexPath.row][0]
        cell.ticker.text = list[indexPath.row][1]
        cell.symbol2.text = list[indexPath.row][3]
        if (list[indexPath.row][4].contains("g")){
            cell.ticker.textColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1) as UIColor
        }
        if (list[indexPath.row][4].contains("r")){
            cell.ticker.textColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1) as UIColor
        }
        if (list[indexPath.row][4].contains("n")){
            cell.ticker.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1) as UIColor
        }
        let customBGColorView = UIView()
        customBGColorView.backgroundColor = UIColor(red: 8/255, green: 23/255, blue: 35/255, alpha: 1) as UIColor
        cell.selectedBackgroundView = customBGColorView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chart_symbol = list[indexPath.row][0]
        let data_chart_ = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! tabbar
        self.navigationController?.pushViewController(data_chart_, animated: true)
    }
    
    func ws_(){
        //var messageNum = 0
        let send : ()->() = {
            //messageNum += 1
            
            if(list.count > 0){
                if (self.restart == 0){
                    for i in 0 ... list.count - 1 {
                        let msg = "{\"op\": \"subscribe\", \"args\": [\"tradeBin1m:" + list[i][0] + "\"]}"
                        //print("send: \(msg)")
                        ws.send(msg)
                    }
                }
                if (self.restart == 1){
                    for i in 0 ... list.count - 1 {
                        let msg = "{\"op\": \"subscribe\", \"args\": [\"trade:" + list[i][0] + "\"]}"
                        //print("send: \(msg)")
                        ws.send(msg)
                    }
                }
            }
            
            
            
        }
        ws.event.open = {
            print("opened")
            send()
        }
        ws.event.close = { code, reason, clean in
            print("close")
            self.navigationItem.prompt = "connecting server..."
            self.restart = 1
            ws = WebSocket("wss://www.bitmex.com/realtime")
            self.ws_()

            
        }
        ws.event.error = { error in
            print("error \(error)")
        }
        ws.event.message = { message in
            if let text = message as? String {
                //print(text)
                if(list.count>0){
                    for i in 0 ... list.count - 1 {
                        if(list[i][2].contains("n")){
                            self._1m_parse(str: text,symbol: list[i][0],index: i)
                        }else{
                            self.price_parse(str: text,symbol: list[i][0],index: i)
                        }
                    }
                }
                
                //ws.close()
                //send()
            }
        }
    }
    
    func split(str:String,w1:String,w2:String) -> String{
        return str.components(separatedBy: w1)[1].components(separatedBy: w2)[0]
    }
    
    func price_parse(str:String,symbol:String,index:Int){
        if (str.contains(symbol)){
            if (str.contains("\"price\"")){
                let price = self.split(str: str,w1: "\"price\":",w2: ",")
                //print(symbol + ": " + price)
                if(!price.contains("\"")){
                    self.navigationItem.prompt = "connected"
                    recent.text = symbol + ": " + price
                    let ori = NSString(string: list[index][1])
                    let new = NSString(string: price)
                    if (new.doubleValue > ori.doubleValue){
                        list[index][4] = "g"
                    }
                    if (new.doubleValue < ori.doubleValue){
                        list[index][4] = "r"
                    }
                    if(!price.contains(".")){
                        list[index][1] = price + ".0"
                    }else{
                        list[index][1] = price
                    }
                    if (is_scroll == 0){
                        tableview.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func _1m_parse(str:String,symbol:String,index:Int){
        //print(str)
        if (str.contains("\"symbol\":\"" + symbol + "\",")){
            let str = self.split(str: str,w1: "\"symbol\":\"" + symbol + "\",",w2: "]")
            if (str.contains("\"close\"")){
                let price = self.split(str: str,w1: "\"close\":",w2: ",")
                let open = self.split(str: str,w1: "\"open\":",w2: ",")
                //print(symbol + ": " + price)
                if(!price.contains("\"")){
                    self.navigationItem.prompt = "connected"
                    let ori = NSString(string: open)
                    let new = NSString(string: price)
                    list[index][4] = "n"
                    if (new.doubleValue > ori.doubleValue){
                        list[index][4] = "g"
                    }
                    if (new.doubleValue < ori.doubleValue){
                        list[index][4] = "r"
                    }
                    
                    if(!price.contains(".")){
                        list[index][1] = price + ".0"
                    }else{
                        list[index][1] = price
                    }
                    
                    tableview.reloadData()
                    list[index][2] = "y"
                    
                    let msg1 = "{\"op\": \"unsubscribe\", \"args\": [\"tradeBin1m:" + list[index][0] + "\"]}"
                    //print("send: \(msg1)")
                    ws.send(msg1)
                    
                    let msg2 = "{\"op\": \"subscribe\", \"args\": [\"trade:" + list[index][0] + "\"]}"
                    //print("send: \(msg2)")
                    ws.send(msg2)
                }
            }
        }
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        is_scroll = 1
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let time = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.is_scroll = 0
            self.tableview.reloadData()
        }
        
    }
    
}


class ticker_cell: UITableViewCell {
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var symbol2: UILabel!
}
