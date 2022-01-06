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
    }
}
