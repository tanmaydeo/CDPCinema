//
//  SearchViewController.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 26/05/25.
//

import UIKit

class SearchViewController: UIViewController {

    private let searchController = UISearchController()
    
    private var searchViewModel = SearchViewModel()
    
    private var searchedMovies: [Movie] = []
    
    private var debounceWorkItem: DispatchWorkItem?
    
    private var searchResultsTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupStyles()
        setupTableView()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: .themeChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeChanged, object: nil)
    }
    
    func setupNavigationBar() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Movies"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func setupHierarchy() {
        self.view.addSubview(searchResultsTableView)
    }
    
    func setupStyles() {
        view.backgroundColor = ThemeManager.shared.defaultBackgroundColor
        searchResultsTableView.backgroundColor = ThemeManager.shared.defaultBackgroundColor
        if let textField = searchController.searchBar.searchTextField as? UITextField {
            textField.textColor = ThemeManager.shared.defaultTextColor
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search movies",
                attributes: [.foregroundColor: UIColor.lightGray]
            )
        }
    }
    
    func setupTableView() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        searchResultsTableView.separatorStyle = .none
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchResultsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchResultsTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commonCell = searchResultsTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        commonCell.selectionStyle = .none
        commonCell.setupMovieData(searchedMovies[indexPath.row])
        return commonCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailsViewController(movie: searchedMovies[indexPath.row])
        movieDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension SearchViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !query.isEmpty else {
            searchedMovies.removeAll()
            searchResultsTableView.reloadData()
            return
        }
        
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: query)
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    private func performSearch(query: String) {
        searchViewModel.searchMovies(query: query, pageNo: 1) { [weak self] results in
            DispatchQueue.main.async {
                if let results = results {
                    self?.searchedMovies = results
                } else {
                    self?.searchedMovies = []
                }
                self?.searchResultsTableView.reloadData()
            }
        }
    }
    
}

//MARK: Theme funciton
extension SearchViewController {
    
    @objc func applyTheme() {
        self.setupStyles()
        searchResultsTableView.reloadData()
    }
    
}
