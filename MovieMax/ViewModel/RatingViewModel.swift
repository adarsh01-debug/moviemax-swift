//
//  RatingViewModel.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import Foundation

class RatingViewModel {
    private var rating: String?
    
    init(rating: String) {
        self.rating = "Rating : \(rating) ⭐"
    }
    
    func getRating() -> String {
        if let rating = rating {
            return rating
        }
        return "Rating : NA"
    }
}
