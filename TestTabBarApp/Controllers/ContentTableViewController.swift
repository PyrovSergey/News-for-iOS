//
//  ContentUITableViewController.swift
//  TestTabBarApp
//
//  Created by Sergey on 18/02/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import SDWebImage

class ContentTableViewController: UITableViewController {

    
    private var newsArray = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.separatorStyle = .none
    }
    
    func setNewListCategoryAndUpdateUI(articleArray: [Article]) {
        newsArray = articleArray
        tableView.reloadData()
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
        performSegue(withIdentifier: "goToArticleView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destintionVC = segue.destination as! ArticleViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destintionVC.articleUrl = newsArray[indexPath.row].articleUrl
        }
    }
}
