//
//  FirstViewController.swift
//  TestTabBarApp
//
//  Created by Sergey on 15/02/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class NewsTableViewController: UITableViewController {
    
    @IBOutlet var newsTableView: UITableView!
    
    private let baseUrl: String = "https://newsapi.org/v2/top-headlines"
    private let apiKey: String = "1d48cf2bd8034be59054969db665e62e"
    private let pageSize: String = "100"
    private var newsArray = [Article]()
    let spiner = UIActivityIndicatorView(style: .gray)
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        newsTableView.separatorStyle = .none
        spiner.startAnimating()
        newsTableView.backgroundView = spiner
        getTopHeadLinesNews()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! CustomNewsCell
        let currentArticle = newsArray[indexPath.row]
        cell.sourceLabel.text = currentArticle.sourceTitle
        cell.sourceImage.sd_setImage(with: URL(string: currentArticle.sourceImageUrl), placeholderImage: UIImage(named: "news-placeholder.jpg"))
        cell.articleTitleLabel.text = currentArticle.articleTitle
        cell.articleImage.sd_setImage(with: URL(string: currentArticle.articleImageUrl), placeholderImage: UIImage(named: "news-placeholder.jpg"))
        cell.articlePublicationTimeLabel.text = currentArticle.articlePublicationTime
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Selected -->> \(newsArray[indexPath.row].articleTitle)")
        performSegue(withIdentifier: "goToArticleView", sender: self)
        newsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destintionVC = segue.destination as! ArticleViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destintionVC.articleUrl = newsArray[indexPath.row].articleUrl
        }
    }
    
    private func getTopHeadLinesNews() {
        let params: [String : String] = [
            "country" : getCurrentCountry(),
            "pageSize" : pageSize,
            "apiKey" : apiKey
        ]
        Alamofire.request(baseUrl, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success response!")
                let responseJSON : JSON = JSON(response.result.value!)
                self.updateUIArticleList(responseJSON)
                //print(responseJSON)
            } else {
                print("Response in errorr \(response.error!)")
            }
        }
    }
    
    private func updateUIArticleList(_ responseJSON: JSON) {
        if let responseArticleArray = responseJSON["articles"].array {
            if !responseArticleArray.isEmpty {
                for responseArticle in responseArticleArray {
                    let article = Article()
                    
                    article.sourceTitle = responseArticle["source"]["name"].string ?? ""
                    //print("sourceTitle is -->> \(article.sourceTitle)")
                    article.articleTitle = responseArticle["title"].string ?? ""
                    article.articleImageUrl = responseArticle["urlToImage"].string ?? ""
                    article.articleUrl = responseArticle["url"].string ?? ""
                    //print("article.articleUrl is -->> \(article.articleUrl)")
                    article.articlePublicationTime = responseArticle["publishedAt"].string ?? ""
                    let newsUrl: URL = URL(string: article.articleUrl)!
                    let baseSourceUrl = newsUrl.host
                    article.sourceImageUrl = "https://besticon-demo.herokuapp.com/icon?url=\(baseSourceUrl!)&size=32..64..64"
                    newsArray.append(article)
                }
            }
        }
        newsTableView.separatorStyle = .singleLine
        spiner.stopAnimating()
        newsTableView.reloadData()
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    private func getCurrentCountry() -> String {
        var defaultCountry: String = "us"
        let arrayCountry = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            if arrayCountry.contains(countryCode.lowercased()) {
                defaultCountry = countryCode.lowercased()
            }
        }
        return defaultCountry
    }
}

