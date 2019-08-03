//
//  setting_Presenter.swift
//  margin
//
//  Created by USER on 31/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import StoreKit

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
            "ZAlertView\n(https://github.com/zelic91/ZAlertView)\nMIT license.\n\n" +
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
        userView?.cpoy_clipboard(str: "iveinvalue@gmail.com")
        showAlert(userView as? UIViewController,"iveinvalue@gmail.com","Copied email")
    }
    
    func make_inapp(){
        //SKPaymentQueue.default().add(self)
        //getProductInfo()
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
    
    /*
    // 상품 정보 요청 함수
    func getProductInfo(){
        if SKPaymentQueue.canMakePayments() {
            // 애플에 상품 정보 요청, 요청이 완료되면 바로 아래 함수인 productsRequest함수가 자동 호출된다.
            let request = SKProductsRequest(productIdentifiers: NSSet(object: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        }else{
            userView?.show_dialog(title: "ERROR", str: "Enable In-app Billing in Settings")
        }
    }
    
    // 상품 정보 수신 관련 delegate함수
    func productsRequest(_ request: SKProductsRequest, didReceive response:SKProductsResponse){
        
        var products = response.products
        // 상품 정보가 정상적으로 수신되었을 경우 화면에 상품 정보 갱신 및 구매 버튼 활성화 처리한다.
        if products.count != 0 {
            product = products[0] as SKProduct
            /*let dialog = ZAlertView(title: product!.localizedTitle, message: product!.localizedDescription, closeButtonText: "Purchase", closeButtonHandler: {
                alertView in alertView.dismissAlertView()
                let payment = SKPayment(product: self.product!)
                SKPaymentQueue.default().add(payment)
            })
            dialog.show()*/
        }else{
            userView?.show_dialog(title: "ERROR", str: "Can not check product information registered in Apple account")
        }
        let productList = response.invalidProductIdentifiers
        for productItem in productList{
            print("Product not found : \(productItem)")
        }
    }
    
    // 상품 구매를 위해 결제 요청후 자동으로 호출되는 delegate함수
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction]{
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                // 구매가 정상적으로 완료될 경우 후처리 시작
                self.unlockFeature()
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            default: break
            }
        }
    }
    
    // 상품 구매가 완료되었을 경우 앱내 후처리(실제로는 구매번호, 구매일자등을 로컬에 저장해 둔다)
    func unlockFeature(){
        UserDefaults.standard.set(97970505, forKey: "world") // Save
        userView?.show_dialog(title: "Success", str: "")
    }
     */
    
}
