//
//  DetailViewController.swift
//  MovieMax
//
//  Created by Adarsh Pandey on 20/09/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var detailTableView: UITableView!
    
    //MARK: - Variables
    private var viewModel = ViewModel(imdbID: "", isPresentInWatchList: false)
    private var activityIndicator = UIActivityIndicatorView()
    private var animatorView = UIView()
    private var refreshControl = UIRefreshControl()
    var imdbID: String?
    var addToWatchListClosure: ((String) -> (Bool))?
    var isPresentInWatchList: Bool?
    var isDataLoaded: Bool = false

    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        registerCustomViewInCell()
        setUpViewModel()
        fetchMovieDetails()
        addLoader()
        pullToRefresh()
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
        if let imdbID = imdbID, let isPresentInWatchList = self.isPresentInWatchList  {
            viewModel = ViewModel(imdbID: imdbID, isPresentInWatchList: isPresentInWatchList)
            viewModel?.reloadDataClosure = { [weak self] in
                self?.isDataLoaded = true
                self?.animatorView.removeFromSuperview()
                self?.detailTableView.reloadData()
            }
        }
    }
    
    private func fetchMovieDetails() {
        viewModel?.detailFetch()
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
    
    fileprivate func pullToRefresh() {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.refreshControl.tintColor = UIColor.white
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing", attributes: attributes)
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        detailTableView.refreshControl = self.refreshControl
    }
    
    @objc func refresh(sender:AnyObject) {
        detailTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}

//MARK: - TableView Extension
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func registerCustomViewInCell() {
        let doneButtonNib = UINib(nibName: TableViewCellConstants.doneButtonCellIdentifier, bundle: nil)
        detailTableView.register(doneButtonNib, forCellReuseIdentifier: TableViewCellConstants.doneButtonCellIdentifier)
        let titleNib = UINib(nibName: TableViewCellConstants.titleCellIdentifier, bundle: nil)
        detailTableView.register(titleNib, forCellReuseIdentifier: TableViewCellConstants.titleCellIdentifier)
        let posterNib = UINib(nibName: TableViewCellConstants.posterCellIdentifier, bundle: nil)
        detailTableView.register(posterNib, forCellReuseIdentifier: TableViewCellConstants.posterCellIdentifier)
        let plotNib = UINib(nibName: TableViewCellConstants.plotCellIdentifier, bundle: nil)
        detailTableView.register(plotNib, forCellReuseIdentifier: TableViewCellConstants.plotCellIdentifier)
        let languageNib = UINib(nibName: TableViewCellConstants.languageCellIdentifier, bundle: nil)
        detailTableView.register(languageNib, forCellReuseIdentifier: TableViewCellConstants.languageCellIdentifier)
        let ratingNib = UINib(nibName: TableViewCellConstants.ratingCellIdentifier, bundle: nil)
        detailTableView.register(ratingNib, forCellReuseIdentifier: TableViewCellConstants.ratingCellIdentifier)
        let watchListButtonNib = UINib(nibName: TableViewCellConstants.watchListButtonCellIdentifier, bundle: nil)
        detailTableView.register(watchListButtonNib, forCellReuseIdentifier: TableViewCellConstants.watchListButtonCellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numOfRows = viewModel?.getNumberOfRows() {
            return numOfRows + 2
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDataLoaded {
            var rowType: Components?
            if indexPath.row != 0, indexPath.row != 6 {
                rowType =  viewModel?.rows[indexPath.row - 1] ?? nil
            }
            var rowHandler: TableViewHandler?
            switch rowType {
            case .title(let vm):
                rowHandler = TitleHandler(viewModel: vm)
            case .poster(let vm):
                rowHandler = PosterHandler(viewModel: vm)
            case .plot(let vm):
                rowHandler = PlotHandler(viewModel: vm)
            case .language(let vm):
                rowHandler = LanguageHandler(viewModel: vm)
            case .rating(let vm):
                rowHandler = RatingHandler(viewModel: vm)
            default:
                break
            }
            if indexPath.row == 0 {
                return setDoneButtonCell(indexPath: indexPath)
            } else if indexPath.row == 6 {
                return setWatchListButtonCell(indexPath: indexPath)
            } else {
                return rowHandler?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height
        if UIDevice.current.orientation.isLandscape {
            if indexPath.row == 2 {
                return height / 0.8
            }
            if indexPath.row == 6 {
                return height / 2
            }
        } else {
            if indexPath.row == 2 {
                return height / 2
            }
            if indexPath.row == 6 {
                return height / 5
            }
        }
        return UITableView.automaticDimension
    }
}

//MARK: - Extenison to set cells having buttons
extension DetailViewController {
    func setDoneButtonCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detailTableView.dequeueReusableCell(withIdentifier: TableViewCellConstants.doneButtonCellIdentifier, for: indexPath) as? DoneButtonTableViewCell else {
            print("Failed to create the custom cell")
            return UITableViewCell()
        }
        cell.popViewClosure = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return cell
    }
    
    func setWatchListButtonCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detailTableView.dequeueReusableCell(withIdentifier: TableViewCellConstants.watchListButtonCellIdentifier, for: indexPath) as? WatchListButtonTableViewCell else {
            print("Failed to create the custom cell")
            return UITableViewCell()
        }
        cell.watchListButtonOutlet.layer.cornerRadius = cell.watchListButtonOutlet.bounds.width / 2
        cell.watchListButtonOutlet.backgroundColor = viewModel?.getWatchListButtonBGColor()
        cell.watchListButtonOutlet.setTitle(viewModel?.getWatchListButtonTitle(), for: .normal)
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
    }
}
