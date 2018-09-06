//
//  PostTableViewCell.swift
//  WhyiOS
//
//  Created by John Tate on 9/5/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cohortLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    var post: Post? {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
    
        guard let post = post else { return }
        nameLabel.text = post.name
        cohortLabel.text = post.cohort
        reasonLabel.text = post.reason
    }
}
