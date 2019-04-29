//
//  setting_.swift
//  margin
//
//  Created by USER on 14/02/2019.
//  Copyright © 2019 jungho. All rights reserved.
//


import UIKit
import Foundation
import ZAlertView
import StoreKit

class setting_: UITableViewController,SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    var product:SKProduct?
    var productID = "remove_ad"   // iTunesConnect에서 생성한 IAP결제 Free용 제품에 대한 식별자
    
    @IBOutlet var tableview: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewWillAppear(_ animated: Bool){
        self.title = "Setting"
        //self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("section: \(indexPath.section) row: \(indexPath.row)")
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let dialog = ZAlertView(title: "OpenSource", message: "SwiftWebSocket\n(https://github.com/tidwall/SwiftWebSocket)\nMIT License.\n\n" +
                "ZAlertView\n(https://github.com/zelic91/ZAlertView)\nMIT license.\n\n" +
                "JGProgressHUD\n(https://github.com/JonasGessner/JGProgressHUD)\n©2014-2018, Jonas Gessner.\nMIT License."
                , closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
            })
            dialog.show()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let dialog = ZAlertView(title: "Version", message: "1.4(5)", closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
            })
            dialog.show()
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            UIApplication.shared.open(NSURL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id1450104461?mt=8")! as URL)
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            UIPasteboard.general.string = "iveinvalue@gmail.com"
            let dialog = ZAlertView(title: "iveinvalue@gmail.com", message: "Copied email", closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
            })
            dialog.show()
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            SKPaymentQueue.default().add(self)
            getProductInfo()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    
    
    // 상품 정보 요청 함수
    func getProductInfo(){
        if SKPaymentQueue.canMakePayments() {
            // 애플에 상품 정보 요청, 요청이 완료되면 바로 아래 함수인 productsRequest함수가 자동 호출된다.
            let request = SKProductsRequest(productIdentifiers: NSSet(object: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        }else{
            let dialog = ZAlertView(title: "ERROR", message: "Enable In-app Billing in Settings", closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
            })
            dialog.show()
            //productDescription.text = "설정에서 인앱결제를 활성화주세요"
        }
    }
    
    // 상품 정보 수신 관련 delegate함수
    func productsRequest(_ request: SKProductsRequest, didReceive response:SKProductsResponse){
        
        var products = response.products
        // 상품 정보가 정상적으로 수신되었을 경우 화면에 상품 정보 갱신 및 구매 버튼 활성화 처리한다.
        if products.count != 0 {
            product = products[0] as SKProduct
            //purchase.enabled = true
            //productTitle.text = product!.localizedTitle
            //productDescription.text = product!.localizedDescription
            
            
            let dialog = ZAlertView(title: product!.localizedTitle, message: product!.localizedDescription, closeButtonText: "Purchase", closeButtonHandler: {
                alertView in alertView.dismissAlertView()
                let payment = SKPayment(product: self.product!)
                SKPaymentQueue.default().add(payment)
                
            })
            dialog.show()
            
        }else{
            let dialog = ZAlertView(title: "ERROR", message: "Can not check product information registered in Apple account", closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
            })
            dialog.show()
            //productTitle.text = "애플계정에 등록된 상품정보 확인불가"
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
        
        let dialog = ZAlertView(title: "Success", message: "", closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
        })
        dialog.show()
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.inputViewController!.enableScreenButton()
        //purchase.enabled = false
        //productTitle.text = "상품 구매 완료되었습니다."
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

}



