//
//  setting_.swift
//  margin
//
//  Created by USER on 14/02/2019.
//  Copyright © 2019 jungho. All rights reserved.
//
import UIKit
import Foundation

class setting_: UITableViewController {
    
    let userPresenter = setting_Presenter()
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var themeLabel: UILabel!
    @IBOutlet var themeSwitch_: UISwitch!
    
    @IBAction func themeSwitch(_ sender: Any) {
        userPresenter.change_theme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Setting"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 && indexPath.row == 0 {
            userPresenter.make_open_dialog()
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            userPresenter.make_version_dialog()
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            userPresenter.make_url()
        }
        
        if indexPath.section == 2 && indexPath.row == 1 {
            userPresenter.make_clipboard()
        }
        
        if indexPath.section == 2 && indexPath.row == 2 {
            userPresenter.fastFeedback()
        }
        
        if indexPath.section == 3 && indexPath.row == 0 {
            //userPresenter.make_inapp()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = UIColor.appColor(.title)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.appColor(.table_click)
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = UIColor.appColor(.table_in)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPresenter.attachView(self)
        
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

extension setting_: SettingView {
    
    func set_theme(){
        self.navigationController?.navigationBar.tintColor = .white
        tableview.backgroundColor = UIColor.appColor(.table_out)
        themeLabel.textColor = UIColor.appColor(.title)
        
        if(dark_theme){
            themeSwitch_.isOn = true
        }else{
            themeSwitch_.isOn = false
        }
        tableview.reloadData()
    }
    
    func open_url(str: String){
        UIApplication.shared.open(NSURL(string: str)! as URL)
    }
    
    func cpoy_clipboard(str: String){
        UIPasteboard.general.string = str
    }
    
}
