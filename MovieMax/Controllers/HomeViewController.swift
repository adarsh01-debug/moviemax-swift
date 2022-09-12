//
//  HomeViewController.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 12/09/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var homeTableView: UITableView!
    
    var searchedText: String?
    private let movieAPI = MovieAPI()
    private var movieData: [Search] = []
    
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
    
    private func registerCustomViewInCell() {
        let bannerNib = UINib(nibName: "BannerTableViewCell", bundle: nil)
        homeTableView.register(bannerNib, forCellReuseIdentifier: "BannerTableViewCell")
        
        let searchFieldNib = UINib(nibName: "SearchTextFieldTableViewCell", bundle: nil)
        homeTableView.register(searchFieldNib, forCellReuseIdentifier: "SearchTextFieldTableViewCell")
        
        let searchButtonNib = UINib(nibName: "SearchButtonTableViewCell", bundle: nil)
        homeTableView.register(searchButtonNib, forCellReuseIdentifier: "SearchButtonTableViewCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as? BannerTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.banner.layer.cornerRadius = 20.0
            cell.banner.clipsToBounds = true
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTextFieldTableViewCell", for: indexPath) as? SearchTextFieldTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.searchTextField.delegate = self
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchButtonTableViewCell", for: indexPath) as? SearchButtonTableViewCell else {
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchedText = textField.text
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            if indexPath.row == 0 {
                return UIScreen.main.bounds.height
            } else if indexPath.row == 1 {
                return UIScreen.main.bounds.height / 4
            } else {
                return UIScreen.main.bounds.height / 4
            }
        }
        if indexPath.row == 0 {
            return UIScreen.main.bounds.height / 2
        } else {
            return UIScreen.main.bounds.height / 5
        }
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
