//
//  LanguageHandler.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 21/09/22.
//

import UIKit
import Foundation

class LanguageHandler: TableViewHandler {
    
    var viewModel: LanguageViewModel?
    
    init(viewModel: LanguageViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellConstants.languageCellIdentifier, for: indexPath) as? LanguageTableViewCell else {
            print("Failed to create the custom cell")
            return UITableViewCell()
        }
        cell.languageLabel.text = viewModel?.getLanguage()
        return cell
    }
}
