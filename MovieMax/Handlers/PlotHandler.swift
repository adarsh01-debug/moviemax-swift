//
//  PlotHandler.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 21/09/22.
//

import UIKit
import Foundation

class PlotHandler: TableViewHandler {
    
    var viewModel: PlotViewModel?
    
    init(viewModel: PlotViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellConstants.plotCellIdentifier, for: indexPath) as? PlotTableViewCell else {
            print("Failed to create the custom cell")
            return UITableViewCell()
        }
        cell.plotLabel.text = viewModel?.getPlot()
        return cell
    }
}
