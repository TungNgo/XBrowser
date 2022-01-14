//
//  ImageListTableViewCell.swift
//  XBrowser
//
//  Created by Lan Thien on 11/01/2022.
//

import UIKit

class ImageListTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(imageUrl: UIImage?, title: String) {
        self.thumbnail.image = imageUrl ?? UIImage(systemName: "globe")
        self.title.text = title
    }
    
}
