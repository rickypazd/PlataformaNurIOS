//
//  SubjectOfferedCell.swift
//  PlataformaNur
//
//  Created by Ricardo Paz Demiquel on 14/12/18.
//  Copyright © 2018 Ricardo Paz Demiquel. All rights reserved.
//

import UIKit

class SubjectOfferedCell: UITableViewCell {

    @IBOutlet weak var lbSubjectName: UILabel!
    @IBOutlet weak var lbGroupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
