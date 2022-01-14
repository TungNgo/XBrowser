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
        
        self.addressTextField.delegate = self
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
        
        viewModel.$faviconUrl.map { url -> UIImage? in
            guard let url = url else {
                return UIImage(systemName: "globe")
                  }
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data) ?? UIImage(systemName: "globe")
            } catch {
                return UIImage(systemName: "globe")
            }
        }
        .receive(on: RunLoop.main)
        .assign(to: \.image, on: faviconImageView)
        .store(in: &cancellables)
        
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        switch sender {
        case backButton:
            viewModel.isGoingBack = ()
        case forwardButton:
            viewModel.isGoingForward = ()
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

extension ToolbarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.submitUrl = textField.text
        return true
    }
}
