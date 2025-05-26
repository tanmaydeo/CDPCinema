//
//  MovieDetailsViewController.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 25/05/25.
//

import UIKit
import Kingfisher
import RealmSwift

class MovieDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var realmDataBase : Realm?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let titleRatingContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let ratingIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "movieRateIcon")
        imageView.tintColor = .systemYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setContentHuggingPriority(.required, for: .horizontal)
        stack.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stack
    }()
    
    private let movieGenreLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private var movieID: Int = 0
    private var movieData : Movie?
    private var isCurrentMovieFavourite : Bool = false
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            realmDataBase = try Realm()
        } catch {
            print("Realm initialization error: \(error)")
        }
        
        setupViewAppearance()
        setupViewHierarchy()
        setupConstraints()
        
        guard let movieData else { return }
        isCurrentMovieFavourite = isMovieFavorited(id: movieID)
    }
    
    // MARK: Init Method
    init(movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        movieData = movie
        movieID = movie.id
        setupData(movie)
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: .themeChanged, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .themeChanged, object: nil)
    }
    
    // MARK: - Setup Methods
    
    private func setupData(_ movie : Movie) {
        posterImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "/7Zx3wDG5bBtcfk8lcnCWDOLM4Y4.jpg")"))
        movieTitleLabel.text = movie.title ?? "NA"
        ratingLabel.text = "\(String(format: "%.1f", movie.voteAverage)) / 10"
        releaseDateLabel.text = "Release Date: \(movie.formattedReleaseDate ?? "NA")"
        overviewLabel.text = movie.overview ?? "NA"
        movieGenreLabel.text = "Genre : \(movie.genreNames)"
    }
    
    private func setupViewAppearance() {
        view.backgroundColor = ThemeManager.shared.defaultBackgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.textColor = ThemeManager.shared.defaultTextColor
        ratingLabel.textColor = ThemeManager.shared.defaultTextColor
    }
    
    private func setupNavigationBar() {
        title = "Movie Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
        updateFavouriteButton()
    }
    
    private func updateFavouriteButton() {
        let favouriteButtonImage = isCurrentMovieFavourite
        ? UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        : UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        let favouriteButton = UIBarButtonItem(image: favouriteButtonImage, style: .done, target: self, action: #selector(updateFavouritesDatabase))
        favouriteButton.tintColor = isCurrentMovieFavourite ? .red : (ThemeManager.shared.currentTheme == .dark ? .white : .black)
        navigationItem.rightBarButtonItem = favouriteButton
    }
    
    private func setupViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(titleRatingContainerView)
        containerStackView.addArrangedSubview(releaseDateLabel)
        containerStackView.setCustomSpacing(12, after: releaseDateLabel)
        containerStackView.addArrangedSubview(overviewLabel)
        containerStackView.addArrangedSubview(movieGenreLabel)
        
        titleRatingContainerView.addSubview(movieTitleLabel)
        titleRatingContainerView.addSubview(ratingStackView)
        
        ratingStackView.addArrangedSubview(ratingIconImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 12),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            posterImageView.heightAnchor.constraint(equalToConstant: 320),
            
            containerStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            movieTitleLabel.topAnchor.constraint(equalTo: titleRatingContainerView.topAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: titleRatingContainerView.leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingStackView.leadingAnchor, constant: -8),
            movieTitleLabel.bottomAnchor.constraint(equalTo: titleRatingContainerView.bottomAnchor),
            
            ratingStackView.topAnchor.constraint(equalTo: titleRatingContainerView.topAnchor, constant: 4),
            ratingStackView.trailingAnchor.constraint(equalTo: titleRatingContainerView.trailingAnchor),
            
            ratingIconImageView.widthAnchor.constraint(equalToConstant: 20),
            ratingIconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

//MARK: Database Related Functions
extension MovieDetailsViewController {
    
    func isMovieFavorited(id: Int) -> Bool {
        if let favouritedMovies = realmDataBase?.objects(Movie.self) {
            return favouritedMovies.contains(where: { $0.id == id })
        }
        return false
    }
    
    @objc private func updateFavouritesDatabase() {
        guard let movie = movieData else { return }
        
        if isCurrentMovieFavourite {
            removeMovieFromFavourites(id: movie.id)
        } else {
            addMovieToFavourites(movie: movie)
        }
        
        updateFavouriteButton()
    }
    
    private func addMovieToFavourites(movie: Movie) {
        do {
            if let realm = realmDataBase {
                try realm.write {
                    let newMovie = Movie(value: movie) // create a copy
                    realm.add(newMovie, update: .modified)
                }
                isCurrentMovieFavourite = true
                sendNotificationForMovieFavourite(action: .added, movieTitle: movie.title ?? "Unknown")
            }
        } catch {
            print("Error adding movie to favourites: \(error)")
        }
    }
    
    private func removeMovieFromFavourites(id: Int) {
        guard let movieToRemove = realmDataBase?.object(ofType: Movie.self, forPrimaryKey: id) else { return }
        
        do {
            let title = movieToRemove.title
            try realmDataBase?.write {
                realmDataBase?.delete(movieToRemove)
            }
            isCurrentMovieFavourite = false
            sendNotificationForMovieFavourite(action: .deleted, movieTitle: title ?? "Unknown")
        } catch {
            print("Error removing movie from favourites: \(error)")
        }
    }
}

//MARK: Theme functions
extension MovieDetailsViewController {
    @objc func applyTheme() {
        setupViewAppearance()
    }
}

//MARK: Notification Related Work
extension MovieDetailsViewController {
    
    enum NotificationAction : String {
        case added = "added"
        case deleted = "deleted"
    }
    
    private func sendNotificationForMovieFavourite(action: NotificationAction, movieTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Favourites Updated"
        
        if action == .added {
            content.body = "You added \(movieTitle) to favourites!"
        } else {
            content.body = "You deleted \(movieTitle) from favourites!"
        }
        
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            } else {
                print("Notification sent successfully")
            }
        }
    }
}
