//
//  ListMovPresenter.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import UIKit

class ListMovPresenter: ListMovPresenterProtocol {
    
    var view: ListMovViewProtocol?
    
    private var isSearching: Bool {
        currentSearchKw != nil
    }
    
    private var listMovies: [Movie] = [ ]
    private var currentPage = 0
    private var totalPages = -1
    private var canLoadMore = false
    
    //search result
    private var currentSearchKw: String?
    private var listSearchMovies: [Movie] = [ ]
    private var currentSearchPage = 0
    private var totalSearchPages = -1
    private var canLoadMoreSearch = false
    
    private var isShowingLocalData = false
    
    private var currentListData: [Movie] {
        isSearching ? listSearchMovies : listMovies
    }

    private var networkDispatcher: NetworkDispatcher {
        let target = Target(host: "https://api.themoviedb.org")
        return NetworkDispatcher(target: target)
    }
    
    func onViewReadyToLoad() {
        if Reachability.isConnectedToNetwork() {
            view?.displayOfflineMode(isOffline: false)
            isShowingLocalData = false
            GetListTrendingTask().execute(
                in: networkDispatcher,
                success: { [weak self] resp in
                    self?.totalPages = resp.totalPages
                    self?.currentPage = resp.page
                    self?.listMovies = resp.results
                    self?.view?.displayData()
                    self?.canLoadMore = resp.page < resp.totalPages
                    resp.results.forEach{ CoreDataService.shared.addMovieData(movie: $0) }
                },
                failure: { [weak self] err in
                    DispatchQueue.main.async {
                        self?.view?.displayError(error: err)
                    }
                })
        } else {
            view?.displayOfflineMode(isOffline: true)
            isShowingLocalData = true
            CoreDataService.shared.fetchMovieData(
                page: currentPage,
                onSuccess: { [weak self] movies in
                    if movies.count == CoreDataService.numPerPage {
                        //may has more
                        self?.currentPage += 1
                        self?.canLoadMore = true
                    }
                    self?.listMovies = movies
                    self?.view?.displayData()
                })
        }
    }
    
    func search(kw: String?) {
        if let kw, !kw.isEmpty {
            currentSearchKw = kw
            networkDispatcher.cancel()
            if isShowingLocalData {
                CoreDataService.shared.searchMovieData(
                    keyword: kw,
                    onSuccess: { [weak self] mov in
                        self?.listSearchMovies = mov
                        self?.view?.displayData()
                        //currently get all results
                        self?.canLoadMoreSearch = false
                    })
            } else {
                SearchMovieTask(kw: kw).execute(
                    in: networkDispatcher,
                    success: { [weak self] resp in
                        self?.totalSearchPages = resp.totalPages
                        self?.currentSearchPage = resp.page
                        self?.listSearchMovies = resp.results
                        self?.view?.displayData()
                        self?.canLoadMoreSearch = resp.page < resp.totalPages
                    },
                    failure: { [weak self] err in
                        DispatchQueue.main.async {
                            self?.view?.displayError(error: err)
                        }
                    })
            }
        } else {
            currentSearchKw = nil
            if !listMovies.isEmpty {
                view?.displayData()
            } else {
                onViewReadyToLoad()
            }
        }
    }
    
    func tryLoadRemote() {
        guard Reachability.isConnectedToNetwork() else {
            return
        }
        GetListTrendingTask().execute(
            in: networkDispatcher,
            success: { [weak self] resp in
                self?.isShowingLocalData = false
                self?.view?.displayOfflineMode(isOffline: false)
                self?.totalPages = resp.totalPages
                self?.currentPage = resp.page
                self?.listMovies = resp.results
                self?.view?.displayData()
                self?.canLoadMore = resp.page < resp.totalPages
                resp.results.forEach{ CoreDataService.shared.addMovieData(movie: $0) }
            },
            failure: { err in
                
            })
    }
    
    func numberOfRow() -> Int {
        return currentListData.count
    }
    
    func getMovieAtIndex(index: Int) -> Movie? {
        guard index < currentListData.count else {
            return nil
        }
        return currentListData[index]
    }
    
    func onScrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - contentOffset <= 2 * scrollView.bounds.height {
            checkToLoadMore()
        }
    }
    
    private func checkToLoadMore() {
        if currentSearchKw != nil {
            loadMoreSearch()
        } else {
            if isShowingLocalData {
                loadMoreLocalData()
            } else {
                loadMoreListRemote()
            }
        }
    }
    
    private func loadMoreListRemote() {
        guard canLoadMore, currentPage + 1 <= totalPages else {
            return
        }
        canLoadMore = false
        
        GetListTrendingTask(page: currentPage + 1).execute(
            in: networkDispatcher,
            success: { [weak self] resp in
                guard let self = self else {
                    return
                }
                self.totalPages = resp.totalPages
                self.currentPage = resp.page
                let countBefore = self.listMovies.count
                self.listMovies.append(contentsOf: resp.results)
                let countAfter = self.listMovies.count
                let indexPaths = (countBefore...countAfter - 1).map { IndexPath(row: $0, section: 0)}
                self.view?.appendData(indexPaths: indexPaths)
                self.canLoadMore = self.currentPage < self.totalPages
                resp.results.forEach{ CoreDataService.shared.addMovieData(movie: $0) }
            },
            failure: { [weak self] err in
                self?.canLoadMore = true
            })
    }
    
    private func loadMoreSearch() {
        guard let currentSearchKw else {
            return
        }
        guard canLoadMoreSearch, currentSearchPage + 1 <= totalSearchPages else {
            return
        }
        canLoadMoreSearch = false
        
        SearchMovieTask(kw: currentSearchKw,
                        page: currentSearchPage + 1).execute(
            in: networkDispatcher,
            success: { [weak self] resp in
                guard let self = self else {
                    return
                }
                self.totalSearchPages = resp.totalPages
                self.currentSearchPage = resp.page
                let countBefore = self.listSearchMovies.count
                self.listSearchMovies.append(contentsOf: resp.results)
                let countAfter = self.listSearchMovies.count
                let indexPaths = (countBefore...countAfter - 1).map { IndexPath(row: $0, section: 0)}
                self.view?.appendData(indexPaths: indexPaths)
                self.canLoadMoreSearch = self.currentPage < self.totalPages
            },
            failure: { [weak self] err in
                self?.canLoadMoreSearch = true
            })
    }
    
    private func loadMoreLocalData() {
        guard canLoadMore else {
            return
        }
        CoreDataService.shared.fetchMovieData(
            page: currentPage,
            onSuccess: { [weak self] movies in
                guard let self = self else {
                    return
                }
                if movies.count == CoreDataService.numPerPage {
                    //may has more
                    self.currentPage += 1
                    self.canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
                guard !movies.isEmpty else {
                    return
                }
                let countBefore = self.listMovies.count
                self.listMovies.append(contentsOf: movies)
                let countAfter = self.listMovies.count
                let indexPaths = (countBefore...countAfter - 1).map { IndexPath(row: $0, section: 0)}
                self.view?.appendData(indexPaths: indexPaths)
            })
    }
}
