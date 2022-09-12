//
//  HomeViewController.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 12/09/22.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet var homeTableView: UITableView!
    
    // MARK: - Variables
    var searchedText: String?
    private let movieAPI = MovieAPI()
    private var movieData: [Search] = []
    private let bannerKCellIdentifier = "BannerTableViewCell"
    private let searchTextFieldKCellIdentifier = "SearchTextFieldTableViewCell"
    private let searchButtonKCellIdentifier = "SearchButtonTableViewCell"
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        registerCustomViewInCell()
        showAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeTableView.isUserInteractionEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        homeTableView.reloadData()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchedText = textField.text
    }
    
    fileprivate func showAlert() {
        movieAPI.responseStatusClosure = { [weak self] (response) in
            DispatchQueue.main.async {
                if response == false {
                    let alert = UIAlertController(title: "Hein ji?", message: "There is no such movie/show on this earth.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    self?.homeTableView.isUserInteractionEnabled = true
                }
            }
        }
    }
}

// MARK: - TableView Extenison
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    private func registerCustomViewInCell() {
        let bannerNib = UINib(nibName: bannerKCellIdentifier, bundle: nil)
        homeTableView.register(bannerNib, forCellReuseIdentifier: bannerKCellIdentifier)
        
        let searchFieldNib = UINib(nibName: searchTextFieldKCellIdentifier, bundle: nil)
        homeTableView.register(searchFieldNib, forCellReuseIdentifier: searchTextFieldKCellIdentifier)
        
        let searchButtonNib = UINib(nibName: searchButtonKCellIdentifier, bundle: nil)
        homeTableView.register(searchButtonNib, forCellReuseIdentifier: searchButtonKCellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: bannerKCellIdentifier, for: indexPath) as? BannerTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.banner.layer.cornerRadius = 20.0
            cell.banner.clipsToBounds = true
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: searchTextFieldKCellIdentifier, for: indexPath) as? SearchTextFieldTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.searchTextField.delegate = self
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: searchButtonKCellIdentifier, for: indexPath) as? SearchButtonTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.searchButton.layer.cornerRadius = 10.0
            cell.apiHandlerClosure = { [weak self] in
                if let text = self?.searchedText {
                    self?.homeTableView.isUserInteractionEnabled = false
                    self?.movieAPI.fecthMovieDetails(movieTitle: text, page: 1, completion: { [weak self] (movie) in
                        if let movieListScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListScreen") as? MovieListScreen {
                            movieListScreen.movieData = movie
                            movieListScreen.initialMovie = text
                            self?.navigationController?.pushViewController(movieListScreen, animated: true)
                        }
                    })
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            if indexPath.row == 0 {
                return UIScreen.main.bounds.height * 1.5
            } else if indexPath.row == 1 {
                return UIScreen.main.bounds.height / 4
            } else {
                return UIScreen.main.bounds.height / 4
            }
        } else {
            if indexPath.row == 0 {
                return UIScreen.main.bounds.height / 2
            } else {
                return UIScreen.main.bounds.height / 5
            }
        }
    }
}
