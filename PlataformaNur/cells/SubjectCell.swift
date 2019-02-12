//
//  SubjectCell.swift
//  PlataformaNur
//
//  Created by Ricardo Paz Demiquel on 14/12/18.
//  Copyright © 2018 Ricardo Paz Demiquel. All rights reserved.
//

import UIKit

class SubjectCell: UITableViewCell {

    @IBOutlet weak var lbSubjectName: UILabel!
    @IBOutlet weak var lbTeacherName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
