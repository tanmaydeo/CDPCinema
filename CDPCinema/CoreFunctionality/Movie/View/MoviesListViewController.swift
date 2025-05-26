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
    
    private var popularMoviesArray : [Movie] = []
    private var cachedData : [Movie] = []
    private var movieGenre : [Genre] = []
    
    private var currentPage : Int = 1
    private var isLoading = false
    private var totalPages = 0
    
    var activityIndicator : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        return loader
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        updateThemeForActivityIndicator()
        
        if cachedData.isEmpty {
            loadPopularMovies(page: 1)
            fetchGenre()
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
        setupThemeSwitchInNavigationBar()
        activityIndicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: .themeChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeChanged, object: nil)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = AppConstants.movieListViewControllerNavigationTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupThemeSwitchInNavigationBar() {
        let themeSwitch = UISwitch()
        themeSwitch.isOn = ThemeManager.shared.currentTheme == .dark
        themeSwitch.addTarget(self, action: #selector(toggleThemeSwitch), for: .valueChanged)
        
        let switchItem = UIBarButtonItem(customView: themeSwitch)
        self.navigationItem.leftBarButtonItem = switchItem
    }
    
    func setupHierarchy() {
        self.view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(view)
    }
    
    func setupTableView() {
        movieListTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        movieListTableView.separatorStyle = .none
    }
    
    private func setupStyles() {
        self.view.backgroundColor = ThemeManager.shared.defaultBackgroundColor
        movieListTableView.backgroundColor = ThemeManager.shared.defaultBackgroundColor
        movieListTableView.indicatorStyle = ThemeManager.shared.currentTheme == .dark ? .white : .black
        ThemeManager.shared.applyTheme(navigationController: self.navigationController, tabBarController: self.tabBarController)
    }
    
    func updateThemeForActivityIndicator() {
        activityIndicator.color = .gray
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
                    self.activityIndicator.stopAnimating()
                    self.movieListTableView.reloadData()
                }
            } else {
                print("Failed to fetch movies")
            }
        }
    }
    
    func fetchGenre() {
        movieViewModel.fetchGenres { genreArray in
            self.movieGenre = genreArray
            Genre.genreMap = Dictionary(uniqueKeysWithValues: genreArray.map { ($0.id, $0.name) })
        }
    }
    
    @objc func toggleThemeSwitch(_ sender: UISwitch) {
        let selectedTheme: AppTheme = sender.isOn ? .dark : .light
        ThemeManager.shared.currentTheme = selectedTheme
    }

    @objc func applyTheme() {
        setupStyles()
        movieListTableView.reloadData()
    }
}
