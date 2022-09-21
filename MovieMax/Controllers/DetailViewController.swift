//
//  DetailViewController.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var detailTableView: UITableView!
    
    private let doneButtonCellIdentifier = "DoneButtonTableViewCell"
    private let titleCellIdentifier = "TitleTableViewCell"
    private let posterCellIdentifier = "PosterTableViewCell"
    private let plotCellIdentifier = "PlotTableViewCell"
    private let languageCellIdentifier = "LanguageTableViewCell"
    private let ratingCellIdentifier = "RatingTableViewCell"
    private let watchListButtonCellIdentifier = "WatchListButtonTableViewCell"
    private var viewModel: ViewModel?
    private var activityIndicator = UIActivityIndicatorView()
    private var animatorView = UIView()
    var imdbID: String?
    var addToWatchListClosure: ((String) -> (Bool))?
    var isPresentInWatchList: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        registerCustomViewInCell()
        setUpViewModel()
        addLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        detailTableView.reloadData()
    }
    
    private func setUpViewModel() {
        if let imdbID = imdbID {
            viewModel = ViewModel(imdbID: imdbID)
            viewModel?.inantiateViewModel()
            viewModel?.setDataClosure = { [weak self] in
                self?.animatorView.removeFromSuperview()
                self?.detailTableView.reloadData()
            }
        }
    }
    
    fileprivate func addLoader() {
        animatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        animatorView.backgroundColor = .black
        animatorView.addSubview(activityIndicator)
        view.addSubview(animatorView)
        animatorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        animatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        animatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    private func registerCustomViewInCell() {
        let doneButtonNib = UINib(nibName: doneButtonCellIdentifier, bundle: nil)
        detailTableView.register(doneButtonNib, forCellReuseIdentifier: doneButtonCellIdentifier)
        
        let titleNib = UINib(nibName: titleCellIdentifier, bundle: nil)
        detailTableView.register(titleNib, forCellReuseIdentifier: titleCellIdentifier)
        
        let posterNib = UINib(nibName: posterCellIdentifier, bundle: nil)
        detailTableView.register(posterNib, forCellReuseIdentifier: posterCellIdentifier)
        
        let plotNib = UINib(nibName: plotCellIdentifier, bundle: nil)
        detailTableView.register(plotNib, forCellReuseIdentifier: plotCellIdentifier)

        let languageNib = UINib(nibName: languageCellIdentifier, bundle: nil)
        detailTableView.register(languageNib, forCellReuseIdentifier: languageCellIdentifier)
        
        let ratingNib = UINib(nibName: ratingCellIdentifier, bundle: nil)
        detailTableView.register(ratingNib, forCellReuseIdentifier: ratingCellIdentifier)
        
        let watchListButtonNib = UINib(nibName: watchListButtonCellIdentifier, bundle: nil)
        detailTableView.register(watchListButtonNib, forCellReuseIdentifier: watchListButtonCellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: doneButtonCellIdentifier, for: indexPath) as? DoneButtonTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.popViewClosure = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: titleCellIdentifier, for: indexPath) as? TitleTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.titleLabel.text = viewModel?.getTitle()
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: posterCellIdentifier, for: indexPath) as? PosterTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            if let url = URL(string: viewModel?.getPosterUrl() ?? "") {
                cell.posterImageView.load(url: url)
            }
            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: plotCellIdentifier, for: indexPath) as? PlotTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.plotLabel.text = viewModel?.getPlot()
            return cell
        } else if indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: languageCellIdentifier, for: indexPath) as? LanguageTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.languageLabel.text = viewModel?.getLanguage()
            return cell
        } else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ratingCellIdentifier, for: indexPath) as? RatingTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.ratingLabel.text = viewModel?.getRating()
            return cell
        } else if indexPath.row == 6 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: watchListButtonCellIdentifier, for: indexPath) as? WatchListButtonTableViewCell else {
                print("Failed to create the custom cell")
                return UITableViewCell()
            }
            cell.watchListButtonOutlet.layer.cornerRadius = cell.watchListButtonOutlet.bounds.width / 2
            if let isPresent = isPresentInWatchList {
                if isPresent {
                    cell.watchListButtonOutlet.backgroundColor = UIColor.green
                    cell.watchListButtonOutlet.setTitle("-", for: .normal)
                } else {
                    cell.watchListButtonOutlet.backgroundColor = UIColor.red
                    cell.watchListButtonOutlet.setTitle("+", for: .normal)
                }
            } else {
                print("Specific movie detail, setdata error")
            }
            cell.watchListHandlerClosure = { [weak self] in
                var addedToWatchList: Bool?
                if let imdbID = self?.viewModel?.imdbID {
                    guard let completionBlock = self?.addToWatchListClosure else {return}
                    addedToWatchList = completionBlock(imdbID)
                }
                if let addedToWatchList = addedToWatchList {
                    if addedToWatchList == true {
                        cell.watchListButtonOutlet.backgroundColor = UIColor.green
                        cell.watchListButtonOutlet.setTitle("-", for: .normal)
                    } else {
                        cell.watchListButtonOutlet.backgroundColor = UIColor.red
                        cell.watchListButtonOutlet.setTitle("+", for: .normal)
                    }
                } else {
                    print("Specific movie detail, added watchlist error")
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            if indexPath.row == 2 {
                return UIScreen.main.bounds.height / 0.8
            }
            if indexPath.row == 6 {
                return UIScreen.main.bounds.height / 2
            }
        } else {
            if indexPath.row == 2 {
                return UIScreen.main.bounds.height / 2
            }
            if indexPath.row == 6 {
                return UIScreen.main.bounds.height / 5
            }
        }
        return UITableView.automaticDimension
    }
}
