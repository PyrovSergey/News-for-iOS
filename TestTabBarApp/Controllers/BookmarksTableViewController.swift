//
//  BookmarksTableViewController.swift
//  TestTabBarApp
//
//  Created by Sergey on 15/02/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class BookmarksTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let realm = try! Realm()
    var bookmarksArray : Results<Article>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SwipeCustomNewsCell", bundle: nil), forCellReuseIdentifier: "swipeNewsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        load()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swipeNewsCell", for: indexPath) as! SwipeCustomNewsCell
        cell.delegate = self
        if (bookmarksArray?.count)! > 0 {
            let currentArticle: Article = bookmarksArray![indexPath.row]
            cell.sourceLabel.text = currentArticle.sourceTitle
            cell.sourceImage.sd_setImage(with: URL(string: currentArticle.sourceImageUrl), placeholderImage: UIImage(named: "news-placeholder.jpg"))
            cell.articleTitleLabel.text = currentArticle.articleTitle
            cell.articleImage.sd_setImage(with: URL(string: currentArticle.articleImageUrl), placeholderImage: UIImage(named: "news-placeholder.jpg"))
            cell.articlePublicationTimeLabel.text = currentArticle.articlePublicationTime
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bookmarksArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToArticleViewFromBookmarks", sender: self)
        //self.newsTableView.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destintionVC = segue.destination as! ArticleViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destintionVC.article = bookmarksArray![indexPath.row]
        }
    }
    
    func load() {
        bookmarksArray = realm.objects(Article.self)
        tableView.reloadData()
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let bookmark = self.bookmarksArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(bookmark)
                }
            } catch {
                print("Error deleting bookmark \(error)")
            }
        }
    }
}
