//
//  MovieDetailsViewController.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 25/05/25.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "poster")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let titleAndRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Movie Name"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
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
        label.text = "Release Date: 2 Jun 2025"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = """
        Following the benevolent King's disappearance, the Evil Queen dominated the once fair land with a cruel streak. Princess Snow White flees the castle when the Queen, in her jealousy over Snow White's inner beauty, tries to kill her. Deep into the dark woods, she stumbles upon seven magical dwarves and a young bandit named Jonathan. Together, they strive to survive the Queen's relentless pursuit and aspire to take back the kingdom.
        """
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
        label.text = "7.5 / 10"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Setup Methods
    
    private func setupViewAppearance() {
        view.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNavigationBar() {
        title = "Movie Detail"
        
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
        
        containerStackView.addArrangedSubview(titleAndRatingStackView)
        containerStackView.addArrangedSubview(releaseDateLabel)
        containerStackView.setCustomSpacing(12, after: releaseDateLabel)
        containerStackView.addArrangedSubview(overviewLabel)
        
        titleAndRatingStackView.addArrangedSubview(movieTitleLabel)
        titleAndRatingStackView.addArrangedSubview(ratingStackView)
        
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
            posterImageView.heightAnchor.constraint(equalToConstant: 275),
            
            // Container Stack View
            containerStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            // Rating Icon Size
            ratingIconImageView.widthAnchor.constraint(equalToConstant: 20),
            ratingIconImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}

//MARK: @Objc funcs
extension MovieDetailsViewController {
    @objc private func favouriteButtonTapped() {
        print("Favourite button tapped")
    }
}
