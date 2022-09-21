//
//  PlotViewModel.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import Foundation

class PlotViewModel {
    private var plot: String?
    
    init(plot: String) {
        self.plot = plot
    }
    
    func getPlot() -> String {
        if let plot = plot {
            return plot
        }
        return "NA"
    }
}
