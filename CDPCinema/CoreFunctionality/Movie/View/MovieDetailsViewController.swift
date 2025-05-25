//
//  MovieDetailsViewController.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 25/05/25.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let titleRatingContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAppearance()
        setupNavigationBar()
        setupViewHierarchy()
        setupConstraints()
    }
    
    // MARK: Init Method
    init(movie: Results) {
        super.init(nibName: nil, bundle: nil)
        setupData(movie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupData(_ movie : Results) {
        posterImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "/7Zx3wDG5bBtcfk8lcnCWDOLM4Y4.jpg")"))
        movieTitleLabel.text = movie.title ?? "NA"
        ratingLabel.text = "\(String(format: "%.1f", movie.voteAverage ?? 0.0)) / 10"
        releaseDateLabel.text = "Release Date: \(movie.formattedReleaseDate ?? "NA")"
        overviewLabel.text = movie.overview ?? "NA"
    }
    
    private func setupViewAppearance() {
        view.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNavigationBar() {
        title = "Movie Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let favouriteButtonImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        let favouriteButton = UIBarButtonItem(image: favouriteButtonImage, style: .done, target: self, action: #selector(favouriteButtonTapped))
        favouriteButton.tintColor = .black
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
        
        titleRatingContainerView.addSubview(movieTitleLabel)
        titleRatingContainerView.addSubview(ratingStackView)
        
        ratingStackView.addArrangedSubview(ratingIconImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Poster Image
            posterImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 12),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            posterImageView.heightAnchor.constraint(equalToConstant: 320),
            
            // Container Stack View
            containerStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            // Title and Rating Layout
            movieTitleLabel.topAnchor.constraint(equalTo: titleRatingContainerView.topAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: titleRatingContainerView.leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingStackView.leadingAnchor, constant: -8),
            movieTitleLabel.bottomAnchor.constraint(equalTo: titleRatingContainerView.bottomAnchor),
            
            ratingStackView.topAnchor.constraint(equalTo: titleRatingContainerView.topAnchor, constant: 4),
            ratingStackView.trailingAnchor.constraint(equalTo: titleRatingContainerView.trailingAnchor),
            
            // Rating Icon Size
            ratingIconImageView.widthAnchor.constraint(equalToConstant: 20),
            ratingIconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

//MARK: @Objc funcs
extension MovieDetailsViewController {
    @objc private func favouriteButtonTapped() {
        print("Favourite button tapped")
    }
}
