//
//  ItemDetailViewController.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 04/09/22.
//

import UIKit

class ItemDetailViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var moviePlotLabel: UILabel!
    @IBOutlet var movieLanguageLabel: UILabel!
    @IBOutlet var movieRatingLabel: UILabel!
    @IBOutlet var watchListButtonOutlet: UIButton!
    @IBOutlet var contentView: UIView!
    
    // MARK: - Variables
    private var activityIndicator = UIActivityIndicatorView()
    private var animatorView = UIView()
    private var movie: ItemDetailModel = ItemDetailModel()
    private let movieDetailAPI = MovieDetailAPI()
    var imdbID: String?
    var isPresentInWatchList: Bool?
    weak var delegate: WatchListProtocol?
    
    // MARK: - Actions
    @IBAction func doneActionButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func watchListButtonAction(_ sender: Any) {
        var addedToWatchList: Bool?
        if let imdbID = imdbID {
            addedToWatchList = delegate?.addToWatchList(imdbID: imdbID)
        }
        
        if let addedToWatchList = addedToWatchList {
            if addedToWatchList == true {
                watchListButtonOutlet.backgroundColor = UIColor.green
                watchListButtonOutlet.setTitle("-", for: .normal)
            } else {
                watchListButtonOutlet.backgroundColor = UIColor.red
                watchListButtonOutlet.setTitle("+", for: .normal)
            }
            delegate?.reloadController()
        } else {
            print("Specific movie detail, added watchlist error")
        }
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        watchListButtonOutlet.layer.cornerRadius = watchListButtonOutlet.bounds.width / 2
        pullToRefresh()
        addLoader()
        detailFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    fileprivate func addLoader() {
        animatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        animatorView.backgroundColor = .black
        animatorView.addSubview(activityIndicator)
        contentView.addSubview(animatorView)
        animatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        animatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        animatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        animatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: animatorView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: animatorView.centerYAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    fileprivate func detailFetch() {
        if let imdbID = imdbID {
            movieDetailAPI.fetchSpecificDetailApi(imdbID: imdbID, completion: { (movie) in
                self.movie = movie
                self.setData()
                self.animatorView.removeFromSuperview()
                self.tableView.reloadData()
            })
        }
    }
    
    fileprivate func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing", attributes: attributes)
        self.refreshControl?.tintColor = .white
        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.refreshControl = self.refreshControl
    }
    
    @objc func refresh(sender:AnyObject) {
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    fileprivate func setData() {
        if let urlString = movie.poster, let url = URL(string: urlString) {
            if let language = movie.language {
                movieLanguageLabel.text = "Language: \(language)"
            }
            moviePoster.load(url: url)
            movieTitleLabel.text = movie.title
            moviePlotLabel.text = movie.plot
            if let rating = movie.imdbRating {
                movieRatingLabel.text = "Rating: \(rating) ⭐"
            }
            if let isPresent = isPresentInWatchList {
                if isPresent {
                    watchListButtonOutlet.backgroundColor = UIColor.green
                    watchListButtonOutlet.setTitle("-", for: .normal)
                } else {
                    watchListButtonOutlet.backgroundColor = UIColor.red
                    watchListButtonOutlet.setTitle("+", for: .normal)
                }
            } else {
                print("Specific movie detail, setdata error")
            }
        }
    }
}
