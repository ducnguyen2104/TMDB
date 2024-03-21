//
//  StartupHelper.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

class StartupHelper {
    private init() { }
    
    static let shared = StartupHelper()
    
    private var networkDispatcher: NetworkDispatcher {
        let target = Target(host: "https://api.themoviedb.org")
        return NetworkDispatcher(target: target)
    }
    
    func getConfig(success: (() -> Void)? = nil) {
        GetConfigTask().execute(
            in: networkDispatcher,
            success: { config in
                CacheManager.storeImageBasePath(value: config.imageBaseUrl)
                CacheManager.storePosterSizes(value: config.posterSizes)
                success?()
            },
            failure: { error in
                
            })
    }
}
