//
//  FavouritesViewController.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 26/05/25.
//

import UIKit
import RealmSwift

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    private var realmDataBase : Realm?
    
    private var favouriteMovies : [Movie] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavouriteMovies()
        setupNavigation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            realmDataBase = try Realm()
        }
        catch(let error) {
            print(error)
        }
        setupStyles()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: .themeChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeChanged, object: nil)
    }
    
    func setupStyles() {
        self.view.backgroundColor =  ThemeManager.shared.defaultBackgroundColor
        self.favouritesTableView.backgroundColor = ThemeManager.shared.defaultBackgroundColor
    }
    
    func setupNavigation() {
        title = "My Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        favouritesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        favouritesTableView.separatorStyle = .none
    }
    
    func getFavouriteMovies() {
        if let favouritedMovies = realmDataBase?.objects(Movie.self) {
            favouriteMovies = Array(favouritedMovies)
            DispatchQueue.main.async {
                self.favouritesTableView.reloadData()
            }
        }
    }
}

extension FavouritesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commonCell = favouritesTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        commonCell.selectionStyle = .none
        commonCell.setupMovieData(favouriteMovies[indexPath.row])
        return commonCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailsViewController(movie: favouriteMovies[indexPath.row])
        movieDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension FavouritesViewController {
    
    @objc func applyTheme() {
        setupStyles()
    }
    
}
