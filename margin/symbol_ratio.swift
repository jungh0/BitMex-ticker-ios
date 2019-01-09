//
//  symbol_ratio.swift
//  margin
//
//  Created by User on 30/12/2018.
//  Copyright © 2018 jungho. All rights reserved.
//

import UIKit
import Foundation
import SwiftWebSocket


class symbol_ratio: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {

        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("asd")
        let msg = "{\"op\": \"subscribe\", \"args\": [\"funding:XBTUSD\"]}"
        //print("send: \(msg)")
        ws.send(msg)
        //tableview.dataSource = self
        //tableview.delegate = self
    }
    
    //섹션 별 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    
    
    
}


class ratio_cell: UITableViewCell {

}
