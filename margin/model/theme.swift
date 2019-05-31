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
    
    case dark_navi
    case dark_table_out
    case dark_table_in
    case dark_title
    case dark_title2
    
    case light_navi
    case light_table_out
    case light_table_in
    case light_title
    case light_title2
    
}

extension UIColor{
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .dark_navi:
            return UIColor(red: 22/255, green: 38/255, blue: 63/255, alpha: 1)
        case .dark_table_out:
            return UIColor(red: 8/255, green: 23/255, blue: 35/255, alpha: 1)
        case .dark_table_in:
            return UIColor(red: 18/255, green: 31/255, blue: 48/255, alpha: 1)
        case .dark_title:
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        case .dark_title2:
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.38)
            
        case .light_navi:
            return UIColor(red: 69/255, green: 164/255, blue: 179/255, alpha: 1)
        case .light_table_out:
            return UIColor(red: 239/255, green: 239/255, blue: 243/255, alpha: 1)
        case .light_table_in:
            return UIColor(red: 255/255, green: 254/255, blue: 255/255, alpha: 1)
        case .light_title:
            return UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1)
        case .light_title2:
            return UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
        }
    }
}
