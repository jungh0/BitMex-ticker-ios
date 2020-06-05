//
//  File.swift
//  margin
//
//  Created by USER on 20/08/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit


//let url = "https://sandbox.itunes.apple.com/verifyReceipt"
let url =  "https://buy.itunes.apple.com/verifyReceipt"

func receiptValidation(vv:UserView) {
    let receiptFileURL = Bundle.main.appStoreReceiptURL
    let receiptData = try? Data(contentsOf: receiptFileURL!)
    let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    if (recieptString != nil){
        setData("riap", recieptString as Any)
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : aa as AnyObject]
        //        print(jsonDict.description + " =iap", "mydebugog")
        rcheck(jsonDict: jsonDict,vview: vv,pop: true)
    }
}

func receiptValidation2(vv:UserView) {
    let recieptString = getData("riap")
    if (recieptString != ""){
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString as AnyObject, "password" : aa as AnyObject]
        //        print(jsonDict.description + " =iap", "mydebugog")
        rcheck(jsonDict: jsonDict,vview: vv,pop: false)
    }else{
        var userView : UserView?
        userView = vv
        userView!.setTopBtn()
    }
}

func rcheck(jsonDict:[String: AnyObject],vview:UserView,pop:Bool){
    do {
        let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let verifyReceiptURL = url
        let storeURL = URL(string: verifyReceiptURL)!
        var storeRequest = URLRequest(url: storeURL)
        storeRequest.httpMethod = "POST"
        storeRequest.httpBody = requestData
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: storeRequest, completionHandler: { data, response, error in
            do {
                let result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                print(result.description , "mydebugog")
                
                if(result.contains("\"status\":0")){
                    print("ok" , "mydebugog")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                    formatter.timeZone = TimeZone(secondsFromGMT:0)
                    let nowdate = Date()
                    let tmp = formatter.string(from: nowdate)
                    let now = formatter.date(from: tmp)
                    gogogo(vview,pop,now!)
                }else{
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    if let date = getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd VV"
                        dateFormatter.timeZone = TimeZone.current
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                        formatter.timeZone = TimeZone(secondsFromGMT:0)
                        
                        let nowdate = Date()
                        
                        let tmp = formatter.string(from: nowdate)
                        let now = formatter.date(from: tmp)
                        print(now!.description + "=iap date now" , "mydebugog")
                        
                        print(date.description + "=iap date pay" , "mydebugog")
                        
                        let tmp1 = dateFormatter.string(from: date)
                        let exdate = dateFormatter.date(from: tmp1)
                        print(exdate!.description + "=iap date expire" , "mydebugog")
                        
                        if (nowdate <= date){
                            gogogo(vview,pop,exdate!)
                        }else{
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
                        vview.setTopBtn()
                    }else{
                        print("oh", "mydebugog")
                        fail(vview)
                    }
                }
                
                
            } catch let parseError {
                print(parseError)
                fail(vview)
            }
        })
        task.resume()
    } catch let parseError {
        print(parseError)
        fail(vview)
    }
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

func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
    //    print(jsonResponse.description, "mydebugog")
    if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
        //        print("------------------------------------------")
        //        print("=======>",receiptInfo)
        //        print("------------------------------------------")
        //
        //        print(receiptInfo , "mydebugog")
        let lastReceipt = receiptInfo.lastObject as! NSDictionary
        
        if let expiresDate = lastReceipt["expires_date"] as? String {
            return formatter.date(from: expiresDate)
        }
        
        return returnStatus(jsonResponse)
    }
    else {
        return returnStatus(jsonResponse)
    }
}

func returnStatus(_ jsonResponse: NSDictionary) -> Date?{
    print(jsonResponse.description , "mydebugog")
    if let receiptInfo: NSArray = jsonResponse["status"] as? NSArray {
        print(receiptInfo.description + "=iap status" , "mydebugog")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        formatter.timeZone = TimeZone(secondsFromGMT:0)
        let nowdate = Date()
        let tmp = formatter.string(from: nowdate)
        let now = formatter.date(from: tmp)
        
        return now
    }
    else {
        print("oh2", "mydebugog")
        return nil
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

