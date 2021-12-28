//
//  ToolbarViewController.swift
//  XBrowser
//
//  Created by tungngo on 12/26/21.
//

import Combine
import UIKit

class ToolbarViewController: UIViewController {

  var viewModel: ToolbarViewModel!

  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var forwardButton: UIButton!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var faviconImageView: UIImageView!

  @IBOutlet weak var addressContainerView: UIView!

  var cancellables = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()

    addressContainerView.layer.borderColor = UIColor.lightGray.cgColor
    addressContainerView.layer.borderWidth = 1
    addressContainerView.layer.cornerRadius = 16

    viewModel.$backButtonEnabled
      .assign(to: \.isEnabled, on: backButton)
      .store(in: &cancellables)

    viewModel.$forwardButtonEnabled
      .assign(to: \.isEnabled, on: forwardButton)
      .store(in: &cancellables)

    viewModel.$url
      .assign(to: \.text, on: addressTextField)
      .store(in: &cancellables)
  }

  @IBAction func didTapButton(_ sender: UIButton) {
    switch sender {
    case backButton:
      break
    case forwardButton:
      break
    default:
      break
    }
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
