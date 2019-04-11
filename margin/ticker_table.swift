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

var chart_symbol = "---"
var ws = WebSocket("wss://www.bitmex.com/realtime")
var list = [[String]]()
var orderbook = [[String]]()
var restart = 0
var recent_str = "---"
var recent_str_order = "---"

class ticker_table: UITableViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var recent: UILabel!
    var timer:Timer!
    var is_scroll = 0
    var bannerView: GADBannerView!
    
    //새로고침
    @objc func timerDidFire(){
        if (is_scroll == 0){
            DispatchQueue.main.async {
                let contentOffset = self.tableView.contentOffset
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.tableView.setContentOffset(contentOffset, animated: false)
            }
            
        }
        
        recent.text = recent_str
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Ticker"
    }
    
    @objc func go_setting(_ button:UIBarButtonItem!){
        let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "setting_") as! setting_
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let button2 = UIButton.init(type: .custom)
        button2.setImage(UIImage.init(named: "setting"), for: UIControl.State.normal)
        button2.addTarget(self, action:#selector(go_setting), for:.touchUpInside)
        button2.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton2 = UIBarButtonItem.init(customView: button2)
        self.navigationItem.rightBarButtonItem = barButton2
        
        
        
        let url3 = URL(string: "https://raw.githubusercontent.com/iveinvalue/BitMex-ticker-ios/master/symbol")
        let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            var get_table_data = text2.components(separatedBy: "\n")
            for i in 0 ... get_table_data.count - 2 {
                var dataa = get_table_data[i].components(separatedBy: ",")
                list.append([dataa[0],dataa[1],dataa[2],dataa[3],dataa[4],dataa[5]])
            }
            
            DispatchQueue.main.async {
                ws_()
            }
        }
        taskk2.resume()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        if(timer != nil){timer.invalidate()}
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(data_chart.timerDidFire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        let loadedData = UserDefaults.standard.value(forKey: "world")
        var letsgo = 0
        
        if (loadedData != nil){
            let loadedData2 = loadedData as! Int
            if (loadedData2 == 97970505){
                letsgo = 1
                print("thank you")
            }
        }
        
        if (letsgo == 0){
            bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            addBannerViewToView(bannerView)
            
            bannerView.adUnitID = "ca-app-pub-0355430122346055/4509554445"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
    
        
        
    }
  
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ticker_cell", for: indexPath) as! ticker_cell
        cell.symbol.text = list[indexPath.row][0]
        cell.ticker.text = list[indexPath.row][1]
        cell.symbol2.text = list[indexPath.row][3]
        if (list[indexPath.row][4].contains("g")){
            cell.ticker.textColor = UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 1) as UIColor
        }
        if (list[indexPath.row][4].contains("r")){
            cell.ticker.textColor = UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 1) as UIColor
        }
        if (list[indexPath.row][4].contains("n")){
            cell.ticker.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1) as UIColor
        }
        let customBGColorView = UIView()
        customBGColorView.backgroundColor = UIColor(red: 8/255, green: 23/255, blue: 35/255, alpha: 1) as UIColor
        cell.selectedBackgroundView = customBGColorView
        return cell
    }
    
    //테이블 클릭
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chart_symbol = list[indexPath.row][0]
        if (!list[indexPath.row][1].contains("-")){
            let data_chart_ = self.storyboard?.instantiateViewController(withIdentifier: "data_tabbar") as! data_tabbar
            self.navigationController?.pushViewController(data_chart_, animated: true)
        }
        
    }
    
    //스크롤시 새로고침 잠금
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        is_scroll = 1
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        is_scroll = 1
        let time = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.is_scroll = 0
            //self.tableview.reloadData()
        }
    }
    
    //광고 위치
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}

class ticker_cell: UITableViewCell {
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var symbol2: UILabel!
}

