//
//  findRG.swift
//  margin
//
//  Created by USER on 22/06/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit


func find_color(str:String) -> UIColor{
    if (str.contains("g")){
        return UIColor(red: 70/255, green: 170/255, blue: 70/255, alpha: 0.9) as UIColor
    }
    if (str.contains("r")){
        return UIColor(red: 200/255, green: 70/255, blue: 70/255, alpha: 0.9) as UIColor
    }
    return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.7) as UIColor
}
