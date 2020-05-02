//
//  AlertManager.swift
//  TheNews
//
//  Created by Nisha Poddar on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    
    func showAlert(title: String, message: String,buttonTitle:String, action: @escaping()->(),controller: UIViewController) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { [weak self] _ in
            action()
        }
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
