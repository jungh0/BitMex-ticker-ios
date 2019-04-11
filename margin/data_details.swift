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
    
    var details = [[String]]()
    @IBOutlet var tableview: UITableView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    override func viewWillAppear(_ animated: Bool){
        self.title = "Details"
        //self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    //테이블 데이터 로드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_detail", for: indexPath)
        cell.textLabel?.text = details[indexPath.row][0]
        cell.detailTextLabel?.text = details[indexPath.row][1]
        //cell.selectionStyle = .gray
        let customBGColorView = UIView()
        customBGColorView.backgroundColor = UIColor(red: 8/255, green: 23/255, blue: 35/255, alpha: 1) as UIColor
        cell.selectedBackgroundView = customBGColorView
        return cell
    }
    
    //테이블 클릭
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dialog = ZAlertView(title: details[indexPath.row][0], message: details[indexPath.row][1], closeButtonText: "OK", closeButtonHandler: { alertView in alertView.dismissAlertView()
        })
        dialog.show()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        let url3 = URL(string: "https://www.bitmex.com/app/contract/" + chart_symbol)
        let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let get_table = split(str: text2,w1: "<table class=\"table table-striped table-bordered\">",w2: "</table>")
            //print(get_table)
            var get_table_data = get_table.components(separatedBy: "<tr class=\"gridRow\">")
            for i in 1 ... get_table_data.count - 1 {
                var gridCell = get_table_data[i].components(separatedBy: "<td class=\"gridCell\">")

                var cell1 = gridCell[1].components(separatedBy: "</td>")[0]
                cell1 = cell1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                var cell2 = gridCell[2].components(separatedBy: "</td>")[0]
                cell2 = cell2.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                self.details.append([cell1,cell2])
                //https://www.bitstamp.net/api/v2/ticker/xrpbtc/
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                hud.dismiss(afterDelay: 0.0)
            }
        }
        taskk2.resume()

        
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



