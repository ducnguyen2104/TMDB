//
//  NetworkDispatcher.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

public class NetworkDispatcher: Dispatcher {
    private var target: Target
    private var session: URLSession
    private var currentTask: URLSessionDataTask?
    var timeoutInterval: TimeInterval = 60
    
    required public init(target: Target) {
        self.target = target
        self.session = URLSession.shared
    }
    
    public func execute(request: Request, response: @escaping ((Response) -> Void)) throws {
        var urlRequest = try repareForURLRequest(request: request)
        urlRequest.timeoutInterval = self.timeoutInterval
        
        currentTask?.cancel()
        currentTask = session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            response(Response(data: data,
                              urlResponse: urlResponse,
                              error: error,
                              forRequest: request))
        }
        currentTask?.resume()
    }
    
    public func cancel() {
        currentTask?.cancel()
    }
    
    private func repareForURLRequest(request: Request) throws -> URLRequest {
        //Compose URL
        let fullString: String
        if request.path.contains("http") {
            fullString = request.path
        } else {
            fullString = "\(target.host)\(request.path)"
        }
        guard let url = URL(string: fullString) else {
            throw NetworkError.badInput
        }
        
        var urlRequest = URLRequest(url: url)
        
        let apiKeyItem = URLQueryItem(name: "api_key", value: "47aa75b56464da7a186b813a50035cd4")
        
        //Params
        switch request.parameters {
            
        case .body(let params):
            if let params = params {
                urlRequest.httpBody = params.percentEncoded()
                guard var components = URLComponents(string: fullString) else {
                    throw NetworkError.badInput
                }
                if components.queryItems != nil {
                    components.queryItems!.append(apiKeyItem)
                } else {
                    components.queryItems = [apiKeyItem]
                }
                if let validStr = components.url?.absoluteString {
                    let newStr = validStr.replacingOccurrences(of: "+", with: "%2B")
                    urlRequest.url = URL(string: newStr)
                } else {
                    urlRequest.url = components.url
                }
            }
            
        case .url(let params):
            if let params = params {
                guard var components = URLComponents(string: fullString) else {
                    throw NetworkError.badInput
                }
                var queryItems = [URLQueryItem]()
                for param in params {
                    let item = URLQueryItem(name: param.key, value: "\(param.value)")
                    queryItems.append(item)
                }
                if components.queryItems != nil {
                    components.queryItems!.append(contentsOf: queryItems)
                } else {
                    components.queryItems = queryItems
                }
                components.queryItems?.append(apiKeyItem)
                if let validStr = components.url?.absoluteString {
                    let newStr = validStr.replacingOccurrences(of: "+", with: "%2B")
                    urlRequest.url = URL(string: newStr)
                } else {
                    urlRequest.url = components.url
                }
            }
        }
        
        //HTTP Header
        target.header.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
     
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        //HTTP Method
        urlRequest.httpMethod = request.method.rawValue
        
//        print("request: \(urlRequest.url?.absoluteString ?? "")")
        return urlRequest
    }
}
