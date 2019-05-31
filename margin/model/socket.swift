//
//  socket.swift
//  margin
//
//  Created by USER on 29/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import SwiftWebSocket

class socket{

    var c_list = [[String]]()
    var orderbook = [[String]]()
    var chart_symbol = ""
    var recent_str = "---"
    var recent_str_order = "---"
    
    var is_waiting = true //소켓에 접속되었는지 확인
    var ws: WebSocket
    
    func c_list_append(list:[String]){
        c_list.append(list)
    }
    
    func orderbook_reset(){
        orderbook.removeAll()
    }
    
    init (wss:String){
        self.ws = WebSocket(wss)
    }
    
    func start(){
        self.ws.event.open = {
            print("opened")
            self.make_subscribe(str: "tradeBin1m")
        }
        self.ws.event.close = { code, reason, clean in
            print("close")
            self.is_waiting = true
            self.restart()
        }
        self.ws.event.error = { error in
            print("error \(error)")
        }
        self.ws.event.message = { message in
            if let text = message as? String {
                self.is_waiting = false
                self.socket_do(text: text)
                //print(text)
            }
        }
    }
    
    func restart(){
        print("restart")
        if(c_list.count>0){
            for i in 0 ... c_list.count - 1 {
                c_list[i][2] = "n"
            }
        }
        self.ws.close()
        self.ws = WebSocket("wss://www.bitmex.com/realtime")
        self.start()
    }
    
    private func make_subscribe(str:String){
        for i in 0 ... c_list.count - 1 {
            send(str1: "subscribe",str2: str,str3: c_list[i][0])
        }
    }
    
    public func send(str1:String,str2:String,str3:String){
        let msg = "{\"op\": \"" + str1 + "\", \"args\": [\"" + str2 + ":" + str3 + "\"]}"
        //print("send: \(msg)")
        self.ws.send(msg)
    }
    
    private func socket_do(text:String){
        if(text.contains("\"table\":\"orderBook10\"")){
            order_parse(str: text)
        }
        else if(c_list.count>0){
            for i in 0 ... c_list.count - 1 {
                if(c_list[i][2].contains("n")){
                    _1m_parse(str: text,symbol: c_list[i][0],index: i)
                }else{
                    price_parse(str: text,symbol: c_list[i][0],index: i)
                }
            }
        }
    }
    
    private func compare(ori:String,new:String,color:String) -> String{
        let ori_ns = NSString(string: ori)
        let new_ns = NSString(string: new)
        if (new_ns.doubleValue > ori_ns.doubleValue){
            return "g"
        }
        if (new_ns.doubleValue < ori_ns.doubleValue){
            return "r"
        }
        return color
    }
    
    private func make_0(str:String) -> String{
        if(!str.contains(".")){
            return str + ".0"
        }else{
            return str
        }
    }
    
    private func price_parse(str:String,symbol:String,index:Int){
        if (str.contains(symbol)){
            if (str.contains("\"price\"")){
                let price = split(str: str,w1: "\"price\":",w2: ",")
                if(!price.contains("\"")){
                    let b_o_s = split(str: str,w1: "\"side\":\"",w2: "\",")
                    let amount = split(str: str,w1: "\"size\":",w2: ",")
                    recent_str = symbol + " : " + price + " - " + b_o_s
                    if (symbol.contains(chart_symbol)){
                        recent_str_order = symbol + " : " + price + " - " + b_o_s  + " - " + amount
                    }
                    c_list[index][4] = self.compare(ori: c_list[index][1],new: price, color:c_list[index][4])
                    c_list[index][1] = self.make_0(str: price)
                }
            }
        }
    }
    
    private func _1m_parse(str:String,symbol:String,index:Int){
        if (str.contains("\"symbol\":\"" + symbol + "\",")){
            let str = split(str: str,w1: "\"symbol\":\"" + symbol + "\",",w2: "]")
            if (str.contains("\"close\"")){
                let price = split(str: str,w1: "\"close\":",w2: ",")
                let open = split(str: str,w1: "\"open\":",w2: ",")
                if(!price.contains("\"")){
                    c_list[index][4] = self.compare(ori: open,new: price, color:c_list[index][4])
                    c_list[index][1] = self.make_0(str: price)
                    c_list[index][2] = "y"
                
                    self.send(str1: "unsubscribe",str2: "tradeBin1m",str3: c_list[index][0])
                    self.send(str1: "subscribe",str2: "trade",str3: c_list[index][0])
                }
            }
        }
    }
    
    private func order_parse(str:String){
        let asks_str = split(str: str,w1: "\"asks\":[[",w2: "]]")
        //print(asks_str)
        var asks_array = asks_str.components(separatedBy: "],[")
        
        let bids_str = split(str: str,w1: "\"bids\":[[",w2: "]]")
        //print(bids_str)
        var bids_array = bids_str.components(separatedBy: "],[")
        
        orderbook_reset()
        for i in 0 ... asks_array.count - 1 {
            orderbook.append([
                asks_array[asks_array.count - i - 1].components(separatedBy: ",")[1],
                asks_array[asks_array.count - i - 1].components(separatedBy: ",")[0],"-"])
        }
        for i in 0 ... asks_array.count - 1 {
            orderbook.append(["-",
                              bids_array[i].components(separatedBy: ",")[0],
                              bids_array[i].components(separatedBy: ",")[1]])
        }
        //print(orderbook)
    }

    private func split(str:String,w1:String,w2:String) -> String{
        return str.components(separatedBy: w1)[1].components(separatedBy: w2)[0]
    }
    
}
