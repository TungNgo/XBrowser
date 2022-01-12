//
//  ImageListViewModel.swift
//  XBrowser
//
//  Created by Lan Thien on 12/01/2022.
//

import Combine
import Foundation
import UIKit

class ImageListViewModel {
    private var model: WebStateModel
    
    @Published var imageList: [(UIImage?, String, String)] = []
    
    var cancellables = Set<AnyCancellable>()
    private let loadImageGroup = DispatchGroup()
    
    init(model: WebStateModel) {
        self.model = model
        
        
        model.$imageSourcesFounded
            .sink { [weak self] imageUrls in
                let numOfImageUrl = imageUrls.count
                self?.imageList = Array(repeating: (nil, "?kB", ""), count: numOfImageUrl)
                for index in 0..<numOfImageUrl {
                    self?.loadImageGroup.enter()
                    self?.loadImageByURL(imageUrls[index]) { [weak self] (image, size, address) in
                        guard let self = self else {
                            self?.loadImageGroup.leave()
                            return
                        }
                        self.imageList[index] = (image, size, address)
                        self.loadImageGroup.leave()
                    }
                }
            }
            .store(in: &cancellables)
        
        self.loadImageGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else {
                return
            }
            let errorImage = self.imageList.filter { $0.0 == nil }
            guard errorImage.count > 0 else {
                return
            }
            self.imageList.removeAll(where: { $0.0 == nil })
            self.imageList.append(contentsOf: errorImage)
        }
    }
    
    func loadImageByURL(_ urlString: String, _ completion: ((UIImage?, String, String) -> Void)?) {
        guard let url = URL(string: urlString) else {
            completion?(nil, "?kb", urlString)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                completion?(nil, "?kb", urlString)
                return
            }
            completion?(UIImage(data: data), String(format: "%0.2fkB", Double(data.count) / 1000.0), urlString)
        }.resume()
        
    }
}
