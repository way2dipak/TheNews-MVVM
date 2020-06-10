//
//  NotificationViewController.swift
//  Content
//
//  Created by DS on 10/06/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    @IBOutlet weak var contentImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        let attachement =  notification.request.content.attachments
        for items in attachement {
            if items.identifier == "image" {
                print("image: \(items.url)")
                if let imgData = try? Data(contentsOf: items.url) {
                    contentImageView?.image = UIImage(data: imgData)
                }
            }
        }
    }

}
