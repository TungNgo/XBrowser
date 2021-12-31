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
    @Published var submitUrl: String?
    @Published var isGoingBack: Void?
    @Published var isGoingForward: Void?
    @Published var faviconUrl: URL?
    
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
        
        model.$currentUrl
            .map { urlString -> URL? in
                guard let urlString = urlString,
                let url = URL(string: urlString),
                let host = url.host else {
                    return nil
                }
                return URL(string: "https://\(host)/favicon.ico")
            }
            .assign(to: \.faviconUrl, on: self)
            .store(in: &cancellables)
        
        self.$submitUrl
            .assign(to: \.submittedUrl, on: model)
            .store(in: &cancellables)
        
        self.$isGoingBack
            .receive(on: RunLoop.main)
            .assign(to: \.goBack, on: model)
            .store(in: &cancellables)
        
        self.$isGoingForward
            .receive(on: RunLoop.main)
            .assign(to: \.goForward, on: model)
            .store(in: &cancellables)
        
    }
}
