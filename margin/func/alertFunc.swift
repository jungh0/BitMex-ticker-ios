//
//  alertFunc.swift
//  margin
//
//  Created by USER on 03/08/2019.
//  Copyright © 2019 jungho. All rights reserved.
//

import Foundation
import UIKit

func selectAlert(_ viewController: UIViewController?,_ title: String, _ msg: String, _ buttonTitle: String, _ handler: ((UIAlertAction) -> Swift.Void)?){
    
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
    alertController.addAction(defaultAction)
    
    let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
    alertController.addAction(cancel)
    
    viewController?.present(alertController, animated: true, completion: nil)
}

func showAlert(_ viewController: UIViewController?, _ title: String, _ msg: String){
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
    alertController.addAction(cancel)
    viewController?.present(alertController, animated: true, completion: nil)
}
