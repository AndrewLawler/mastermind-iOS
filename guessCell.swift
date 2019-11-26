//
//  guessCell.swift
//  mastermind
//
//  Created by Andrew Lawler on 23/10/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//
//  iOS App Development Assignment 1 - Mastermind game:
//  - Selection Bar (Real-Time)
//  - Score Tracking
//  - Guess Tracking
//  - Easy selection/deletion
//
//  Build Date: 24/10/19

import UIKit

class guessCell: UITableViewCell {

    // imported outlets for custom cell
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
