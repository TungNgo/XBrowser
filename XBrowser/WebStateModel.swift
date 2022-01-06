//
//  WebState.swift
//  XBrowser
//
//  Created by tungngo on 12/26/21.
//

import Foundation

class WebStateModel {
    static let shared = WebStateModel()
    
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var submittedUrl: String?
    @Published var currentUrl: String?
}
