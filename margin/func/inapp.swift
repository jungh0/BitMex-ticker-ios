//
//  inapp.swift
//  margin
//
//  Created by USER on 05/08/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import StoreKit

class StoreObserver: NSObject {
    
    var productIdentifier = "pro" //Get it from iTunes connect
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()

    
    //Initialize the store observer.
    override init() {
        super.init()
        print("bb")
        fetchAvailableProducts()
        //Other initialization here.
    }
    
    func fetchAvailableProducts() {
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            productIdentifier
        )
        guard let identifier = productIdentifiers as? Set<String> else { return }
        productsRequest = SKProductsRequest(productIdentifiers: identifier)
        productsRequest.delegate = self
        productsRequest.start()
        
    }
    

    /*
    // 상품 정보 요청 함수
    func getProductInfo(){
        print("cc")
        if SKPaymentQueue.canMakePayments() {
            // 애플에 상품 정보 요청, 요청이 완료되면 바로 아래 함수인 productsRequest함수가 자동 호출된다.
            let productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
            
            print("dd")
        }else{
            print("Enable In-app Billing in Settings")
            //userView?.show_dialog(title: "ERROR", str: "Enable In-app Billing in Settings")
        }
    }*/
    
    /*
    // 상품 정보 수신 관련 delegate함수
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("ee")
        var products = response.products
        // 상품 정보가 정상적으로 수신되었을 경우 화면에 상품 정보 갱신 및 구매 버튼 활성화 처리한다.
        if products.count != 0 {
            product = products[0] as SKProduct
            let payment = SKPayment(product: self.product!)
            SKPaymentQueue.default().add(payment)
        }else{
            print("Can not check product information registered in Apple account")
            //userView?.show_dialog(title: "ERROR", str: "Can not check product information registered in Apple account")
        }
        let productList = response.invalidProductIdentifiers
        for productItem in productList{
            print("Product not found : \(productItem)")
        }
    }
    */
    
    // 상품 구매가 완료되었을 경우 앱내 후처리(실제로는 구매번호, 구매일자등을 로컬에 저장해 둔다)
    func unlockFeature(){
        UserDefaults.standard.set(97970505, forKey: "world") // Save
        print("Success")
        //userView?.show_dialog(title: "Success", str: "")
    }
}

extension StoreObserver: SKProductsRequestDelegate , SKPaymentTransactionObserver{
    
    
    
    // 상품 구매를 위해 결제 요청후 자동으로 호출되는 delegate함수
    //Observe transaction updates.
    func paymentQueue(_ queue: SKPaymentQueue,updatedTransactions transactions: [SKPaymentTransaction]) {
        //Handle transaction states here.
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
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("dd")
        if response.products.count > 0 {
            iapProducts = response.products
            if iapProducts.count > 0 {
                let purchasingProduct = response.products[0] as SKProduct
                // Get its price from iTunes Connect
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = purchasingProduct.priceLocale
                //if let price = numberFormatter.string(from: purchasingProduct.price {
                    // Show "Go Pro for \(price) / year" in the Buy button
                    // and stop animating/loading the button
                //}
            }
            
        }
    }
    

}
