//
//  GetConfigTask.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

class GetConfigTask: Operation {
    
    var request: Request {
        return ConfigRequest.get_config
    }
    
    func execute(
        in dispatcher: Dispatcher,
        success: @escaping (ConfigResponse) -> Void,
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
                            let resp = ConfigResponse(withJson: json)
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
