//
//  ViewController.swift
//  XBrowser
//
//  Created by tungngo on 12/25/21.
//

import UIKit

class ViewController: UIViewController {
  var webState = WebStateModel()

  var toolbarViewController: ToolbarViewController!
  var webViewController: WebViewController!

  override func viewDidLoad() {
    super.viewDidLoad()

    webState.submittedUrl = "https://www.apple.com"
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let viewController as WebViewController:
      self.webViewController = viewController
      self.webViewController.viewModel = WebViewModel(model: webState)
    case let viewController as ToolbarViewController:
      self.toolbarViewController = viewController
      self.toolbarViewController.viewModel = ToolbarViewModel(model: webState)
    default: break
    }
  }
}
