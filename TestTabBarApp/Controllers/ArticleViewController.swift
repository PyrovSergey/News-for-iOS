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
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        if let url = URL(string: articleUrl!) {
            webView.load(URLRequest(url: url))
            //webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            webView.allowsBackForwardNavigationGestures = true
        }
        
        
//        progressView = UIProgressView(progressViewStyle: .bar)
//        progressView.center = self.view.center
//        //progressView.frame = CGRectMake(0,0,50,20)
//        progressView.translatesAutoresizingMaskIntoConstraints = false
//        progressView.setProgress(0.5, animated: false)
//        self.view.addSubview(progressView)

        // Do any additional setup after loading the view.
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "estimatedProgress" {
//            print(Float(newsWebView.estimatedProgress))
//            progressView.progress = Float(newsWebView.estimatedProgress)
//        }
//    }

}
