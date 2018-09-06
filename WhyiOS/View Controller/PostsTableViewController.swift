//
//  PostsTableViewController.swift
//  WhyiOS
//
//  Created by John Tate on 9/5/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    
    var posts: [Post] = [] {
        didSet {
            viewDidLoad()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = PostController.shared.posts[indexPath.row]
        cell.nameLabel?.text = post.name
        cell.cohortLabel?.text = post.cohort
        cell.reasonLabel?.text = post.reason
        
        return cell
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        PostController.shared.fetchPosts { (posts) in
            
            guard let posts = posts else {return}
            
            PostController.shared.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
       
        let reasonAlert = UIAlertController(title: "Why iOS?", message: "List your name, cohort, and reason for choosing iOS.", preferredStyle: .alert)
        
        reasonAlert.addTextField { (nameTextFieldForReason) in
            nameTextFieldForReason.placeholder = "Name"
        }
        reasonAlert.addTextField { (cohortTextFieldForReason) in
            cohortTextFieldForReason.placeholder = "Cohort"
        }
        reasonAlert.addTextField { (reasonTextFieldForReason) in
            reasonTextFieldForReason.placeholder = "Reason"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let nameText = reasonAlert.textFields?[0].text else { return }
            let cohortText = reasonAlert.textFields?[1].text ?? ""
            guard let reasonText = reasonAlert.textFields?[2].text else { return }
         
            PostController.shared.putPost(name: nameText, reason: reasonText, completion: { (true) in
                
            })
            
            self.tableView.reloadData()
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        reasonAlert.addAction(saveAction)
        reasonAlert.addAction(dismissAction)
        
        present(reasonAlert, animated: true)
        
    }

}
