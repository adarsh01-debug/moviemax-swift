//
//  MovieListScreen.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 03/09/22.
//

import UIKit

class MovieListScreen: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var movieSearchBar: UISearchBar!
    @IBOutlet var movieCollectionView: UICollectionView!
    @IBOutlet var viewToggleButton: UIButton!
    
    // MARK: - Variables
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    static var watchList: [String] = []
    var movieData: [Search] = []
    var initialMovie: String?
    private let movieAPI = MovieAPI()
    private let movieDetailAPI = MovieDetailAPI()
    private var totalPages: Int?
    private var currentPage: Int = 1
    private var isListView: Bool = true
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Actions
    @IBAction func backActionButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewToggleActionButton(_ sender: Any) {
        if isListView {
            viewToggleButton.setImage(UIImage(systemName: "rectangle.grid.1x2.fill"), for: .normal)
            isListView = false
            movieCollectionView.reloadData()
        } else {
            viewToggleButton.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
            isListView = true
            movieCollectionView.reloadData()
        }
    }
        
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        registerCustomViewInCell()
        movieSearchBar.delegate = self
        movieAPI.delegate = self
        pullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        movieCollectionView.reloadData()
    }
    
    private func isPresentInWatchList(imdbID: String) -> Bool {
        return MovieListScreen.watchList.contains(imdbID)
    }
    
    fileprivate func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        movieCollectionView.refreshControl = self.refreshControl
    }
    
    @objc func refresh(sender:AnyObject) {
        if let initialMovie = initialMovie {
            movieAPI.fecthMovieDetails(movieTitle: initialMovie, page: 1, completion: { (movie) in
                    self.movieData = movie
                    self.initialMovie = initialMovie
                    self.movieCollectionView.reloadData()
                })
            }
        self.refreshControl.endRefreshing()
    }
    
    private func loadImage(_ posterURL: String, completion: @escaping (UIImage?) -> ()) {
            utilityQueue.async {
            let url = URL(string: posterURL)
            if let url = url {
                guard let data = try? Data(contentsOf: url) else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}

// MARK: - CollectionView Extension
extension MovieListScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func registerCustomViewInCell() {
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        movieCollectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
        let gridNib = UINib(nibName: "MovieGridCollectionViewCell", bundle: nil)
        movieCollectionView.register(gridNib, forCellWithReuseIdentifier: "MovieGridCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isListView {
            guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
                    return UICollectionViewCell()
            }
            let basicDetail: Search? = movieData[indexPath.row]
            cell.movieTitle.text = basicDetail?.title
            if let year = basicDetail?.year {
                cell.yearOfRelease.text = "Released Year: \(year)"
            } else {
                cell.yearOfRelease.text = "Released Year: NA"
            }
            if let type = basicDetail?.type {
                cell.typeOfObject.text = type.rawValue
            } else {
                cell.typeOfObject.text = "Unknown"
            }
            cell.imdbID = basicDetail?.imdbID
            cell.delegate = self
            if let imdbID: String = basicDetail?.imdbID, MovieListScreen.watchList.contains(imdbID) {
                cell.watchListButton.backgroundColor = .green
                cell.watchListButton.setTitle("ADDED TO WATCHLIST", for: .normal)
            } else {
                cell.watchListButton.backgroundColor = .red
                cell.watchListButton.setTitle("ADD TO WATCHLIST", for: .normal)
            }
            return cell
        } else {
            guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCollectionViewCell", for: indexPath) as? MovieGridCollectionViewCell else {
                    return UICollectionViewCell()
            }
            cell.watchListButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            let basicDetail: Search? = movieData[indexPath.row]
            cell.movieTitle.text = basicDetail?.title
            if let year = basicDetail?.year {
                cell.yearOfRelease.text = "Released Year: \(year)"
            } else {
                cell.yearOfRelease.text = "Released Year: NA"
            }
            if let type = basicDetail?.type {
                cell.typeOfObject.text = type.rawValue
            } else {
                cell.typeOfObject.text = "Unknown"
            }
            cell.imdbID = basicDetail?.imdbID
            cell.delegate = self
            if let imdbID: String = basicDetail?.imdbID, MovieListScreen.watchList.contains(imdbID) {
                cell.watchListButton.backgroundColor = .green
                cell.watchListButton.setTitle("ADDED TO WATCHLIST", for: .normal)
            } else {
                cell.watchListButton.backgroundColor = .red
                cell.watchListButton.setTitle("ADD TO WATCHLIST", for: .normal)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imdbID = movieData[indexPath.row].imdbID {
            if let itemDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
                itemDetailViewController.imdbID = imdbID
                itemDetailViewController.isPresentInWatchList = self.isPresentInWatchList(imdbID: imdbID)
                itemDetailViewController.delegate = self
                self.navigationController?.pushViewController(itemDetailViewController, animated: true)
                }
        } else {
            print("Collection view controller, movie detail search error")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  movieCollectionView.bounds.width
        let height =  movieCollectionView.bounds.height
        if isListView {
            if UIDevice.current.orientation.isLandscape {
                return CGSize(width: width, height: height / 2.0)
            }
            return CGSize(width: width, height: 160.0)
        } else {
            if UIDevice.current.orientation.isLandscape {
                return CGSize(width: width / 2, height: height / 0.5)
            }
            return CGSize(width: width / 2, height: 310.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isListView {
            guard let cell = cell as? MovieCollectionViewCell else { return }
            let basicDetail: Search? = movieData[indexPath.row]
            let itemNumber = NSString(string: basicDetail?.imdbID ?? "")
            if let cachedImage = self.cache.object(forKey: itemNumber) {
                cell.moviePoster.image = cachedImage
            } else {
                if let poster = basicDetail?.poster {
                    self.loadImage(poster) { [weak self] (image) in
                        guard let self = self, let image = image else { return }
                        cell.moviePoster.image = image
                        self.cache.setObject(image, forKey: itemNumber)
                    }
                }
            }
        } else {
            guard let cell = cell as? MovieGridCollectionViewCell else { return }
            let basicDetail: Search? = movieData[indexPath.row]
            let itemNumber = NSString(string: basicDetail?.imdbID ?? "")
            if let cachedImage = self.cache.object(forKey: itemNumber) {
                cell.moviePoster.image = cachedImage
            } else {
                if let poster = basicDetail?.poster {
                    self.loadImage(poster) { [weak self] (image) in
                        guard let self = self, let image = image else { return }
                        cell.moviePoster.image = image
                        self.cache.setObject(image, forKey: itemNumber)
                    }
                }
            }
        }
        if indexPath.row == (movieData.count - 5) {
            if let text = initialMovie {
                currentPage = currentPage + 1
                movieAPI.fecthMovieDetails(movieTitle: text, page: self.currentPage, completion: { (movie) in
                    self.movieData.append(contentsOf: movie)
                    self.movieCollectionView.reloadData()
                })
            }
        }
    }
}

// MARK: - Response Extension
extension MovieListScreen: ResponseStatus {
    func sendStatus(response: String?) {
        DispatchQueue.main.async {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.movieCollectionView.bounds.size.width, height: self.movieCollectionView.bounds.size.height))
            if response == "The data couldn’t be read because it is missing." {
                noDataLabel.text = "No Result Found. :("
                noDataLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
                noDataLabel.textColor = UIColor.black
                noDataLabel.textAlignment = .center
                self.movieCollectionView.backgroundView  = noDataLabel
                self.movieCollectionView.backgroundColor = UIColor.white
                self.movieData.removeAll()
                self.totalPages = 0
                self.movieCollectionView.reloadData()
            } else {
                noDataLabel.text = ""
                self.movieCollectionView.backgroundView = nil
                self.movieCollectionView.backgroundColor = UIColor.clear
                self.movieCollectionView.reloadData()
            }
        }
    }
}

// MARK: - WatchList Extension
extension MovieListScreen: WatchListProtocol {
    func addToWatchList(imdbID: String) -> Bool {
        if let indexOfMovie = MovieListScreen.watchList.firstIndex(of: imdbID) {
            MovieListScreen.watchList.remove(at: indexOfMovie)
            return false
        } else {
            MovieListScreen.watchList.append(imdbID)
            return true
        }
    }
    
    func reloadController() {
        movieCollectionView.reloadData()
    }
}

// MARK: - SearchBar Delegate Extension
extension MovieListScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            initialMovie = searchText
            currentPage = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.movieAPI.fecthMovieDetails(movieTitle: searchText, page: 1, completion: { (movie) in
                    self.movieData = movie
                    self.movieCollectionView.reloadData()
                })
            }
        }
    }
}

// MARK: - Image Extension
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
