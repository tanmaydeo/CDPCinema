//
//  MovieTableViewCell.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 24/05/25.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: View Declarations
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.gray
        return label
    }()
    
    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.gray
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 6
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: Initializations
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupStyles()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(movieReleaseDateLabel)
        contentView.addSubview(ratingStackView)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(movieRatingLabel)
    }
    
    private func setupStyles() {
        moviePosterImageView.image = UIImage(named: "jio")
        movieTitleLabel.numberOfLines = 0
        movieReleaseDateLabel.numberOfLines = 0
        starImageView.image = UIImage(named: "movieRateIcon")
        starImageView.contentMode = .scaleAspectFill
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Movie Poster
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            moviePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            moviePosterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 100),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 50),
            
            // Movie Title
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 24),
            movieTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Movie Release Date
            movieReleaseDateLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 24),
            movieReleaseDateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 8),
            movieReleaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Rating Stack View
            ratingStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            ratingStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Star Image
            starImageView.heightAnchor.constraint(equalToConstant: 16),
            starImageView.widthAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    func setupMovieData(_ movie : Results) {
        movieTitleLabel.text = movie.title ?? "NA"
        movieReleaseDateLabel.text = "Released on : \(movie.releaseDate ?? "NA")"
        movieRatingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
    }
}
