//
//  File.swift
//  margin
//
//  Created by USER on 20/08/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit


func receiptValidation(vv:UserView) {
    let receiptFileURL = Bundle.main.appStoreReceiptURL
    let receiptData = try? Data(contentsOf: receiptFileURL!)
    let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    if (recieptString != nil){
        setData("riap", recieptString as Any)
        sendServerToVerify(data: recieptString!,vv : vv,pop: true)
        //        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : aa as AnyObject]
        //print(recieptString!.description , "mydebugog")
        //        rcheck(jsonDict: jsonDict,vview: vv,pop: true)
    }else{
        print("no reciept" , "mydebugog")
    }
}

func receiptValidation2(vv:UserView) {
    let recieptString = getData("riap")
    //print(recieptString, "mydebugog")
    if (recieptString != ""){
        //        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString as AnyObject, "password" : aa as AnyObject]
        //print(recieptString.description , "mydebugog")
        sendServerToVerify(data: recieptString,vv : vv,pop: false)
        //        rcheck(jsonDict: jsonDict,vview: vv,pop: false)
    }else{
        var userView : UserView?
        userView = vv
        userView!.setTopBtn()
    }
}

func sendServerToVerify(data:String,vv:UserView,pop:Bool){
    let parameters: [String: Any] = [
        "content": data
    ]
    requestHTTPPost(urll: "http://wiffy.io/bitmex/buy/check.php",data:parameters,completion: { result in
        print(result, "mydebugog1")

        if (result == ""){
            nonono(vv,pop,makeNow())
        }else if (result == "suc"){
            gogogo(vv,pop,makeNow())
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            formatter.timeZone = TimeZone.current
            let nowDate = makeNow()
            
            let expireDate = formatter.date(from: result) ?? nowDate
            
            
            print(nowDate.description + " date now" , "mydebugog")
            print(expireDate.description + " date expire" , "mydebugog")
            
            if (nowDate <= expireDate){
                gogogo(vv,pop,makeNow())
            }else{
                nonono(vv,pop,makeNow())
            }
            
        }
        vv.setTopBtn()
    })
}



func fail(_ vview: UserView){
    DispatchQueue.main.async {
        if let userDefaults = UserDefaults(suiteName: "group.margin.symbol") {
            userDefaults.set("", forKey: "exdate")
            userDefaults.set("false", forKey: "orp")
        }
        showAlert(vview as? UIViewController,"Fail","Purchase Verification Failed")
        dissmiss_hud()
    }
}


func gogogo(_ vview:UserView,_ pop:Bool, _ exdate:Date){
    beta = true
    if(pop){
        DispatchQueue.main.async {
            showAlert(vview as? UIViewController,"Success","Pro version is activated")
            dissmiss_hud()
        }
    }
    if let userDefaults = UserDefaults(suiteName: "group.margin.symbol") {
        userDefaults.set(exdate.description, forKey: "exdate")
        userDefaults.set("true", forKey: "orp")
    }
    vview.setTopBtn()
}

func nonono(_ vview:UserView,_ pop:Bool, _ exdate:Date){
    beta = false
    if(pop){
        DispatchQueue.main.async {
            showAlert(vview as? UIViewController,"Fail","Purchase history not confirmed")
            dissmiss_hud()
        }
    }
    setData("riap", "")
    if let userDefaults = UserDefaults(suiteName: "group.margin.symbol") {
        userDefaults.set("", forKey: "exdate")
        userDefaults.set("false", forKey: "orp")
    }
}

func makeNow() -> Date{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
    formatter.timeZone = TimeZone.current
    
    let nowdate = Date()
    let tmp = formatter.string(from: nowdate)
    return formatter.date(from: tmp)!
}
