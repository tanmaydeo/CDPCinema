//
//  ViewController.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 24/05/25.
//

import UIKit

class MoviesListViewController: UIViewController {

    @IBOutlet weak var movieListTableView: UITableView!
    
    private let movieViewModel : MovieViewModel = MovieViewModel()
    
    private var popularMoviesArray : [Results] = []
    private var cachedData : [Results] = []
    
    private var currentPage : Int = 1
    private var isLoading = false
    private var totalPages = 0
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.tintColor = .black
        return loader
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        if cachedData.isEmpty {
            activityIndicator.startAnimating()
            loadPopularMovies(page: 1)
        } else {
            print("Used cache here")
            popularMoviesArray = cachedData
            movieListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupHierarchy()
        setupTableView()
        setupStyles()
        setupConstraints()
    }
    
    func setupNoPopularMoviesToShowView() {
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = AppConstants.movieListViewControllerNavigationTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupHierarchy() {
        self.view.addSubview(activityIndicator)
    }
    
    func setupTableView() {
        movieListTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        movieListTableView.separatorStyle = .none
    }
    
    func setupStyles() {
        self.view.backgroundColor = UIColor.white
        self.movieListTableView.backgroundColor = UIColor.white
    }
    
    func setupConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

extension MoviesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commonCell = movieListTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        commonCell.selectionStyle = .none
        commonCell.setupMovieData(popularMoviesArray[indexPath.row])
        return commonCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailsViewController(movie: popularMoviesArray[indexPath.row])
        movieDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == popularMoviesArray.count - 1 && !isLoading && currentPage < totalPages {
            loadMoreMovies()
        }
    }
}

extension MoviesListViewController {
    
    func loadMoreMovies() {
        currentPage += 1
        loadPopularMovies(page: currentPage)
    }
    
    func loadPopularMovies(page: Int) {
        isLoading = true
        movieViewModel.getPopularMovies(pageNo: page) { [weak self] movies,totalPages  in
            guard let self = self else { return }
            self.isLoading = false
            self.activityIndicator.stopAnimating()
            if self.totalPages == 0 {
                self.totalPages = totalPages
            }
            
            if let movies = movies {
                if page == 1 {
                    self.popularMoviesArray = movies
                } else {
                    self.popularMoviesArray.append(contentsOf: movies)
                }
                self.cachedData = self.popularMoviesArray
                self.currentPage = page
                
                DispatchQueue.main.async {
                    self.movieListTableView.reloadData()
                }
            } else {
                print("Failed to fetch movies")
            }
        }
    }
    
}
