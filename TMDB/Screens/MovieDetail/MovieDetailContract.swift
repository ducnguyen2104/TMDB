//
//  MovieDetailContract.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

protocol MovieDetailViewProtocol: AnyObject {
    func displayMovie(movieDetail: MovieDetail)
    func displayError(error: Error)
}

protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    func onViewReadyToLoad()
}
