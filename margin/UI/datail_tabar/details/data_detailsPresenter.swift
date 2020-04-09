//
//  data_detailsPresenter.swift
//  margin
//
//  Created by USER on 30/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import SwiftSoup

protocol DetailView: NSObjectProtocol {
    
    func show_hud()
    func hide_hud()
    func reload_table()
    func set_theme()
    
}

class data_detailsPresenter{
    
    private var userView : DetailView?
    private var details = [[String]]()
    
    init(){
        
    }
    
    func attachView(_ view: DetailView){
        userView = view
        userView?.set_theme()
    }
    
    func detachView() {
        userView = nil
    }
    
    func get_details_api(){
        DispatchQueue.main.async {
            self.userView?.show_hud()
        }
        let url3 = URL(string: "https://www.bitmex.com/app/contract/" + sok.chart_symbol)
        let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            let text2 = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            
            do {
                let doc: Document = try SwiftSoup.parse(text2)
                for table in try doc.select("table"){
                    if(table.hasClass("table table-striped table-bordered")){
                        for tr in try table.select("tr"){
                            if(tr.hasClass("gridRow")){
                                let td = try tr.select("td")
                                let cell1 = try td[0].text()
                                let cell2 = try td[1].text()
                                self.details.append([cell1,cell2])
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.userView?.reload_table()
                    self.userView?.hide_hud()
                }
            } catch {}
            
        }
        taskk2.resume()
    }
    
    func make_dialog(cnt: Int){
        showAlert(userView as? UIViewController,details[cnt][0],details[cnt][1])
    }
    
    func get_details() -> [[String]]{
        return details
    }
    
}
