//
//  RatingHandler.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 21/09/22.
//

import UIKit
import Foundation

class RatingHandler: TableViewHandler {

    var viewModel: RatingViewModel?
    
    init(viewModel: RatingViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellConstants.ratingCellIdentifier, for: indexPath) as? RatingTableViewCell else {
            print("Failed to create the custom cell")
            return UITableViewCell()
        }
        cell.ratingLabel.text = viewModel?.getRating()
        return cell
    }
}
