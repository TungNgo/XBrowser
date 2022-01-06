//
//  ExtensionImageView.swift
//  XBrowser
//
//  Created by PTVH DBS 02 on 06/01/2022.
//

import UIKit

let imageCache = NSCache<AnyObject,AnyObject>()
extension UIImageView {
    
    func loadImage(assetOrUrl: String) {
        if let cachedImage = imageCache.object(forKey: assetOrUrl as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        if let imageAsset = UIImage(named: assetOrUrl) {
            self.image = imageAsset
            return
        }
        
        if let url:URL = URL(string: assetOrUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error ?? "")
                    return
                }
                DispatchQueue.main.async(execute: {
                    if let downloadImage = UIImage(data: data!) {
                        imageCache.setObject(downloadImage, forKey: assetOrUrl as AnyObject)
                        self.image = downloadImage
                    }
                })
            }).resume()
        }
    }
}
