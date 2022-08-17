//
//  NotificationViewController.swift
//  NotificationService
//
//  Created by ohisea on 2022/08/17.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import WebKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var webVIewHeightConstraints: NSLayoutConstraint!
    
    enum Constans {
        static let webViewHeight: CGFloat = 100
        static let pushKey: String = "CustomSamplePush"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWebView()
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        guard let userInfo = content.userInfo as? [String: AnyObject] else { return }
        guard let data = userInfo["data"] as? [String: AnyObject] else { return }
        guard let bannerUrlString = data["bannerUrl"] as? String else { return }
        guard let bannerUrl = URL(string: bannerUrlString) else { return }
        guard Constans.pushKey == content.categoryIdentifier else { return }
        
        self.label?.text = {
            "11 \($0) \($1) \($2)"
        }(content.title, bannerUrlString, content.body)
        
        self.webView.load(URLRequest(url: bannerUrl))
    }
}

extension NotificationViewController {
    private func setupWebView() {
        self.webView.navigationDelegate = self
        self.webView.configuration.allowsInlineMediaPlayback = true
    }
    
    private func setupContentsHeight() {
        let height: CGFloat = {
            $1 / $0.width * $0.height
        }(self.webView.scrollView.contentSize, self.view.bounds.width)
        
        self.webVIewHeightConstraints.constant = height
    }
}

extension NotificationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.setupContentsHeight()
        })
    }
}
