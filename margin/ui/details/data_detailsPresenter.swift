//
//  data_detailsPresenter.swift
//  margin
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation

protocol DetailView: NSObjectProtocol {
    
    func show_hud()
    func hide_hud()
    func reload_table()
    func show_dialog(str: [String])
}

class data_detailsPresenter{
    
    private var userView : DetailView?
    private var details = [[String]]()
    
    init(){

    }
    
    func attachView(_ view: DetailView){
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func get_details_api(){
        let url3 = URL(string: "https://www.bitmex.com/app/contract/" + sok.chart_symbol)
        let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let get_table = self.split(str: text2,w1: "<table class=\"table table-striped table-bordered\">",w2: "</table>")
            //print(get_table)
            var get_table_data = get_table.components(separatedBy: "<tr class=\"gridRow\">")
            for i in 1 ... get_table_data.count - 1 {
                var gridCell = get_table_data[i].components(separatedBy: "<td class=\"gridCell\">")
                
                var cell1 = gridCell[1].components(separatedBy: "</td>")[0]
                cell1 = cell1.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                var cell2 = gridCell[2].components(separatedBy: "</td>")[0]
                cell2 = cell2.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                self.details.append([cell1,cell2])
            }
            DispatchQueue.main.async {
                self.userView?.reload_table()
                self.userView?.hide_hud()
            }
        }
        taskk2.resume()
    }
    
    func split(str:String,w1:String,w2:String) -> String{
        return str.components(separatedBy: w1)[1].components(separatedBy: w2)[0]
    }
    
    func make_dialog(cnt: Int){
        userView?.show_dialog(str: details[cnt])
    }
    
    func get_details() -> [[String]]{
        return details
    }
    
}
