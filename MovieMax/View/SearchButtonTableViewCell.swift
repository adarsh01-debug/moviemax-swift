//
//  SearchButtonTableViewCell.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 12/09/22.
//

import UIKit

class SearchButtonTableViewCell: UITableViewCell {

    @IBOutlet var searchButton: UIButton!
    
    var apiHandlerClosure: (() -> Void)?
    
    @IBAction func searchButtonAction(_ sender: Any) {
        apiHandlerClosure?()
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
