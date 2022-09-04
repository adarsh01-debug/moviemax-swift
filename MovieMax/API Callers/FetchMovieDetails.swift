//
//  FetchMovieDetails.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 04/09/22.
//

import Foundation

class MovieDetailAPI {
    
    let detailApiUrl: String = "https://www.omdbapi.com/?apikey=fd12ab17&i="
    
    func fetchSpecificDetailApi (imdbID: String, completion: @escaping ((ItemDetailModel)->())){
        let urlString = "\(detailApiUrl)\(imdbID)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {[weak self] (data,response,error) in
                if error != nil {
                    print("error")
                    return
                }
                if let safeData = data{
                    if let movie = self?.specificInfoParseJson(safeData) {
                        DispatchQueue.main.async {
                            completion(movie)
                        }
                    }
                }
            }
            task.resume()
        }
        else {
            print("invalid url")
        }
    }
    
    func specificInfoParseJson(_ movieData: Data) -> ItemDetailModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(ItemDetailModel.self, from: movieData)
            return decodeData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
