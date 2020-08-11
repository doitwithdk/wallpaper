//
//  ViewController.swift
//  wallpaper
//
//  Created by DK on 11/08/20.
//  Copyright © 2020 doitwithdk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vwCollectionWallpaper: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()

    }
    
   func setupView() {
        self.vwCollectionWallpaper!.register(UINib(nibName: String(describing: WallpaperCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: WallpaperCell.self))
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
 
    
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
       let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
       let size:CGFloat = (vwCollectionWallpaper.frame.size.width - space) / 2.0
       return CGSize(width: size, height: 185)
   }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = vwCollectionWallpaper.dequeueReusableCell(withReuseIdentifier: String(describing: WallpaperCell.self), for: indexPath) as? WallpaperCell else {
            preconditionFailure("Unregistered collection view cell")
        }
        cell.configureCell(url: Constants.wallPaperURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
}

extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailViewController
        dest.wallpaperURL = Constants.wallPaperURL
    }
}


