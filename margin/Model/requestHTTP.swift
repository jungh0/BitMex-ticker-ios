//
//  requestHTTP.swift
//  margin
//
//  Created by USER on 22/06/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation

func requestHTTP(url:String, completion: @escaping (String)->()){
    let url3 = URL(string: url)
    let taskk2 = URLSession.shared.dataTask(with: url3! as URL) { data, response, error in
        guard let data = data, error == nil else {
            completion("")
            return
        }
        let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        completion(result)
    }
    taskk2.resume()
}

//let parameters: [String: Any] = [
//    "id": 13,
//    "name": "Jack & Jill"
//]
func requestHTTPPost(urll:String,data:[String: Any],  completion: @escaping (String)->()){
    let url = URL(string: urll)!
    var request = URLRequest(url: url)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    request.httpBody = data.percentEncoded()
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            //            print("error", error ?? "Unknown error")
            completion("")
            return
        }
        
        guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
            //            print("statusCode should be 2xx, but is \(response.statusCode)")
            //            print("response = \(response)")
            completion("")
            return
        }
        
        let responseString = String(data: data, encoding: .utf8)
        completion(responseString ?? "");
    }
    
    task.resume()
}
