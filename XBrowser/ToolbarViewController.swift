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
    weak var delegate: WebViewControllerDelegate?
    
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
        
        viewModel.$faviconURL
            .sink(receiveValue: { [self] result in
                guard let url = result
                else { return }
                self.faviconImageView.loadImage(assetOrUrl: url)
            })
            .store(in: &cancellables)
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        switch sender {
        case backButton:
            delegate?.didGoback()
            break
        case forwardButton:
            delegate?.didGoForward()
            break
        default:
            break
        }
    }
}

//MARK: UITextFieldDelegate
extension ToolbarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.goTextUrl(textField.text)
        self.view.endEditing(true)
        return true
    }
}
