//
//  Protocols.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 03/09/22.
//

import Foundation

protocol ResponseProtocol: AnyObject {
    func sendStatus(response: String?)
}

protocol WatchListProtocol: AnyObject {
    func addToWatchList(imdbID: String) -> Bool
    func reloadController()
}
