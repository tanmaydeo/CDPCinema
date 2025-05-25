//
//  MovieTableViewCell.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 24/05/25.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    //MARK: View Declarations
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
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
    
    private let divider : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
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
        contentView.addSubview(divider)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(movieRatingLabel)
    }
    
    private func setupStyles() {
        moviePosterImageView.image = UIImage(named: "jio")
        movieTitleLabel.numberOfLines = 0
        movieReleaseDateLabel.numberOfLines = 0
        starImageView.image = UIImage(named: "movieRateIcon")
        starImageView.contentMode = .scaleAspectFill
        divider.layer.cornerRadius = divider.frame.size.width / 2
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Movie Poster
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            moviePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            moviePosterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 100),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 75),
            
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
            
            divider.heightAnchor.constraint(equalToConstant: 0.75),
            divider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            divider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            divider.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func setupMovieData(_ movie : Results) {
        movieTitleLabel.text = movie.title ?? "NA"
        movieReleaseDateLabel.text = "Release Date : \(movie.formattedReleaseDate ?? "NA")"
        movieRatingLabel.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
        moviePosterImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "/7Zx3wDG5bBtcfk8lcnCWDOLM4Y4.jpg")"))
    }
}
