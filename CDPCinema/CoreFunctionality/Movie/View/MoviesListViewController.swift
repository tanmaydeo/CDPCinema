//
//  ViewController.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 24/05/25.
//

import UIKit

class MoviesListViewController: UIViewController {

    @IBOutlet weak var movieListTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        setupStyles()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = AppConstants.movieListViewControllerNavigationTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupHierarchy() {
        
    }
    
    func setupTableView() {
        movieListTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    func setupStyles() {
        self.view.backgroundColor = UIColor.white
        self.movieListTableView.backgroundColor = UIColor.white
    }
    
    func setupConstraints() {
        
    }
}

extension MoviesListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commonCell = movieListTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        commonCell.selectionStyle = .none
        return commonCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
