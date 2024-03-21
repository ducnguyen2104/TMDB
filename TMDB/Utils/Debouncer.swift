//
//  Debouncer.swift
//  TMDB
//
//  Created by LAP15284 on 20/03/2024.
//

import Foundation

public class Debouncer: NSObject {
    
    public var workItem: DispatchWorkItem?
    private var delay: TimeInterval

    public init(delay: TimeInterval) {
        self.delay = delay
    }
    
    public func run(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
