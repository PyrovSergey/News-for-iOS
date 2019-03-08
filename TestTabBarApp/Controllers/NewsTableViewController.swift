//
//  FirstViewController.swift
//  TestTabBarApp
//
//  Created by Sergey on 15/02/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewController: UITableViewController, NetworkProtocol {

    @IBOutlet var newsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var newsArray = [Article]()
    let spiner = UIActivityIndicatorView(style: .gray)
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        NetworkManager.instace.getTopHeadLinesNews(listener: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.startAnimating()
        newsTableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        searchBar.placeholder = "Search news"
        newsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        newsTableView.separatorStyle = .none
        newsTableView.backgroundView = spiner
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        performSegue(withIdentifier: "goToArticleViewFromNews", sender: self)
        newsTableView.deselectRow(at: indexPath, animated: true)
        self.newsTableView.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destintionVC = segue.destination as! ArticleViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destintionVC.article = newsArray[indexPath.row]
        }
    }
    
    func successRequest(result: [Article], category: String) {
        newsArray = result
        spiner.stopAnimating()
        newsTableView.reloadData()
    }
    
    func errorRequest(errorMessage: String) {
        print(errorMessage)
        spiner.stopAnimating()
    }
}

extension NewsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let inputText = searchBar.text {
            spiner.startAnimating()
            NetworkManager.instace.getRequestDataNews(request: inputText, listener: self)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            spiner.startAnimating()
            NetworkManager.instace.getTopHeadLinesNews(listener: self)
            print("Empty search !!!")
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

