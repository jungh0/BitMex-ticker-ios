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

class setting_: UITableViewController {
    
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
            let dialog = ZAlertView(title: "OpenSource", message: "SwiftWebSocket\nGoogle-Mobile-Ads-SDK\nZAlertView\nJGProgressHUD", closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
            })
            dialog.show()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            let dialog = ZAlertView(title: "Version", message: "1.3(4)", closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
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
}



