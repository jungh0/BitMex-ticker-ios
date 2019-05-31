//
//  ws_func.swift
//  margin
//
//  Created by USER on 30/01/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

/*
import Foundation
import SwiftWebSocket

func ws_(){
    let send : ()->() = {
        
        if(list.count > 0){
            if (restart == 0){
                for i in 0 ... list.count - 1 {
                    let msg = "{\"op\": \"subscribe\", \"args\": [\"tradeBin1m:" + list[i][0] + "\"]}"
                    //print("send: \(msg)")
                    ws.send(msg)
                }
            }
            if (restart == 1){
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
        //self.navigationItem.prompt = "connecting server..."
        print("send: connecting server..." + list.count.description)
        restart = 0
        if(list.count > 0){
            for i in 0 ... list.count - 1 {
                if(list[i][2].contains("y")){
                    list[i][2] = "n"
                }
            }
        }
        ws = WebSocket("wss://www.bitmex.com/realtime")
        ws_()
    }
    ws.event.error = { error in
        print("error \(error)")
    }
    ws.event.message = { message in
        if let text = message as? String {
            //print(text)
            if(text.contains("\"table\":\"orderBook10\"")){
                order_parse(str: text)
            }
            else if(list.count>0){
                for i in 0 ... list.count - 1 {
                    if(list[i][2].contains("n")){
                        _1m_parse(str: text,symbol: list[i][0],index: i)
                    }else{
                        price_parse(str: text,symbol: list[i][0],index: i)
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

func order_parse(str:String){
    let asks_str = split(str: str,w1: "\"asks\":[[",w2: "]]")
    //print(asks_str)
    var asks_array = asks_str.components(separatedBy: "],[")
    
    let bids_str = split(str: str,w1: "\"bids\":[[",w2: "]]")
    //print(bids_str)
    var bids_array = bids_str.components(separatedBy: "],[")
    
    orderbook.removeAll()
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

func price_parse(str:String,symbol:String,index:Int){
    if (str.contains(symbol)){
        if (str.contains("\"price\"")){
            let price = split(str: str,w1: "\"price\":",w2: ",")
            //print(symbol + ": " + price)
            if(!price.contains("\"")){
                //self.navigationItem.prompt = "connected"
                //recent.text = symbol + ": " + price
                let b_o_s = split(str: str,w1: "\"side\":\"",w2: "\",")
                let amount = split(str: str,w1: "\"size\":",w2: ",")
                recent_str = symbol + " : " + price + " - " + b_o_s
                //print(str)
                if (symbol.contains(chart_symbol)){
                    recent_str_order = symbol + " : " + price + " - " + b_o_s  + " - " + amount
                }
                
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
            }
        }
    }
}

func _1m_parse(str:String,symbol:String,index:Int){
    //print(str)
    if (str.contains("\"symbol\":\"" + symbol + "\",")){
        let str = split(str: str,w1: "\"symbol\":\"" + symbol + "\",",w2: "]")
        if (str.contains("\"close\"")){
            let price = split(str: str,w1: "\"close\":",w2: ",")
            let open = split(str: str,w1: "\"open\":",w2: ",")
            //print(symbol + ": " + price)
            if(!price.contains("\"")){
                //self.navigationItem.prompt = "connected"
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
                
                //tableview.reloadData()
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
*/
