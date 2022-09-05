//
//  FetchMovies.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 03/09/22.
//

import Foundation

class MovieAPI {
    
    private let baseURL = "https://www.omdbapi.com/?apikey=fd12ab17"
    weak var delegate: ResponseStatus?
    
    func fecthMovieDetails (movieTitle: String, page: Int, completion: @escaping (([Search])->())) {
        let urlString = "\(baseURL)&s=\(movieTitle)&page=\(page)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {[weak self] (data, response, error) in
                if error != nil{
                    print("error")
                    return
                }
                if let safeData = data{
                    if let movie = self?.parseJson(safeData) {
                        DispatchQueue.main.async {
                            completion(movie)
                        }
                    }
                }
            }
            task.resume()
        } else {
            print("invalid url")
        }
    }
    
    private func parseJson(_ movieData: Data) -> [Search]? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(MovieMax.self, from: movieData)
            let Search = decodeData.search
            delegate?.sendStatus(response: "all good")
            return Search
        } catch {
            print(error.localizedDescription)
            delegate?.sendStatus(response: error.localizedDescription)
            return nil
        }
    }
}

