//
//  File.swift
//  margin
//
//  Created by USER on 20/08/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit

let SandBox =  "https://sandbox.itunes.apple.com/verifyReceipt"
let iTunes =  "https://buy.itunes.apple.com/verifyReceipt"

func receiptValidation(vv:UserView) {
    let receiptFileURL = Bundle.main.appStoreReceiptURL
    let receiptData = try? Data(contentsOf: receiptFileURL!)
    let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    if (recieptString != nil){
        setData("riap", recieptString as Any)
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : aa as AnyObject]
        //print(jsonDict.description + "=======")
        rcheck(jsonDict: jsonDict,vview: vv,pop: true)
    }
}

func receiptValidation2(vv:UserView) {
    let recieptString = getData("riap")
    if (recieptString != ""){
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString as AnyObject, "password" : aa as AnyObject]
        //print(jsonDict.description + "=======")
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
        let verifyReceiptURL = SandBox
        let storeURL = URL(string: verifyReceiptURL)!
        var storeRequest = URLRequest(url: storeURL)
        storeRequest.httpMethod = "POST"
        storeRequest.httpBody = requestData

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: storeRequest, completionHandler: { data, response, error in
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                print("------------------------------------------")
//                print("=======>",jsonResponse)
//                print("------------------------------------------")
                if let date = getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                    let nowdate = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                    formatter.timeZone = TimeZone(secondsFromGMT:0)
                    let tmp = formatter.string(from: nowdate)
                    let defaultTimeZoneStr = formatter.date(from: tmp)
                    
                    print(defaultTimeZoneStr!.description + "======")
                    print(date.description + "======")
                    
                    var userView : UserView?
                    userView = vview
                    
                    if (nowdate < date){
                        beta = true
                        if(pop){
                            DispatchQueue.main.async {
                                showAlert(userView as? UIViewController,"Success","Pro version is activated")
                            }
                        }
                    }else{
                        beta = false
                        setData("riap", "")
                    }
                    userView!.setTopBtn()
                }
            } catch let parseError {
                print(parseError)
            }
        })
        task.resume()
    } catch let parseError {
        print(parseError)
    }
}

func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
    if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
        
        print(receiptInfo)
        print("=========================111")
        let lastReceipt = receiptInfo.lastObject as! NSDictionary
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        
        if let expiresDate = lastReceipt["expires_date"] as? String {
            return formatter.date(from: expiresDate)
        }
        
        return nil
    }
    else {
        return nil
    }
}
