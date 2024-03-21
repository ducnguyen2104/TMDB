//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import UIKit

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
    var presenter: MovieDetailPresenterProtocol?
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var blurBgView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Collection"
        return label
    }()
    
    private lazy var collectionImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(bgImageView)
        view.addSubview(blurBgView)
        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        
        scrollView.addSubview(posterImageView)
        scrollView.addSubview(collectionLabel)
        scrollView.addSubview(collectionImgView)
        scrollView.addSubview(collectionNameLabel)
        scrollView.addSubview(summaryLabel)
        presenter?.view = self
        presenter?.onViewReadyToLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgImageView.frame = view.bounds
        blurBgView.frame = view.bounds
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        scrollView.frame = CGRect(
            x: 0,
            y: statusbarHeight + 44,
            width: view.frame.width,
            height: view.frame.height - (statusbarHeight + 44))
        
        backButton.frame = CGRect(
            x: UIConst.padding,
            y: statusbarHeight,
            width: 50,
            height: 44)
        
        titleLabel.frame = CGRect(
            x: UIConst.padding + 50,
            y: statusbarHeight,
            width: view.frame.width - 2*(UIConst.padding + 50),
            height: 44)
        
        let posterWidth = view.frame.width/2
        posterImageView.frame = CGRect(
            x: view.frame.width/2 - posterWidth/2,
            y: UIConst.padding,
            width: posterWidth,
            height: posterWidth*16/9)

        collectionLabel.frame = CGRect(
            x: UIConst.padding,
            y: max(posterImageView.frame.maxY,
                   titleLabel.frame.maxY)
            + UIConst.padding,
            width: view.frame.width - 2*UIConst.padding,
            height: 20)
        let collectionImgWidth = view.frame.width/3
        collectionImgView.frame = CGRect(
            x: UIConst.padding,
            y: collectionLabel.frame.maxY + UIConst.padding,
            width: collectionImgWidth,
            height: collectionImgWidth*16/9)
        collectionNameLabel.frame = CGRect(
            x: collectionImgView.frame.maxX + UIConst.padding,
            y: collectionImgView.frame.minY,
            width: view.frame.width - collectionImgWidth - 3*UIConst.padding,
            height: collectionImgView.frame.height)
        
        let summarySize = summaryLabel.sizeThatFits(
            CGSize(width: view.frame.width - 2*UIConst.padding,
                   height: .infinity))
        let summaryTopView = collectionLabel.isHidden ? posterImageView : collectionImgView
        summaryLabel.frame = CGRect(
            x: UIConst.padding,
            y: summaryTopView.frame.maxY + UIConst.padding,
            width: view.frame.width - 2*UIConst.padding,
            height: summarySize.height)
        
        scrollView.contentSize = CGSize(
            width: view.frame.width,
            height: summaryLabel.frame.maxY + UIConst.padding)
    }
    
    func displayMovie(movieDetail: MovieDetail) {
        if let baseUrl = CacheManager.getImageBasePath(),
           let size = CacheManager.getBestPosterSize(size: posterImageView.frame.width) {
            posterImageView.kf.setImage(with: URL(string: "\(baseUrl)\(size)\(movieDetail.poster)"))
            bgImageView.kf.setImage(with: URL(string: "\(baseUrl)\(size)\(movieDetail.poster)" ))
            if let collectionPoster = movieDetail.collection?.poster,
               let collectionPosterSize = CacheManager.getBestPosterSize(size: collectionImgView.frame.width) {
                collectionImgView.kf.setImage(with: URL(string: "\(baseUrl)\(collectionPosterSize)\(collectionPoster)"))
            } else {
                collectionImgView.image = nil
            }
        }
        titleLabel.text = movieDetail.title
        if let collection = movieDetail.collection {
            collectionNameLabel.text = collection.name
            collectionLabel.isHidden = false
            collectionNameLabel.isHidden = false
            collectionImgView.isHidden = false
        } else {
            collectionNameLabel.text = nil
            collectionLabel.isHidden = true
            collectionNameLabel.isHidden = true
            collectionImgView.isHidden = true
        }
        summaryLabel.text = movieDetail.makeSummaryString()
        view.setNeedsLayout()
    }
    
    func displayError(error: Error) {
        
    }
    
}
