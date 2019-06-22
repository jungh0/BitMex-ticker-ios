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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let separator = UIView()
        separator.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height - 1,
                                 width: self.frame.size.width, height: 1)
        separator.backgroundColor = UIColor.appColor(.table_out)
        self.addSubview(separator)
    }
}

class ticker_table: UITableViewController{
    
    let userPresenter = ticker_tablePresenter()
    var bannerView: GADBannerView!
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet var symbol: UILabel!
    @IBOutlet var price: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var table_view1: UIView!
    @IBOutlet var table_view1_1: UIView!
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
        userPresenter.change_theme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navibar_setting()
        userPresenter.attachView(self)
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
        cell.symbol.textColor = UIColor.appColor(.title)
        
        cell.symbol2.text = info[3]
        cell.symbol2.textColor = UIColor.appColor(.title2)
        
        cell.ticker2.setTitle(info[1], for: .normal)
        cell.ticker2.layer.cornerRadius = 2
        cell.ticker2.layer.masksToBounds = true
        cell.ticker2.backgroundColor = find_color(str: info[4])
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.appColor(.table_click)
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = UIColor.appColor(.table_in)
        
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
        setTopset()
        setTopBtn()
    }
    
    func setTopset(){
        let topset = UIButton.init(type: .custom)
        topset.setImage(UIImage.init(named: "setting"), for: UIControl.State.normal)
        topset.addTarget(self, action:#selector(go_setting), for:.touchUpInside)
        topset.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: topset)
    }
    
    func setTopBtn(){
        let topBtn = UIButton.init(type: .custom)
        topBtn.addTarget(self, action:#selector(change_theme), for:.touchUpInside)
        topBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        topBtn.setImage(UIImage.appImg(.topImg), for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: topBtn)
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
        //recent.text = str
    }
    
    func reloadTable(){
        self.tableView.reloadData()
    }
    
    func set_theme(){
        setTopBtn()
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navi)
        tableview.backgroundColor = UIColor.appColor(.table_out)
        table_view1.backgroundColor = UIColor.appColor(.navi)
        table_view1_1.backgroundColor = UIColor.appColor(.table_in)
        table_view2.backgroundColor = UIColor.appColor(.table_out)
        symbol.textColor = UIColor.appColor(.title2)
        price.textColor = UIColor.appColor(.title2)
    }
    
}
