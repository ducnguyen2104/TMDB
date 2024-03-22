//
//  GetListTrendingTask.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class GetListTrendingTask: Operation {
    let page: Int
    
    init(page: Int = 1) {
        self.page = page
    }
    
    var request: Request {
        return MovieRequest.get_list_trending(page: page)
    }
    
    func execute(
        in dispatcher: Dispatcher,
        success: @escaping (ListMovieResponse) -> Void,
        failure: @escaping (Error) -> Void) {
            do {
//                print(self.request.parameters)
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
