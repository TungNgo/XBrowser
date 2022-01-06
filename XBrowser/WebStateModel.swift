//
//  WebState.swift
//  XBrowser
//
//  Created by tungngo on 12/26/21.
//

import Foundation

class WebStateModel {
    static let shared = WebStateModel()
    
    @Published var canGoBack = false {
        didSet {
            print("--- canGoBack WebStateModel: \(canGoBack)")
        }
    }
    @Published var canGoForward = false{
        didSet {
            print("--- canGoForward WebStateModel: \(canGoForward)")
        }
    }
    @Published var submittedUrl: String?
    @Published var currentUrl: String?
}
