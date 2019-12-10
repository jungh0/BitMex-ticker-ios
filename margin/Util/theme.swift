//
//  theme.swift
//  margin
//
//  Created by USER on 31/05/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit

enum AssetsColor {
    
    case navi
    case table_out
    case table_in
    case title
    case title2
    case table_click
    case border
    case detail_table_in
    case textfield_in
    
    
}

extension UIColor{
    static func appColor(_ name: AssetsColor) -> UIColor? {
        if(dark_theme){
            switch name {
            case .navi:
                return UIColor(red: 22/255, green: 38/255, blue: 63/255, alpha: 1)
            case .table_out:
                return UIColor(red: 8/255, green: 23/255, blue: 35/255, alpha: 1)
            case .table_in:
                return UIColor(red: 18/255, green: 31/255, blue: 48/255, alpha: 1)
            case .title:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            case .title2:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.38)
            case .table_click:
                return UIColor(red: 255/255, green: 254/255, blue: 255/255, alpha: 0.1)
            case .border:
                return UIColor(red:54/255, green:60/255, blue:77/255, alpha: 1)
            case .detail_table_in:
                return UIColor(red: 19/255, green: 24/255, blue: 36/255, alpha: 1)
            case .textfield_in:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.05)
            }
        }
        else{
            switch name {
            case .navi:
                return UIColor(red: 22/255, green: 38/255, blue: 63/255, alpha: 1)
            //return UIColor(red: 69/255, green: 164/255, blue: 179/255, alpha: 1)
            case .table_out:
                return UIColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1)
            case .table_in:
                return UIColor(red: 255/255, green: 254/255, blue: 255/255, alpha: 1)
            case .title:
                return UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1)
            case .title2:
                return UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
            case .table_click:
                return UIColor(red: 18/255, green: 31/255, blue: 48/255, alpha: 0.1)
            case .border:
                return UIColor(red:220/255, green:220/255, blue:220/255, alpha: 1)
            case .detail_table_in:
                return .white
            case .textfield_in:
                return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.05)
            }
        }
    }
}

enum AssetsImg {
    
    case topImg
    
}

extension UIImage{
    static func appImg(_ name: AssetsImg) -> UIImage? {
        if(dark_theme){
            switch name {
            case .topImg:
                return UIImage.init(named: "noon")
            }
        }
        else{
            switch name {
            case .topImg:
                return UIImage.init(named: "night")
            }
        }
    }
}
