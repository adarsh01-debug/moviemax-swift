//
//  ItemDetailModel.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 03/09/22.
//

import Foundation

struct ItemDetailModel: Codable {
    var title: String?
    var poster: String?
    var plot: String?
    var language: String?
    var imdbRating: String?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case title = "Title"
        case poster = "Poster"
        case plot = "Plot"
        case language = "Language"
        case imdbRating
    }
}
