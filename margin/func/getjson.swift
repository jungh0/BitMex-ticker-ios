//
//  getjson.swift
//  margin
//
//  Created by USER on 29/07/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation

func getjson(json:String,str:String) -> String{
    let data_j = json.data(using: String.Encoding.utf8)
    do {
        if let data_j = data_j,
            let json = try JSONSerialization.jsonObject(with: data_j, options:[]) as? [String: AnyObject] {
            let last = json[str] as? String
            let tmp = last ?? "0"
            if (tmp != "0"){return tmp}
        } else {return ""}
    } catch {}
    return ""
}
