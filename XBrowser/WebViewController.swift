//
//  WebViewController.swift
//  XBrowser
//
//  Created by tungngo on 12/25/21.
//

import Combine
import UIKit
import WebKit

@objc protocol WebViewControllerDelegate {
    func didGoback()
    func didGoForward()
    func goTextUrl(_ url: String? )
}

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var viewModel: WebViewModel!
    
    var webView: WKWebView!
    
    var cancellables = Set<AnyCancellable>()
    private var isTapToolbar: Bool = false
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
        
        webView.publisher(for: \WKWebView.canGoBack)
            .assign(to: \.canGoBack, on: viewModel)
            .store(in: &cancellables)

        webView.publisher(for: \WKWebView.canGoForward)
            .assign(to: \.canGoForward, on: viewModel)
            .store(in: &cancellables)
        
        webView.publisher(for: \WKWebView.url)
            .map { $0?.absoluteString }
            .assign(to: \.url, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$url
            .sink(receiveValue: { [self] url in
                guard let url = url,
                      let _URL = URL(string: url)
                else { return }
                let request = URLRequest(url: _URL)
                if !isTapToolbar {
                    webView.load(request)
                }
            })
            .store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WebViewController: WebViewControllerDelegate {
    func goTextUrl(_ url: String?) {
        guard let url = url,
              let _URL = URL(string: url)
        else { return }
        isTapToolbar = true
        let request = URLRequest(url: _URL)
        webView.load(request)
    }
    
    func didGoback() {
        isTapToolbar = true
        webView.goBack()
    }
    
    func didGoForward() {
        isTapToolbar = true
        webView.goForward()
    }
}
