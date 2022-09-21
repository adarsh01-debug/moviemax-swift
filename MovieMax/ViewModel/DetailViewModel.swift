//
//  DetailViewModel.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 16/09/22.
//

import UIKit
import Foundation

class ViewModel {
    private let movieDetailAPI = MovieDetailAPI()
    private let movieListScreen = MovieListScreen()
    private var movie: ItemDetailModel = ItemDetailModel()
    private var titleViewModel: TitleViewModel?
    private var posterViewModel: PosterViewModel?
    private var plotViewModel: PlotViewModel?
    private var languageViewModel: LanguageViewModel?
    private var ratingViewModel: RatingViewModel?
    var imdbID: String?
    var isPresentInWatchList: Bool?
    var addToWatchListClosure: ((String)->(Bool))?
    var setDataClosure: (()->Void)?
    var sendWatchListClosure: ((Bool)->Void)?
    
    init?(imdbID: String, isPresentInWatchList: Bool) {
        if imdbID == "", isPresentInWatchList == false {
            return nil
        }
        self.imdbID = imdbID
        self.isPresentInWatchList = isPresentInWatchList
        detailFetch()
    }
    
    private func createInstances() {
        if let title = movie.title {
            titleViewModel = TitleViewModel(title: title)
        }
        if let poster = movie.poster {
            posterViewModel = PosterViewModel(posterUrl: poster)
        }
        if let plot = movie.plot {
            plotViewModel = PlotViewModel(plot: plot)
        }
        if let language = movie.language {
            languageViewModel = LanguageViewModel(language: language)
        }
        if let rating = movie.imdbRating {
            ratingViewModel = RatingViewModel(rating: rating)
        }
    }
    
    private func detailFetch() {
        if let imdbID = imdbID {
            movieDetailAPI.fetchSpecificDetailApi(imdbID: imdbID, completion: { (movie) in
                self.movie = movie
                self.createInstances()
                self.setDataClosure?()
            })
        }
    }
    
    func getTitle() -> String {
        if let title = titleViewModel?.getTitle() {
            return title
        }
        return "NA"
    }
    
    func getPosterUrl() -> URL? {
        if let posterUrl = posterViewModel?.getPosterUrl() {
            return URL(string: posterUrl) ?? nil
        }
        return nil
    }
    
    func getPlot() -> String {
        if let plot = plotViewModel?.getPlot() {
            return plot
        }
        return "NA"
    }
    
    func getLanguage() -> String {
        if let language = languageViewModel?.getLanguage() {
            return language
        }
        return "Language : NA"
    }
    
    func getRating() -> String {
        if let rating = ratingViewModel?.getRating() {
            return rating
        }
        return "Rating : NA"
    }
    
    func getWatchListButtonBGColor() -> UIColor {
        if let isPresent = isPresentInWatchList {
            if isPresent {
                return .green
            }
        }
        return .red
    }
    
    func getWatchListButtonTitle() -> String {
        if let isPresent = isPresentInWatchList {
            if isPresent {
                return "-"
            }
        }
        return "+"
    }
    
    func getNumberOfRows() -> Int {
        return 7
    }
}
