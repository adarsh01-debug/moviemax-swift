//
//  PosterHandler.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 21/09/22.
//

import UIKit
import Foundation

class PosterHandler: TableViewHandler {
    
    var viewModel: PosterViewModel?
    
    init(viewModel: PosterViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellConstants.posterCellIdentifier, for: indexPath) as? PosterTableViewCell else {
            print("Failed to create the custom cell")
            return UITableViewCell()
        }
        if let url = viewModel?.getPosterUrl() {
            cell.posterImageView.load(url: url)
        }
        return cell
    }
}
