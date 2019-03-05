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
    @IBOutlet weak var progressLabel: UILabel!
    
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
            progressLabel.isHidden = true
        } 
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
            let progress = Float(webView.estimatedProgress)
            let result = (progress * 100.0)
            progressLabel.text = String("\(Int(result))%")
            progressView!.progress = Float(webView.estimatedProgress)
        }
    }
    @IBAction func clickButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickOptions(_ sender: UIBarButtonItem) {
        print("clickOptions")
        let url = NSURL(string: articleUrl!)!
        let items = [url]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
