//
//  MovieCollectionViewCell.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 03/09/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var yearOfRelease: UILabel!
    @IBOutlet var typeOfObject: UILabel!
    @IBOutlet var imageOfObject: UIImageView!
    @IBOutlet var watchListButton: UIButton!
    
    // MARK: - Variables
    var imdbID: String?
    var releasedYear: String?
    var type: String?
    weak var delegate: WatchListProtocol?
    
    // MARK: - Actions
    @IBAction func watchListButtonAction(_ sender: Any) {
        var addedToWatchList: Bool?
        if let imdbID = imdbID {
            addedToWatchList = delegate?.addToWatchList(imdbID: imdbID)
        }
        if let addedToWatchList = addedToWatchList {
            if addedToWatchList == true {
                watchListButton.backgroundColor = UIColor.green
                watchListButton.setTitle("ADDED TO WATCH LIST", for: .normal)
            }
            else {
                watchListButton.backgroundColor = UIColor.red
                watchListButton.setTitle("ADD TO WATCH LIST", for: .normal)
            }
        }
    }
    
    // MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        watchListButton.layer.cornerRadius = 15.0
        updateData()
    }

    private func updateData() {
        if let year = releasedYear {
            yearOfRelease.text = year
        }
        if let type = type {
            if type == TypeEnum.movie.rawValue {
                imageOfObject.image = UIImage(systemName: "video.fill")
            } else if type == TypeEnum.series.rawValue {
                imageOfObject.image = UIImage(systemName: "tv")
            }
        }
    }
}
