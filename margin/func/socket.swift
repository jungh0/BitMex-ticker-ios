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
    var chart_symbol = ""
    var recent_str_order = "---"
    var errormsg = ""
    var forcestop = 0
    
    var is_waiting = true //소켓에 접속되었는지 확인
    var ws: WebSocket
    
    var orderComplete: ((String)->())?
    var priceComplete: ((String)->())?
    
    func setOrderComplete(completion: @escaping (String)->()){
        orderComplete = completion
    }
    
    func setPriceComplete(completion: @escaping (String)->()){
        priceComplete = completion
    }
    
    func c_list_append(list:[String]) {
        c_list.append(list)
    }
    
    init (wss:String){
        self.ws = WebSocket(wss)
    }
    
    func start(){
        self.ws.event.open = {
            print("opened")
            self.make_subscribe()
        }
        self.ws.event.close = { code, reason, clean in
            print("close\(reason)")
            if(self.is_waiting == false && self.forcestop == 0){
                self.is_waiting = true
                self.restart()
            }
        }
        self.ws.event.error = { error in
            let tmp = "\(error)"
            print(tmp)
            if (tmp.contains("Too Many Requests")){
                self.is_waiting = true
                self.forcestop = 1
                self.errormsg = "Too Many Requests"
                self.ws.close()
            }else{
                self.is_waiting = true
                self.restart()
            }
        }
        self.ws.event.message = { message in
            if let text = message as? String {
                //print(text)
                self.is_waiting = false
                self.socket_do(text: text)
//                if(text.contains("\"status\":429,\"error\":\"")){
//                    func errormsg(str:String)
//                }
            }
        }
    }
    
//    func errormsg(str:String){
//        for (index,iList) in c_list.enumerated() {
//            if (str.contains("\"trade:" + iList[0] + "\"")){
//                c_list[index][1] = "ERROR"
//            }
//        }
//    }
    
    func restart(){
        print("restart")
        self.ws = WebSocket("wss://www.bitmex.com/realtime")
        self.start()
    }
    
    private func make_subscribe(){
        var subarg = ""
        for iList in c_list {
            if (subarg != ""){
                subarg = subarg + ","
            }
            subarg = subarg + "\"" + "trade" + ":" + iList[0] + "\""
        }
//        for iList in c_list {
//            subarg = subarg + ","
//            subarg = subarg + "\"" + "tradeBin1m" + ":" + iList[0] + "\""
//        }
        let msg = "{\"op\": \"" + "subscribe" + "\", \"args\": [" + subarg + "]}"
        //print("aaaasend: \(msg)")
        self.ws.send(msg)
    }
    
    public func send(str1:String,str2:String,str3:String){
        let msg = "{\"op\": \"" + str1 + "\", \"args\": [\"" + str2 + ":" + str3 + "\"]}"
        //print("send: \(msg)")
        self.ws.send(msg)
    }
    
    private func socket_do(text:String){
        if let tableData = getAnyJson(json: text,str: "table") as? String {
            if(tableData == "orderBook10"){
                if (orderComplete != nil){
                    orderComplete!(text)
                }
            }
//            else if(tableData == "tradeBin1m"){
//                for (index,iList) in c_list.enumerated() {
//                    _1m_parse(str: text,symbol: iList[0],index: index)
//                }
//            }
            else if(tableData == "trade"){
                price_parse(str: text)
                if (priceComplete != nil){
                    //print(arc4random_uniform(10000).description)
                    priceComplete!("")
                }
            }
        }
    }
    
    private func price_parse(str:String){
        if let jsonData = getAnyJson(json: str,str: "data") as? [[String:AnyObject]] {
            if(jsonData.description != "[]"){
                for tmp in jsonData{
                //if (jsonData.count > 0){
                    let symbolData = (tmp["symbol"] as? String) ?? ""
                    for (index,iList) in c_list.enumerated() {
                        let symbol = iList[0]
                        if(symbolData == symbol){
                            let priceData = (tmp["price"] as? Double) ?? 0
                            let sideData = (tmp["side"] as? String) ?? ""
                            let sizeData = (tmp["size"] as? Double) ?? 0
                            
                            if (symbol == chart_symbol){
                                recent_str_order = symbol + " : " + priceData.description + " - " + sideData.description  + " - " + sizeData.description
                            }
                            
                            if(sideData == "Buy"){
                                c_list[index][4] = "g"
                            }
                            if(sideData == "Sell"){
                                c_list[index][4] = "r"
                            }
                            c_list[index][1] = self.make_0(str: priceData.toString())
//                            if(Double(c_list[index][1]) != Double(priceData)){
//                                if (c_list[index][1] != "---"){
//                                    c_list[index][4] = self.compare(ori: Double(c_list[index][1]) ?? 0,
//                                                                    new: priceData,
//                                                                    color: c_list[index][4])
//                                }
//
//                            }
                            break
                        }
                    }
                }
            }
        }
    }
    
//    private func _1m_parse(str:String,symbol:String,index:Int){
//        //print(str)
//        if let jsonData = getAnyJson(json: str,str: "data") as? [[String:AnyObject]]{
//            if(jsonData.description != "[]"){
//                if (jsonData.count > 0){
//                    let symbolData = (jsonData[0]["symbol"] as? String) ?? ""
//                    if(symbolData == symbol){
//                        let closeData = (jsonData[0]["close"] as? Double) ?? 0
//                        let openData = (jsonData[0]["open"] as? Double) ?? 0
//
//                        if (c_list[index][1] == "---"){
//                            c_list[index][4] = self.compare(ori: openData,
//                                                            new: closeData,
//                                                            color: c_list[index][4])
//                            c_list[index][1] = self.make_0(str: closeData.toString())
//                        }
//
//                        self.send(str1: "unsubscribe",str2: "tradeBin1m",str3: c_list[index][0])
//                        //self.send(str1: "subscribe",str2: "trade",str3: c_list[index][0])
//                    }
//                }
//            }
//        }
//    }
    
    private func compare(ori:Double,new:Double,color:String) -> String{
        if (new > ori){
            return "g"
        }
        if (new < ori){
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
}
