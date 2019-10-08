//
//  hud.swift
//  margin
//
//  Created by USER on 09/10/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import JGProgressHUD

let hud = JGProgressHUD(style: .dark)
var hudText = ""

func show_hud(_ hudview:UIView, _ str:String){
    if (!hud.isVisible){
        hudText = str
        hud.textLabel.text = str
        hud.show(in: hudview)
    }
}
func dissmiss_hud(){
    hud.dismiss(afterDelay: 0.0)
}
