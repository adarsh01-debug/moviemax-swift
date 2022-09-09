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
    private var movieData: [Search] = []
    
    // MARK: - Actions
    @IBAction func searchButtonAction(_ sender: Any) {
        if let text = searchTextField.text {
            self.tableView.isUserInteractionEnabled = false
            movieAPI.fecthMovieDetails(movieTitle: text, page: 1, completion: { [weak self] (movie) in
                if let movieListScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListScreen") as? MovieListScreen {
                    movieListScreen.movieData = movie
                    movieListScreen.initialMovie = text
                    self?.searchTextField.text = ""
                    self?.searchTextField.resignFirstResponder()
                    self?.navigationController?.pushViewController(movieListScreen, animated: true)
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
        movieAPI.delegate = self
        searchButton.layer.cornerRadius = 10.0
        banner.layer.cornerRadius = 20.0
        banner.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isUserInteractionEnabled = true
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

// MARK: - Response Extension
extension HomeTableViewController: ResponseProtocol {
    func sendStatus(response: String?) {
        DispatchQueue.main.async {
            if response == "The data couldn’t be read because it is missing." {
                let alert = UIAlertController(title: "Hein ji?", message: "There is no such movie/show on this earth.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.tableView.isUserInteractionEnabled = true
            }
        }
    }
}
