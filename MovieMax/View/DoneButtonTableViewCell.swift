//
//  DoneButtonTableViewCell.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import UIKit

class DoneButtonTableViewCell: UITableViewCell {

    @IBOutlet var doneButtonOutlet: UIButton!
    
    var popViewClosure: (() -> Void)?
    
    @IBAction func doneButtonAction(_ sender: Any) {
        popViewClosure?()
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
