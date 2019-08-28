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
import JGProgressHUD

class iap: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let hud = JGProgressHUD(style: .dark)
    var userView : UserView?
    
    @IBAction func term(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "http://wiffy.io/bitmex/PRIVACY-POLICY.txt")! as URL)
    }
    @IBAction func restore(_ sender: Any) {
        show_hud(self.view)
        fetchAvailableProducts()
    }
    @IBOutlet var gopro: UIButton!
    @IBAction func gopro_(_ sender: Any) {
        show_hud(self.view)
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
    
    func show_hud(_ hudview:UIView){
        if (!hud.isVisible){
            hud.textLabel.text = "Payment\nLoading"
            hud.show(in: hudview)
        }
    }
    func dissmiss_hud(){
        hud.dismiss(afterDelay: 0.0)
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
        if SKPaymentQueue.canMakePayments(){
            print("Sending the Payment Request to Apple")
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
        }
        else{
            print("cant purchase")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("===Success")
                    UserDefaults.standard.setValue(productID, forKey: "currentSubscription")
                    receiptValidation(vv: userView!)
                    dissmiss_hud()
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("===Fail")
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    dissmiss_hud()
                    break
                case .restored:
                    print("===restored")
                    receiptValidation(vv: userView!)
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    dissmiss_hud()
                    break
                case .purchasing:
                    show_hud(self.view)
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

