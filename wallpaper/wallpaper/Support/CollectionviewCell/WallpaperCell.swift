//
//  WallpaperCell.swift
//  wallpaper
//
//  Created by DK on 11/08/20.
//  Copyright © 2020 doitwithdk. All rights reserved.
//

import UIKit
import SDWebImage

class WallpaperCell: UICollectionViewCell {

    @IBOutlet weak var imgWallpaper: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(url: String){
        imgWallpaper.setShowActivityIndicator(true)
        imgWallpaper.setIndicatorStyle(.medium)
        imgWallpaper.sd_setImage(with: URL(string: url),completed: nil)
    }

}
