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
    let customBGColorView = UIView()
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
        cell.selectedBackgroundView = customBGColorView
        return cell
    }
    
    //테이블 클릭
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userPresenter.make_dialog(cnt:indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show_hud()
        
        userPresenter.attachView(self)
        userPresenter.get_details_api()
        customBGColorView.backgroundColor = UIColor(red: 8/255, green: 23/255, blue: 35/255, alpha: 1) as UIColor
        
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
