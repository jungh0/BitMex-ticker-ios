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
        if (self.contains(w)){
            return self.components(separatedBy: w)
        }else{
            return ["null","null"]
        }
    }
    
    var isNumber: Bool {
        return NumberFormatter().number(from: self) != nil
    }
    
}

extension Double {
    
    func toString(decimal: Int = 9) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)
        
        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
}

extension Int {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    var delimiter: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

