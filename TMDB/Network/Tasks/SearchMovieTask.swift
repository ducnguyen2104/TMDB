//
//  SearchMovieTask.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class SearchMovieTask: Operation {
    let kw: String
    let page: Int
    
    init(kw: String, page: Int = 1) {
        self.kw = kw
        self.page = page
    }
    
    var request: Request {
        return MovieRequest.search(kw: kw, page: page)
    }
    
    func execute(
        in dispatcher: Dispatcher,
        success: @escaping (ListMovieResponse) -> Void,
        failure: @escaping (Error) -> Void) {
            do {
                print(self.request.parameters)
                try dispatcher.execute(request: self.request, response: { (res) in
                    switch res {
                    case .error(let error):
                        failure(error)
                    case .json(let json):
//                        print(json)
                        if json == JSON.null {
                            failure(NetworkError.noData)
                            return
                        }
                        DispatchQueue.global(qos: .background).async {
                            let resp = ListMovieResponse(withJson: json)
                            DispatchQueue.main.async {
                                success(resp)
                            }
                        }
                    case .data(_):
                        break
                    }
                })
            } catch {
                failure(error)
            }
        }
}
