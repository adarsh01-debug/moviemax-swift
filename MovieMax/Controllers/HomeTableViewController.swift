//
//  HomeTableViewController.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 02/09/22.
//

import UIKit

class HomeTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet var banner: UIImageView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    
    // MARK: - Variables
    private let movieAPI = MovieAPI()
    private var movieData: [MovieMax] = []
    
    // MARK: - Actions
    @IBAction func searchButtonAction(_ sender: Any) {
        if let text = searchTextField.text {
            movieAPI.fecthMovieDetails(movieTitle: text, page: 1, completion: { (movie) in
                if let movieListScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListScreen") as? MovieListScreen {
                    movieListScreen.movieData = movie
                    movieListScreen.initialMovie = text
                    self.searchTextField.text = ""
                    self.navigationController?.pushViewController(movieListScreen, animated: true)
                }
            })
        } else {
            print("movie title is empty")
        }
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        searchButton.layer.cornerRadius = 10.0
        self.banner.layer.cornerRadius = 20.0
        self.banner.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return UITableView.automaticDimension
        }
        return UIScreen.main.bounds.height
    }
}