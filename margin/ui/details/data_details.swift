//
//  data_details.swift
//  margin
//
//  Created by USER on 24/02/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import ZAlertView
import JGProgressHUD

class data_details: UITableViewController {
    
    let userPresenter = data_detailsPresenter()
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet var tableview: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Details"
    }
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.get_details().count
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_detail", for: indexPath)
        let info = userPresenter.get_details()[indexPath.row]
        cell.textLabel?.text = info[0]
        cell.detailTextLabel?.text = info[1]
        
        cell.backgroundColor = UIColor.appColor(.table_in)
        cell.textLabel?.textColor = UIColor.appColor(.title)
        cell.detailTextLabel?.textColor = UIColor.appColor(.title2)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.appColor(.table_click)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    //테이블 클릭
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userPresenter.make_dialog(cnt:indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_theme()
        show_hud()
        
        userPresenter.attachView(self)
        userPresenter.get_details_api()
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func set_theme(){
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

extension data_details: DetailView {
    
    func show_hud(){
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
    }
    
    func hide_hud(){
        hud.dismiss(afterDelay: 0.0)
    }
    
    func reload_table(){
        self.tableView.reloadData()
    }
    
    func show_dialog(str: [String]){
        let dialog = ZAlertView(title: str[0], message: str[1], closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
        })
        dialog.show()
    }
    
}
