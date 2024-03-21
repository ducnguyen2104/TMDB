//
//  ListMovContract.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import UIKit

protocol ListMovViewProtocol: AnyObject {
    func displayData()
    func appendData(indexPaths: [IndexPath])
    func displayError(error: Error)
}

protocol ListMovPresenterProtocol: AnyObject {
    var view: ListMovViewProtocol? { get set }
    func onViewReadyToLoad()
    func onScrollViewDidScroll(_ scrollView: UIScrollView)
    func numberOfRow() -> Int
    func getMovieAtIndex(index: Int) -> Movie?
    func search(kw: String?)
}
