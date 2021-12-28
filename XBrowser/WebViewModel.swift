//
//  WebViewModel.swift
//  XBrowser
//
//  Created by tungngo on 12/28/21.
//

import Combine
import Foundation

class WebViewModel {
  private var model: WebStateModel

  @Published var canGoBack = false
  @Published var canGoForward = false
  @Published var url: String?

  var cancellables = Set<AnyCancellable>()

  init(model: WebStateModel) {
    self.model = model

    model.$submittedUrl
      .receive(on: RunLoop.main)
      .assign(to: \.url, on: self)
      .store(in: &cancellables)

    self.$canGoBack
      .assign(to: \.canGoBack, on: model)
      .store(in: &cancellables)

    self.$canGoForward
      .assign(to: \.canGoForward, on: model)
      .store(in: &cancellables)

    self.$url
      .assign(to: \.currentUrl, on: model)
      .store(in: &cancellables)
  }
}
