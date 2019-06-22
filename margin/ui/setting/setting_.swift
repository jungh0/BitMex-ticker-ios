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
    
    let userPresenter = setting_Presenter()
    
    @IBOutlet var tableview: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Setting"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 && indexPath.row == 0 {
            userPresenter.make_open_dialog()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            userPresenter.make_version_dialog()
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            userPresenter.make_url()
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            userPresenter.make_clipboard()
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            userPresenter.make_inapp()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.appColor(.table_in)
        cell.textLabel?.textColor = UIColor.appColor(.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_theme()
        userPresenter.attachView(self)
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func set_theme(){
        self.navigationController?.navigationBar.tintColor = .white
        tableview.backgroundColor = UIColor.appColor(.table_out)
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

extension setting_: SettingView {
    
    func show_dialog(title:String, str: String){
        let dialog = ZAlertView(title: title, message: str
            , closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
        })
        dialog.show()
    }
    
    func open_url(str: String){
        UIApplication.shared.open(NSURL(string: str)! as URL)
    }
    
    func cpoy_clipboard(str: String){
        UIPasteboard.general.string = str
    }
    
}
