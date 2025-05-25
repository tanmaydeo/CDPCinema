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
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.tintColor = .black
        return loader
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        activityIndicator.startAnimating()
        movieViewModel.getPopularMovies(pageNo: 1) { popularMovies in
            guard let popularMovies else {
                self.setupNoPopularMoviesToShowView()
                return
            }
            self.popularMoviesArray = popularMovies
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.movieListTableView.reloadData()
            }
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
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MovieDetailsViewController(), animated: true)
    }
}
