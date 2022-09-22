//
//  TableViewHandler.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 21/09/22.
//

import UIKit
import Foundation

protocol TableViewHandler: AnyObject {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

class TitleHandler: TableViewHandler {
    
    var viewModel: TitleViewModel?
    
    init(viewModel: TitleViewModel?) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellConstants.titleCellIdentifier, for: indexPath) as? TitleTableViewCell else {
            print("Failed to create the custom cell")
            return UITableViewCell()
        }
        cell.titleLabel.text = viewModel?.getTitle()
        return cell
    }
}
