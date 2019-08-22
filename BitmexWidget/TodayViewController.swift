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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func setdataarr(){
        let result = getData("wholesymbol")
        if (result != ""){
            let get_table_data = result.split_("\n")
            //symbol.removeAll()
            for i in get_table_data{
                var dataa = i.split_(",")
                if(!symbol.contains([dataa[0],dataa[1],dataa[2],dataa[3],dataa[4],dataa[5],dataa[6]])){
                    symbol.append([dataa[0],dataa[1],dataa[2],dataa[3],dataa[4],dataa[5],dataa[6]])
                }
            }
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
            parse()
        }
    }
    
    @objc func parse(){
        let url = "https://www.bitmex.com/api/v1/trade/bucketed?binSize=1m&partial=true&count=200&reverse=true"
        requestHTTP(url: url,completion: { result in
            for (i,_) in symbol.enumerated(){
                let tmp = result.split_("\"symbol\":\"" + symbol[i][0] + "\"")[1].split_("}")[0].split_("\"close\":")[1].split_(",")[0]
                if (tmp.description != "null"){
                    symbol[i][4] = tmp
                }
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        })
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        setdataarr()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbol.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ticker", for: indexPath) as! ticker
        var info = symbol[indexPath.row]
        
        cell.symbol.text = info[0]
        cell.detail.text = info[3]
        if (info[4] == "n"){
            cell.price.setTitle("---", for: .normal)
        }else{
            cell.price.setTitle(info[4], for: .normal)
        }
        cell.price.layer.cornerRadius = 2
        cell.price.layer.masksToBounds = true
        cell.price.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.7) as UIColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url:NSURL? = NSURL(string: "BitmexTicker://")
        if let appurl = url{
            self.extensionContext!.open(appurl as URL, completionHandler: nil)
        }
    }
    
}
