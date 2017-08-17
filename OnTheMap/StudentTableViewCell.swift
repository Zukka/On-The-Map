//
//  StudentTableViewCell.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 17/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    // MARK: @IBOutlet
    @IBOutlet weak var studentFullName: UILabel!
    @IBOutlet weak var studentURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
