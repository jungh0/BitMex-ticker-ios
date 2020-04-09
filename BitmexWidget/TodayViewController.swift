//
//  TodayViewController.swift
//  BitmexWidget
//
//  Created by USER on 21/08/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import UIKit
import NotificationCenter

class ticker: UITableViewCell {
    @IBOutlet var price: UIButton!
    @IBOutlet var detail: UILabel!
    @IBOutlet var symbol: UILabel!
}

var symbol: [[String]] = []

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate,UITableViewDataSource {
    
    var orp = false
    @IBOutlet var tap: UIButton!
    @IBAction func tap(_ sender: Any) {
        parse()
    }
    @IBOutlet weak var tableview: UITableView!
    var timer:Timer!
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
        }
        else {
            //expanded
            var heightt = 0
            //heightt = heightt + section_change2.count * 25
            for _ in symbol{
                heightt = heightt + 55
            }
            //print(heightt)
            heightt += 55
            self.preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(heightt))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("willapear")
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        setdataarr()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
    }
    
    
    func setdataarr(){
        checkPro()
        print("setdata")
        let result = getData("wholesymbol")
        print(result)
        if (result != ""){
            let get_table_data = result.split_("\n")
            if(symbol.count > 0){
                symbol.removeAll()
            }
            for i in get_table_data{
                let dataa = i.split_(",")
                symbol.append([dataa[0],dataa[1],dataa[2],dataa[3],"---",dataa[5],dataa[6]])
            }
            //print(symbol)
            parse()
        }
    }
    
    @objc func parse(){
        DispatchQueue.main.async {
            self.tap.setTitle("Loading...", for: .normal)
        }
        let url = "https://www.bitmex.com/api/v1/trade/bucketed?binSize=1m&partial=true&count=50&reverse=true"
        requestHTTP(url: url,completion: { result in
            //print(result)
            if(result == "ERROR"){
                DispatchQueue.main.async {
                    self.tap.setTitle("Lost Connection (Tap to refresh)", for: .normal)
                }
            }else{
                for (i,_) in symbol.enumerated(){
                    if(!self.orp){
                        symbol[i][4] = "PRO"
                    }else{
                        let tmp = result.split_("\"symbol\":\"" + symbol[i][0] + "\"")[1].split_("}")[0].split_("\"close\":")[1].split_(",")[0]
                        if (tmp.description != "null"){
                            symbol[i][4] = tmp
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.tap.setTitle("Tap here to refresh", for: .normal)
                }
            }
            
        })
    }
    
    func checkPro(){
        let pro = getData("orp")
        if(pro == "true"){
            orp = true
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.tableview.reloadData()
        completionHandler(NCUpdateResult.noData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbol.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ticker", for: indexPath) as! ticker
        let info = symbol[indexPath.row]
        
        cell.symbol.text = info[0]
        cell.detail.text = info[3]
        cell.price.setTitle(info[4], for: .normal)
        
        //        cell.price.layer.cornerRadius = 2
        //        cell.price.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableview.deselectRow(at: indexPath, animated: true)
        }
        let url:NSURL? = NSURL(string: "BitmexTicker://")
        if let appurl = url{
            self.extensionContext!.open(appurl as URL, completionHandler: nil)
        }
    }
    
}
