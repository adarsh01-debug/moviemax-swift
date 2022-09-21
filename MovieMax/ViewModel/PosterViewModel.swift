//
//  PosterViewModel.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import Foundation

class PosterViewModel {
    private var posterUrl: String?
    
    init(posterUrl: String) {
        self.posterUrl = posterUrl
    }
    
    func getPosterUrl() -> String {
        if let posterUrl = posterUrl {
            return posterUrl
        }
        return "NA"
    }
}
