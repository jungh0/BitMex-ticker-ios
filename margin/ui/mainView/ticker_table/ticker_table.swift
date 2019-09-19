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

import Firebase

class ticker_cell: UITableViewCell {
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var symbol2: UILabel!
    @IBOutlet var ticker2: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let separator = UIView()
//        separator.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height - 1,
//                                 width: self.frame.size.width, height: 2)
//        separator.backgroundColor = UIColor.appColor(.table_out)
//        separator.tintColor = UIColor.appColor(.table_out)
//        self.addSubview(separator)
    }
}

class ticker_table: UITableViewController{
    
    let randNum = arc4random_uniform(10000).description
    
    
    var beforeTheme = dark_theme
    let userPresenter = ticker_tablePresenter()
    var bannerView: GADBannerView!
    
    @IBOutlet var symbol: UILabel!
    @IBOutlet var price: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var table_view_top: UIView!
    @IBOutlet var table_view_symbol_price: UIView!
    @IBOutlet var table_view_bottom: UIView!
    
    @IBOutlet var marketcap_table: UIView!
    @IBOutlet var marketcap_label: UILabel!
    @IBOutlet var domin_table: UIView!
    @IBOutlet var domin_label: UILabel!
    @IBOutlet var market_data: UILabel!
    @IBOutlet var domin_data: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Ticker"
        userPresenter.updateList()
    }
    
    @objc func go_setting(_ button:UIBarButtonItem!){
        let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "setting_") as! setting_
        ViewController.iapUserview = self
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinlist()
        userPresenter.attachView(self)
        userPresenter.updateList()
        
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
        sok.chart_symbol = userPresenter.get_c_list()[indexPath.row][0]
        let containtmp = userPresenter.get_c_list()[indexPath.row][1]
        if (!containtmp.contains("-") && !containtmp.contains("ERROR")){
            let data_chart_ = self.storyboard?.instantiateViewController(withIdentifier: "datail_tabar") as! datail_tabar
            self.navigationController?.pushViewController(data_chart_, animated: true)
        }
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //스크롤시 새로고침 잠금
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userPresenter.BeginDragging()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        userPresenter.EndDragging()
    }
    
    func set_ad(){
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-0355430122346055/4509554445"
        bannerView.rootViewController = self
    }
    
    func show_ad(){
        bannerView.load(GADRequest())
    }
    
    func hide_ad(){
        bannerView.removeFromSuperview()
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
    
    func setTopset(){
        let topset = UIButton.init(type: .custom)
        topset.setImage(UIImage.init(named: "setting"), for: UIControl.State.normal)
        topset.addTarget(self, action:#selector(go_setting), for:.touchUpInside)
        topset.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: topset)
    }
    
    @objc func goPro(sender: UIBarButtonItem) {
        let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "iap") as! iap
        ViewController.userView = self
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    private func coinlist(){
        let url = "http://wiffy.io/bitmex/info?" + randNum
        
        let tmpsymbol = getDataShare("wholesymbol")
        if (tmpsymbol != ""){
            let get_table_data = tmpsymbol.split_("\n")
            for i in get_table_data{
                var dataa = i.split_(",")
                sok.c_list_append(list: [dataa[0],dataa[1],dataa[2],dataa[3],dataa[4],dataa[5],dataa[6]])
            }
            DispatchQueue.main.async {
                sok.start()
            }
        }
        
        requestHTTP(url: url,completion: { result in
            //print("==" + result)
            if(result != ""){
                let notice = result.split_("<notice>")[1].split_("</notice>")[0]
                let symbol = result.split_("<symbol>")[1].split_("</symbol>")[0]
                let beta = result.split_("<beta>")[1].split_("</beta>")[0]
                
                if(notice != ""){
                    DispatchQueue.main.async {
                        //showAlert(self, "-NOTICE-",notice)
                    }
                }
                
                if(symbol != ""){
                    if let userDefaults = UserDefaults(suiteName: "group.margin.symbol") {
                        userDefaults.set(symbol, forKey: "wholesymbol")
                        if(tmpsymbol == ""){
                            let tmpsymbol2 = getDataShare("wholesymbol")
                            print(tmpsymbol2)
                            if (tmpsymbol2 != ""){
                                let get_table_data = tmpsymbol2.split_("\n")
                                for i in get_table_data{
                                    var dataa = i.split_(",")
                                    sok.c_list_append(list: [dataa[0],dataa[1],dataa[2],dataa[3],dataa[4],dataa[5],dataa[6]])
                                }
                                DispatchQueue.main.async {
                                    sok.start()
                                }
                            }
                        }
                    }
                }
                
                if(beta != ""){
                    if (beta.contains("3648242349iapp")){
                        closeiap = true
                    }
                }
            }
            
            receiptValidation2(vv: self)
            
            
        })
    }

}

extension ticker_table: UserView {

    func recent_list(){
        DispatchQueue.main.async {
            let contentOffset = self.tableView.contentOffset
            //self.tableView.beginUpdates()
            self.tableView.reloadData()
            //self.tableView.endUpdates()
            self.tableView.layer.removeAllAnimations()
            //self.tableView.layoutIfNeeded()
            //self.tableView.contentOffset = CGPointMake(0, currentOffset);
            self.tableView.setContentOffset(contentOffset, animated: false)
            if (self.beforeTheme != dark_theme){
                self.beforeTheme = dark_theme
                self.set_theme()
            }
        }
    }
    
    func set_theme(){
        setTopset()
        self.tableView.separatorColor = UIColor.appColor(.table_out)
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = UIColor.appColor(.table_out)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navi)
        tableview.backgroundColor = UIColor.appColor(.table_out)
        table_view_top.backgroundColor = UIColor.appColor(.table_out)
        table_view_symbol_price.backgroundColor = UIColor.appColor(.table_in)
        table_view_bottom.backgroundColor = UIColor.appColor(.table_out)
        
        marketcap_table.backgroundColor = UIColor.appColor(.table_in)
        domin_table.backgroundColor = UIColor.appColor(.table_in)
        marketcap_label.textColor = UIColor.appColor(.title)
        domin_label.textColor = UIColor.appColor(.title)
        market_data.textColor = UIColor.appColor(.title2)
        domin_data.textColor = UIColor.appColor(.title2)
    }
    
    func info_change(cap:String,domin:String){
        market_data.text = cap
        domin_data.text = domin
    }
    
    func setTopBtn(){
        DispatchQueue.main.async {
            if(!beta){
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "PRO UPGRADE", style: .plain, target: self, action: #selector(self.goPro))
                self.show_ad()
            }else{
                self.navigationItem.leftBarButtonItem = nil
                self.hide_ad()
            }
            if(closeiap){
                if let userDefaults = UserDefaults(suiteName: "group.margin.symbol") {
                    userDefaults.set("true", forKey: "orp")
                }
                self.navigationItem.leftBarButtonItem = nil
                self.hide_ad()
                beta = true
                if let userDefaults = UserDefaults(suiteName: "group.margin.symbol") {
                    userDefaults.set("true", forKey: "orp")
                }
            }
        }
    }
}
