//
//  MovieGridCollectionViewCell.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 07/09/22.
//

import UIKit

class MovieGridCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var yearOfRelease: UILabel!
    @IBOutlet var typeOfObject: UILabel!
    @IBOutlet var watchListButton: UIButton!
    
    var imdbID: String?
    var type: String?
    weak var delegate: WatchListProtocol?
    
    @IBAction func watchListButtonAction(_ sender: Any) {
        var addedToWatchList: Bool?
        if let imdbID = imdbID {
            addedToWatchList = delegate?.addToWatchList(imdbID: imdbID)
        }
        if let addedToWatchList = addedToWatchList {
            if addedToWatchList == true {
                watchListButton.backgroundColor = UIColor.green
                watchListButton.setTitle("ADDED TO WATCH LIST", for: .normal)
            } else {
                watchListButton.backgroundColor = UIColor.red
                watchListButton.setTitle("ADD TO WATCH LIST", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        watchListButton.layer.cornerRadius = 15.0
        moviePoster.layer.masksToBounds = true
        moviePoster.layer.cornerRadius = 5.0
        moviePoster.layer.borderColor = UIColor.systemBlue.cgColor
        moviePoster.layer.borderWidth = 2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        layer.shadowRadius = 8.0
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}