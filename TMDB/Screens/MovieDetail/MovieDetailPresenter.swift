//
//  MovieDetailPresenter.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    var view: MovieDetailViewProtocol?
    
    private var networkDispatcher: NetworkDispatcher {
        let target = Target(host: "https://api.themoviedb.org")
        return NetworkDispatcher(target: target)
    }
    
    private let movId: Int
    
    init(movId: Int) {
        self.movId = movId
    }
    
    func onViewReadyToLoad() {
        GetMovieDetailTask(movId: movId).execute(
            in: networkDispatcher,
            success: { [weak self] mov in
                self?.view?.displayMovie(movieDetail: mov)
                CoreDataService.shared.addMovieDetailData(movie: mov)
            },
            failure: { [weak self] err in
                guard let self = self else {
                    return
                }
                self.lookupLocal(movId: self.movId)
            })
    }
    
    private func lookupLocal(movId: Int) {
        if let mov = CoreDataService.shared.getMovieDetailData(movId: movId) {
            view?.displayMovie(movieDetail: mov)
        }
    }
}
