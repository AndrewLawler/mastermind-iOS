//
//  guessCell.swift
//  mastermind
//
//  Created by Andrew Lawler on 23/10/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//

import UIKit

class guessCell: UITableViewCell {

    @IBOutlet var imageViewOne: UIImageView!
    @IBOutlet var imageViewTwo: UIImageView!
    @IBOutlet var imageViewThree: UIImageView!
    @IBOutlet var imageViewFour: UIImageView!

    
    @IBOutlet var pegViewOne: UIImageView!
    @IBOutlet var pegViewTwo: UIImageView!
    @IBOutlet var pegViewThree: UIImageView!
    @IBOutlet var pegViewFour: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
