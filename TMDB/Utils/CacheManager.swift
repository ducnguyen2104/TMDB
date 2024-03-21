//
//  CacheManager.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

class CacheManager {
    private static let kimageBasePath = "img_base_path"
    private static let kposterSizes = "poster_sizes"
    
    class func getImageBasePath() -> String? {
        return UserDefaults.standard.value(forKey: kimageBasePath) as? String
    }
    
    class func storeImageBasePath(value: String) {
         UserDefaults.standard.set(value, forKey: kimageBasePath)
    }
    
    class func getPosterSizes() -> [String] {
        return UserDefaults.standard.value(forKey: kposterSizes) as? [String] ?? [ ]
    }
    
    class func getBestPosterSize(size: CGFloat) -> String? {
        let posterSizes = getPosterSizes()
        let best = posterSizes.min(by: {
            var firstStr = $0
            firstStr.remove(at: firstStr.startIndex)
            var secondStr = $1
            secondStr.remove(at: secondStr.startIndex)
            if let n1 = NumberFormatter().number(from: firstStr),
               let n2 = NumberFormatter().number(from: secondStr) {
                let f1 = CGFloat(truncating: n1)
                let f2 = CGFloat(truncating: n2)
                return abs(f1 - size) < abs(f2 - size)
            }
            return false
        })
        return best
    }
    
    class func storePosterSizes(value: [String]) {
         UserDefaults.standard.set(value, forKey: kposterSizes)
    }
}
