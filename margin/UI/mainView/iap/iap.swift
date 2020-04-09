//
//  setting_.swift
//  margin
//
//  Created by USER on 14/02/2019.
//  Copyright © 2019 jungho. All rights reserved.
//
import UIKit
import Foundation
import StoreKit

class iap: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var userView : UserView?
    var purchase = true
    
    @IBAction func term(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "http://wiffy.io/bitmex/PRIVACY-POLICY.txt")! as URL)
    }
    @IBAction func restore(_ sender: Any) {
        show_hud(self.view,"Payment\nLoading")
        purchase = false
        fetchAvailableProducts()
        
    }
    @IBOutlet var gopro: UIButton!
    @IBAction func gopro_(_ sender: Any) {
        show_hud(self.view,"Payment\nLoading")
        purchase = true
        fetchAvailableProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initt()
    }
    
    func initt(){
        gopro.setTitle("$4.99 / Month", for: .normal)
        gopro.layer.cornerRadius = 5
        gopro.layer.masksToBounds = true
        
    }
    
    
    //iappppppppppppppppp
    
    var productIdentifier = "subpro" //Get it from iTunes connect
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    func fetchAvailableProducts(){
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:"subpro")
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            for prod in response.products{
                //print("====aaaaaaaa")
                buyProduct(prod)
            }
        }
    }
    
    func buyProduct(_ product: SKProduct)
    {
        // Add the StoreKit Payment Queue for ServerSide
        SKPaymentQueue.default().add(self)
        
        if(purchase){
            if SKPaymentQueue.canMakePayments(){
                print("Sending the Payment Request to Apple")
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
                productID = product.productIdentifier
            }
            else{
                print("cant purchase")
            }
        }else{
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("===restored")
        //dissmiss_hud()
        //show_hud(self.view,"Restoring\nPurchase")
        receiptValidation(vv: userView!)
        //SKPaymentQueue.default().restoreCompletedTransactions()
        //dissmiss_hud()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("===Success")
                    UserDefaults.standard.setValue(productID, forKey: "currentSubscription")
                    //dissmiss_hud()
                    
                    //show_hud(self.view,"Restoring\nPurchase")
                    receiptValidation(vv: userView!)
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("===Fail")
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    dissmiss_hud()
                    break
                case .restored:
                    print("===restored")
                    //dissmiss_hud()
                    
                    //show_hud(self.view,"Restoring\nPurchase")
                    receiptValidation(vv: userView!)
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    break
                case .purchasing:
                    show_hud(self.view,"Payment\nLoading")
                    break
                default:
                    print("===unkown")
                    dissmiss_hud()
                    break
                }
            }
        }
    }
    
    
    
    //iappppppppppppppppp
}

