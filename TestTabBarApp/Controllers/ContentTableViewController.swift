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
    let spiner = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = spiner
        spiner.startAnimating()
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.separatorStyle = .none
    }
    
    func setNewListCategoryAndUpdateUI(articleArray: [Article]) {
        newsArray = articleArray
        tableView.reloadData()
        spiner.stopAnimating()
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
        print("\(newsArray[indexPath.row].articleUrl)")
        if let storyboard = self.parent?.storyboard {
            let newViewController = storyboard.instantiateViewController(withIdentifier: "ArticleViewController") as? ArticleViewController
            newViewController?.article = newsArray[indexPath.row]
            self.present(newViewController!, animated: true, completion: nil)
        }
    }
}
