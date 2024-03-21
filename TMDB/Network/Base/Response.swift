//
//  Response.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation
import SwiftyJSON

public enum Response {
    case error(_: Error)
    case data(_: Data)
    case json(_: JSON)
    
    init(data: Data?,
         urlResponse: URLResponse?,
         error: Error?,
         forRequest request:Request) {
        
        if error != nil {
            self = .error(error!)
            return
        }
        
        let http = urlResponse as! HTTPURLResponse
        
        if http.statusCode != 200 {
            self = .error(NetworkError.serverError(statusCode: http.statusCode))
            return
        }
        
        guard let data = data else {
            self = .error(NetworkError.noData)
            return
        }
        
        switch request.responseType {
        case .Data:
            self = .data(data)
        case .JSON:
            var json:JSON = JSON(parseJSON: "")
            do {
                json = try JSON(data: data)
            } catch {
                print(error)
            }
            self = .json(json)
        }
    }
}
