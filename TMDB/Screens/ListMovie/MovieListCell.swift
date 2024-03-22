//
//  MovieListCell.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import UIKit
import Kingfisher

class MovieListCell: UITableViewCell {
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var voteAvgLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let padding: CGFloat = 16

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(thumbImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(voteAvgLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(movie: Movie) {
        if let baseUrl = CacheManager.getImageBasePath(),
           let size = CacheManager.getBestPosterSize(size: thumbImageView.frame.width) {
            thumbImageView.kf.setImage(
                with: URL(string: "\(baseUrl)\(size)/\(movie.poster)"),
                completionHandler: { [weak self] result in
                    switch result {
                    case .success(let img):
                        CoreDataService.shared.addImageData(
                            path: movie.poster,
                            data: img.image.jpegData(compressionQuality: 1))
                    case .failure(_):
                        if let data = CoreDataService.shared.getImageData(path: movie.poster),
                           let image = UIImage(data: data) {
                            self?.thumbImageView.image = image
                        }
                    }
                })
        }
        nameLabel.text = movie.title
        dateLabel.text = String(movie.date.prefix(4))
        voteAvgLabel.text = "Average vote: \(movie.voteAvg)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let thumbHeight = frame.height - padding
        thumbImageView.frame = CGRect(
            x: padding,
            y: padding/2,
            width: thumbHeight*9/16,
            height: thumbHeight)
        
        nameLabel.frame = CGRect(
            x: thumbImageView.frame.maxX + padding,
            y: 0,
            width: frame.width - (thumbImageView.frame.maxX + padding),
            height: frame.height/3)
        
        dateLabel.frame = CGRect(
            x: thumbImageView.frame.maxX + padding,
            y: frame.height/3,
            width: frame.width - (thumbImageView.frame.maxX + padding),
            height: frame.height/3)
        
        voteAvgLabel.frame = CGRect(
            x: thumbImageView.frame.maxX + padding,
            y: frame.height/3*2,
            width: frame.width - (thumbImageView.frame.maxX + padding),
            height: frame.height/3)
    }
}
