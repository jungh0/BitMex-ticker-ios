//
//  dataSave.swift
//  margin
//
//  Created by USER on 29/07/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation

func setData(_ name:String , _ value:Any){
    if (value is String){
        UserDefaults.standard.set(value as! String, forKey: name)
    }
    if (value is Int){
        UserDefaults.standard.set(value as! Int, forKey: name)
    }
}

func getData(_ name:String ) -> String{
    let tmp = UserDefaults.standard.value(forKey: name)
    if (tmp == nil){
        return ""
    }else{
        if (tmp is String){
            return tmp as! String
        }
        if (tmp is Int){
            return (tmp as! Int).description
        }else{
            return ""
        }
    }
}

func getDataShare(_ name:String ) -> String{
    if let userDefaults = UserDefaults(suiteName: "group.margin.symbol") {
        let value1 = userDefaults.string(forKey: name)
        if(value1 != nil){
            return value1!
        }else{
            return ""
        }
    }else{
        return ""
    }
}

