//
//  WebViewController.swift
//  XBrowser
//
//  Created by tungngo on 12/25/21.
//

import Combine
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    @IBOutlet private weak var btnImagesFounded: UIButton!
    var viewModel: WebViewModel!
    
    var webView: WKWebView!
    
    var cancellables = Set<AnyCancellable>()
    
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
                      let _URL = URL(string: url),
                      self.webView.url?.absoluteString != url
                else { return }
                let request = URLRequest(url: _URL)
                webView.load(request)
            })
            .store(in: &cancellables)
        
        viewModel.$isGoingBack
            .sink { [weak self] isGoing in
                guard isGoing != nil && self?.webView.canGoBack ?? false else { return }
                self?.webView.stopLoading()
                self?.webView.goBack()
            }.store(in: &cancellables)
        
        viewModel.$isGoingForward
            .sink { [weak self] isGoing in
                guard isGoing != nil && self?.webView.canGoForward ?? false else { return }
                self?.webView.stopLoading()
                self?.webView.goForward()
            }.store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script = """
                    function getAllImages() {
                          var sources = [];
                          for(var i = 0; i< document.images.length; i++) {
                            sources.push(document.images[i].src)
                          }
                          return sources
                    }
                    getAllImages()
                    """
        webView.evaluateJavaScript(script) { results, error in
            guard let results = results as? [String] else {
                return
            }
            let imageSrcs = results.filter { src in
                return src.hasPrefix("http") && (src.hasSuffix("png") || src.hasSuffix("jpg") || src.hasSuffix("jpeg"))
            }
            self.viewModel.imageSources = Array(Set(imageSrcs))
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.viewModel.imageSources = []
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard var url = webView.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        if url.contains(".com/amp/s/") {
            let components = url.components(separatedBy: "/s/")
            if let lastComponent = components.last {
                url = "https://\(lastComponent)"
            }
        }
        viewModel.url = url
        decisionHandler(.allow)
     }
}

extension NSURLRequest {
    static func allowsAnyHTTPSCertificateForHost(host: String) -> Bool {
        return true
    }
}
