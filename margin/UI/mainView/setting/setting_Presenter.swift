//
//  setting_Presenter.swift
//  margin
//
//  Created by USER on 31/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import StoreKit
import UIKit

protocol SettingView: NSObjectProtocol {
    
    func open_url(str: String)
    func cpoy_clipboard(str: String)
    func set_theme()
    
}

class setting_Presenter /*: SKPaymentTransactionObserver, SKProductsRequestDelegate*/ {
    
    private var userView : SettingView?
    //private var product:SKProduct?
    //var productID = "remove_ad"   // iTunesConnect에서 생성한 IAP결제 Free용 제품에 대한 식별자
    
    init(){
        
    }
    
    func attachView(_ view: SettingView){
        userView = view
        userView?.set_theme()
    }
    
    func detachView() {
        userView = nil
    }
    
    func make_open_dialog(){
        showAlert(userView as? UIViewController,"OpenSource",
                  "SwiftWebSocket\n(https://github.com/tidwall/SwiftWebSocket)\nMIT License.\n\n" +
                    "JGProgressHUD\n(https://github.com/JonasGessner/JGProgressHUD)\n©2014-2018, Jonas Gessner.\nMIT License.\n\n" +
            "SwiftSoup\n(https://github.com/scinfu/SwiftSoup)\nMIT License.")
    }
    
    func make_version_dialog(){
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        showAlert(userView as? UIViewController,"Version",version + "(" + build + ")")
    }
    
    func make_url(){
        userView?.open_url(str: "itms-apps://itunes.apple.com/us/app/apple-store/id1450104461?mt=8")
    }
    
    func make_clipboard(){
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        userView?.cpoy_clipboard(str: "iveinvalue@gmail.com")
        showAlert(userView as? UIViewController,"iveinvalue@gmail.com\n(Copied in clipboard)","Please include Device type , ios version, app version(" + version + ")")
    }
    
    func fastFeedback(){
        let alert = UIAlertController(title: "Fast Feedback", message: "Please enter any bugs or improvements", preferredStyle: .alert)
        alert.addTextField { (textField) in
            //textField.text = "Some default text"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancel)
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            var device = ""
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    device = "iPhone 5 or 5S or 5C"
                case 1334:
                    device = "iPhone 6/6S/7/8"
                case 2208:
                    device = "iPhone 6+/6S+/7+/8+"
                case 2436:
                    device = "iPhone X"
                default:
                    device = "unknown"
                }
            }
            let systemVersion = UIDevice.current.systemVersion
            let systemName = UIDevice.current.systemName
            let model = UIDevice.current.model
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            if (textField!.text!.count > 0){
                self.gobug(textField!.text! + "/" + device + "/" + systemVersion + "/" + systemName + "/" + model + "/" + appVersion)
            }
        }))
        (self.userView as? UIViewController)!.present(alert, animated: true, completion: nil)
    }
    
    func gobug(_ str:String){
        let url = "http://wiffy.io/bitmex/reportios.php?content=" + str
        let str_url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        requestHTTP(url: str_url!,completion: { result in
            DispatchQueue.main.async {
                showAlert(self.userView as? UIViewController,"Success","Thanks")
            }
        })
    }
    
    func change_theme(){
        if(dark_theme){
            dark_theme = false
            setData("theme2",0)
        }else{
            dark_theme = true
            setData("theme2",1)
        }
        userView?.set_theme()
    }
    
    
    
}
