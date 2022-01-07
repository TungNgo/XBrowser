//
//  ToolbarViewModel.swift
//  XBrowser
//
//  Created by tungngo on 12/28/21.
//

import Combine
import Foundation

class ToolbarViewModel {
    private var model: WebStateModel
    
    @Published var backButtonEnabled = false
    @Published var forwardButtonEnabled = false
    @Published var url: String?
    @Published var faviconURL: String?
    
    var cancellables = Set<AnyCancellable>()
    
    init(model: WebStateModel) {
        self.model = model
        
        model.$currentUrl
            .receive(on: RunLoop.main)
            .assign(to: \.url, on: self)
            .store(in: &cancellables)
        
        model.$canGoBack
            .receive(on: RunLoop.main)
            .assign(to: \.backButtonEnabled, on: self)
            .store(in: &cancellables)
        
        model.$canGoForward
            .receive(on: RunLoop.main)
            .assign(to: \.forwardButtonEnabled, on: self)
            .store(in: &cancellables)
        
        self.$url
            .map({ result in
                guard let url = result,
                      let _URL = URL(string: url)
                else { return nil }
                let hostURL = _URL.host
                let faviconURL = "http://\(hostURL ?? "")/favicon.ico"
                return faviconURL
            })
            .assign(to: \.faviconURL, on: self)
            .store(in: &cancellables)
    }
}
