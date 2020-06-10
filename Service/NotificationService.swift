//
//  NotificationService.swift
//  Service
//
//  Created by DS on 10/06/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
  
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        print("bestAttemptContent: \(request)")
        guard let bestAttemptContent = bestAttemptContent,
            let attachmentUrlAsString = bestAttemptContent.userInfo["url"] as? String,
            let attachmentUrl = URL(string: attachmentUrlAsString) else  { return }
        // Modify the notification content here...
        bestAttemptContent.title = "\(bestAttemptContent.title)"
        downloadImage(form: attachmentUrl) { (attachment) in
            if let item = attachment {
                bestAttemptContent.attachments = [item]
                contentHandler(bestAttemptContent)
            }
        }
        
    }
    
    private func downloadImage(form url: URL, with completionHandler: @escaping(UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (downlaodedUrl, response, error) in
            if downlaodedUrl == nil {
                completionHandler(nil)
            }
            else {
                var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
                let uniqueUrlEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
                urlPath = urlPath.appendingPathComponent(uniqueUrlEnding)
                
                try? FileManager.default.moveItem(at: downlaodedUrl!, to: urlPath)
                
                do {
                    let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                    completionHandler(attachment)
                }
                catch {
                    completionHandler(nil)
                }
            }
        }
        task.resume()
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
