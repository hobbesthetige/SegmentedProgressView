//
//  ProgressItem.swift
//  Pods
//
//  Created by Sapozhnik Ivan on 12/05/17.
//
//

import Foundation

open class ProgressItem {
    
    public typealias CompletionHandler = () -> ()
    
    let duration: Double
    let progress: Double
    let handler: CompletionHandler?
    
    public init(duration: Double, progress: Double = 1, handler completion: CompletionHandler? = nil) {
        self.duration = duration
        self.progress = progress
        self.handler = completion
    }
}
