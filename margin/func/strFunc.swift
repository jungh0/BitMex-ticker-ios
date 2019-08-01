//
//  strFunc.swift
//  GachonNoti
//
//  Created by USER on 24/06/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation

extension String {
    
    func replace(_ target: String, _ withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString,
                                         options: NSString.CompareOptions.literal, range: nil)
    }
    
    func split_(_ w:String) -> [String]{
        return self.components(separatedBy: w)
    }
    
}
