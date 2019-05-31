//
//  ticker_table.swift
//  margin
//
//  Created by User on 29/12/2018.
//  Copyright © 2018 jungho. All rights reserved.
//

import UIKit
import Foundation
import SwiftWebSocket
import GoogleMobileAds
import JGProgressHUD

class ticker_cell: UITableViewCell {
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var symbol2: UILabel!
    @IBOutlet var ticker2: UIButton!
}

class ticker_table: UITableViewController{
    
    let userPresenter = ticker_tablePresenter()
    var bannerView: GADBannerView!
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var recent: UILabel!
    
    @IBOutlet var table_view1: UIView!
    @IBOutlet var table_view1_1: UIView!
    @IBOutlet var table_view1_2: UIView!
    @IBOutlet var table_view2: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Ticker"
    }
    
    @objc func go_setting(_ button:UIBarButtonItem!){
        let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "setting_") as! setting_
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    @objc func change_theme(_ button:UIBarButtonItem!){
        if(dark_theme){
            dark_theme = false
            UserDefaults.standard.set(false, forKey: "theme")
        }else{
            dark_theme = true
            UserDefaults.standard.set(true, forKey: "theme")
        }
        set_theme()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_theme()
        show_hud()
        navibar_setting()

        userPresenter.attachView(self)
        userPresenter.timer_start()
        userPresenter.ad_check()
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.get_c_list().count
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ticker_cell", for: indexPath) as! ticker_cell
        var info = userPresenter.get_c_list()[indexPath.row]
        cell.symbol.text = info[0]
        cell.symbol2.text = info[3]
        
        cell.ticker2.setTitle(info[1], for: .normal)
        cell.ticker2.layer.cornerRadius = 2
        cell.ticker2.layer.masksToBounds = true
        cell.ticker2.backgroundColor = userPresenter.find_color(str: info[4])
        
        if (dark_theme){
            cell.backgroundColor = UIColor.appColor(.dark_table_in)
            cell.symbol.textColor = UIColor.appColor(.dark_title)
            cell.symbol2.textColor = UIColor.appColor(.dark_title2)
        }else{
            cell.backgroundColor = UIColor.appColor(.light_table_in)
            cell.symbol.textColor = UIColor.appColor(.light_title)
            cell.symbol2.textColor = UIColor.appColor(.light_title2)
        }
        return cell
    }
    
    //테이블 클릭
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userPresenter.set_chartsymbol(str: userPresenter.get_c_list()[indexPath.row][0])
        if (!userPresenter.get_c_list()[indexPath.row][1].contains("-")){
            let data_chart_ = self.storyboard?.instantiateViewController(withIdentifier: "data_tabbar") as! data_tabbar
            self.navigationController?.pushViewController(data_chart_, animated: true)
        }
    }
    
    //스크롤시 새로고침 잠금
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userPresenter.BeginDragging()
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        userPresenter.EndDragging()
    }
    
}

extension ticker_table: UserView {
    
    func show_hud(){
        if (!hud.isVisible){
            hud.textLabel.text = "Connecting"
            hud.show(in: self.view)
        }
    }
    
    func dissmiss_hud(){
        hud.dismiss(afterDelay: 0.0)
    }
    
    func recent_list(){
        DispatchQueue.main.async {
            let contentOffset = self.tableView.contentOffset
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.tableView.setContentOffset(contentOffset, animated: false)
        }
    }
    
    func recent_text(str: String){
        recent.text = str
    }
    
    func show_ad(){
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-0355430122346055/4509554445"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    //광고 위치
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,attribute: .bottom,relatedBy: .equal,toItem: bottomLayoutGuide,attribute: .top,multiplier: 1,constant: 0),
             NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: view,attribute: .centerX,multiplier: 1,constant: 0)
            ])
    }
    
    func navibar_setting(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let button2 = UIButton.init(type: .custom)
        button2.setImage(UIImage.init(named: "setting"), for: UIControl.State.normal)
        button2.addTarget(self, action:#selector(go_setting), for:.touchUpInside)
        button2.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton2 = UIBarButtonItem.init(customView: button2)
        self.navigationItem.rightBarButtonItem = barButton2
        
        let button3 = UIButton.init(type: .custom)
        button3.setImage(UIImage.init(named: "setting"), for: UIControl.State.normal)
        button3.addTarget(self, action:#selector(change_theme), for:.touchUpInside)
        button3.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton3 = UIBarButtonItem.init(customView: button3)
        self.navigationItem.leftBarButtonItem = barButton3
    }
    
    func set_theme(){
        if (dark_theme){
            navigationController?.navigationBar.barTintColor = UIColor.appColor(.dark_navi)
            tableview.backgroundColor = UIColor.appColor(.dark_table_out)
            table_view1.backgroundColor = UIColor.appColor(.dark_table_in)
            table_view1_1.backgroundColor = UIColor.appColor(.dark_table_out)
            table_view1_2.backgroundColor = UIColor.appColor(.dark_table_out)
            table_view2.backgroundColor = UIColor.appColor(.dark_table_out)
            recent.textColor = UIColor.appColor(.dark_title2)
        }else{
            navigationController?.navigationBar.barTintColor = UIColor.appColor(.light_navi)
            tableview.backgroundColor = UIColor.appColor(.light_table_out)
            table_view1.backgroundColor = UIColor.appColor(.light_table_in)
            table_view1_1.backgroundColor = UIColor.appColor(.light_table_out)
            table_view1_2.backgroundColor = UIColor.appColor(.light_table_out)
            table_view2.backgroundColor = UIColor.appColor(.light_table_out)
            recent.textColor = UIColor.appColor(.light_title2)
        }
    }

}

