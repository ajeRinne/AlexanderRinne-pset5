//
//  ToDoTableViewCell.swift
//  Many Lists
//
//  Created by Alexander Rinne on 17-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    var toDoID: Int64?
    var checkBox : Int64 = 0

    @IBOutlet var toDoTextField: UILabel!

    
    @IBOutlet var checkSwitchOutlet: UISwitch!

    
    @IBAction func checkSwitch(_ sender: Any) {

        if checkSwitchOutlet.isOn == true {
            checkBox = 1
            checkSwitchOutlet.setOn(true, animated: true)
            ToDoManager.shared.updateToDoChecked(ID: toDoID!, checked: 1)
        } else {
            checkBox = 0
            checkSwitchOutlet.setOn(false, animated: false)
            ToDoManager.shared.updateToDoChecked(ID: toDoID!, checked: 0)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
