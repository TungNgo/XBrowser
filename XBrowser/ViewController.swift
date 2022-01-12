//
//  ViewController.swift
//  XBrowser
//
//  Created by tungngo on 12/25/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet private weak var btnImagesFounded: UIButton!
    
    var webState = WebStateModel.shared
    
    var toolbarViewController: ToolbarViewController!
    var webViewController: WebViewController!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webState.submittedUrl = "https://www.apple.com"
        
        let imageFounded = webState.$imageSourcesFounded.share()
        imageFounded.map { $0.count == 0 }
        .assign(to: \.isHidden, on: self.btnImagesFounded)
        .store(in: &cancellables)
        
        imageFounded.map { sources -> String in
            let numOfSources = sources.count
            if numOfSources <= 1 {
                return "\(numOfSources) image found"
            }
            return "\(numOfSources) images found"
        }
        .receive(on: RunLoop.main)
        .sink { [weak self] text in
            self?.btnImagesFounded.setTitle(text, for: .normal)
        }
        .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnImagesFounded.layer.masksToBounds = true
        self.btnImagesFounded.layer.cornerRadius = self.btnImagesFounded.bounds.height / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let viewController as WebViewController:
            self.webViewController = viewController
            self.webViewController.viewModel = WebViewModel(model: webState)
        case let viewController as ToolbarViewController:
            self.toolbarViewController = viewController
            self.toolbarViewController.viewModel = ToolbarViewModel(model: webState)
//            self.toolbarViewController.delegate = self
        case let naviVC as UINavigationController:
            guard let imageListVC = naviVC.viewControllers.first as? ImageListViewController else {
                return
            }
            imageListVC.viewModel = ImageListViewModel(model: webState)
//            self.toolbarViewController.delegate = self
        default: break
        }
    }
}
