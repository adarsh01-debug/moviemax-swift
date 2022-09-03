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
    @IBOutlet var pageCollectionView: UICollectionView!
    @IBOutlet var viewToggleButton: UIButton!
    
    // MARK: - Variables
    static var watchList: [String] = []
    var movieData: MovieMax?
    let movieAPI = MovieAPI()
    let movieDetailAPI = MovieDetailAPI()
    var totalPages: Int?
    var currentPage: Int?
    var initialMovie: String?
    var isListView: Bool = true
    
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
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        registerCustomViewInCell()
        getTotalNumberOfPages()
        movieSearchBar.delegate = self
        movieAPI.delegate = self
        currentPage = 1
    }
    
    func isPresentInWatchList(imdbID: String) -> Bool {
        return MovieListScreen.watchList.contains(imdbID)
    }
    
    fileprivate func getTotalNumberOfPages() {
        if let totalResults = movieData?.totalResults, let length = movieData?.search.count {
            totalPages = (Int(totalResults) ?? 0) / length
        }
    }
}

// MARK: - CollectionView Extension
extension MovieListScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func registerCustomViewInCell() {
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        movieCollectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        
        let newNib = UINib(nibName: "PageCollectionViewCell", bundle: nil)
        pageCollectionView.register(newNib, forCellWithReuseIdentifier: "PageCollectionViewCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieCollectionView {
            return movieData?.search.count ?? 0
        } else if collectionView == pageCollectionView {
            return totalPages ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == movieCollectionView {
            guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.cornerRadius = 10.0
            cell.layer.borderWidth = 1
            let basicDetail: Search? = movieData?.search[indexPath.row]
            cell.movieTitle.text = basicDetail?.title
            cell.releasedYear = "Released Year: \(basicDetail?.year ?? "NA")"
            cell.type = basicDetail?.type.rawValue
            cell.imdbID = basicDetail?.imdbID
            cell.delegate = self
            if let imdbID: String = basicDetail?.imdbID, MovieListScreen.watchList.contains(imdbID) {
                cell.watchListButton.backgroundColor = .green
                cell.watchListButton.setTitle("ADDED TO WATCHLIST", for: .normal)
            } else {
                cell.watchListButton.backgroundColor = .red
                cell.watchListButton.setTitle("ADD TO WATCHLIST", for: .normal)
            }
            if let poster = basicDetail?.poster, let url = URL(string: poster) {
                cell.moviePoster.load(url: url)
            }
            return cell
        } else {
            guard let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath) as? PageCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.pageNumber.text = "\(indexPath.row + 1)"
            if indexPath.row + 1 == currentPage {
                cell.pageNumber.textColor = .red
            } else {
                cell.pageNumber.textColor = .black
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == movieCollectionView {
            if let Search = movieData?.search[indexPath.row], let imdbID = Search.imdbID {
                movieDetailAPI.fetchSpecificDetailApi(imdbID: imdbID, completion: {
                    (movie: ItemDetailModel) in
                    if let itemDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
                        itemDetailViewController.movie = movie
                        itemDetailViewController.imdbID = imdbID
                        itemDetailViewController.isPresentInWatchList = self.isPresentInWatchList(imdbID: imdbID)
                        itemDetailViewController.delegate = self
                        self.navigationController?.pushViewController(itemDetailViewController, animated: true)
                    }
                })
            } else {
                print("Collection view controller, movie detail search error")
            }
        } else {
            if let cell = pageCollectionView.cellForItem(at: indexPath) as? PageCollectionViewCell {
                cell.pageNumber.textColor = .red
            }
            if let text = initialMovie {
                currentPage = indexPath.row + 1
                movieAPI.fecthMovieDetails(movieTitle: text, page: indexPath.row + 1, completion: { (movie) in
                    self.movieData = movie
                    self.movieCollectionView.reloadData()
                    self.pageCollectionView.reloadData()
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == movieCollectionView {
            if isListView {
                return CGSize(width: movieCollectionView.bounds.width, height: movieCollectionView.bounds.height / 2.3)
            } else {
                return CGSize(width: movieCollectionView.bounds.width / 2, height: movieCollectionView.bounds.height / 2)
            }
        } else {
            return CGSize(width: pageCollectionView.bounds.width / 5, height: pageCollectionView.bounds.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - Response Extension
extension MovieListScreen: ResponseStatus {
    func sendStatus(response: String?) {
        DispatchQueue.main.async {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.movieCollectionView.bounds.size.width, height: self.movieCollectionView.bounds.size.height))
            if response == "The data couldn’t be read because it is missing." {
                noDataLabel.text = "No Result Found."
                noDataLabel.textColor = UIColor.black
                noDataLabel.textAlignment = .center
                self.movieCollectionView.backgroundView  = noDataLabel
                self.movieCollectionView.backgroundColor = UIColor.white
                self.movieData = nil
                self.movieCollectionView.reloadData()
                self.pageCollectionView.reloadData()
            } else {
                noDataLabel.text = ""
                self.movieCollectionView.backgroundView = nil
                self.movieCollectionView.backgroundColor = UIColor.clear
                self.movieCollectionView.reloadData()
                self.pageCollectionView.reloadData()
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

extension MovieListScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            initialMovie = searchText
            currentPage = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.movieAPI.fecthMovieDetails(movieTitle: searchText, page: 1, completion: { (movie) in
                    self.movieData = movie
                    self.getTotalNumberOfPages()
                    self.movieCollectionView.reloadData()
                    self.pageCollectionView.reloadData()
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
