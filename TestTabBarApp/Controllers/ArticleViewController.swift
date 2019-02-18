//
//  ArticleViewController.swift
//  TestTabBarApp
//
//  Created by Sergey on 16/02/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate {
    
    var articleUrl: String?
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.isHidden = true
        progressView!.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.0, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        if let url = URL(string: articleUrl!) {
            webView.load(URLRequest(url: url))
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if Float(webView.estimatedProgress) == 1.0 {
            webView.isHidden = false
            progressView.isHidden = true
        } 
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
            progressView!.progress = Float(webView.estimatedProgress)
        }
    }

}
