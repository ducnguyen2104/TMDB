//
//  GetMovieDetailTask.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class GetMovieDetailTask: Operation {
    let movId: Int
    
    init(movId: Int) {
        self.movId = movId
    }
    
    var request: Request {
        return MovieRequest.get_detail(movId: movId)
    }
    
    func execute(
        in dispatcher: Dispatcher,
        success: @escaping (MovieDetail) -> Void,
        failure: @escaping (Error) -> Void) {
            
            do {
                print(self.request.parameters)
                try dispatcher.execute(request: self.request, response: { (res) in
                    switch res {
                    case .error(let error):
                        failure(error)
                    case .json(let json):
                        print(json)
                        if json == JSON.null {
                            failure(NetworkError.noData)
                            return
                        }
                        DispatchQueue.global(qos: .background).async {
                            let resp = MovieDetail(withJson: json)
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
