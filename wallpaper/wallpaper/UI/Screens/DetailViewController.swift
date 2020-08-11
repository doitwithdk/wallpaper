//
//  DetailViewController.swift
//  wallpaper
//
//  Created by DK on 11/08/20.
//  Copyright © 2020 doitwithdk. All rights reserved.
//

import UIKit
import Toast_Swift

class DetailViewController: UIViewController {

    @IBOutlet weak var imgWallpaper: UIImageView!
    var wallpaperURL: String?
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblDimension: UILabel!
    
    var originalImage: UIImage?
    
    //for pinch zoom support
    var zoomView: UIImageView?
    var currentOriginalZoomedImage: UIImageView?
    var frameMap = [UIImageView: CGPoint]()
    var overlay: UIView = {
      let view = UIView(frame: UIScreen.main.bounds);
      
      view.alpha = 0
      view.backgroundColor = .black
      
      return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    func setupView() {
        imgWallpaper.setShowActivityIndicator(true)
        imgWallpaper.setIndicatorStyle(.medium)
        imgWallpaper.sd_setImage(with: URL(string: wallpaperURL!)) { (image, error, type, url) in
            if error == nil{
                self.originalImage = image
                self.displayImageProperTies(image: image!)
            }else{
                self.lblSize.text = "Error"
                self.lblDimension.text = "Error"
                self.view.makeToast("Could not load image.")
            }
        }
        setupPinchAndZoom(for: imgWallpaper)
    }
    
    @IBAction func segmentQualityChanged(_ sender: UISegmentedControl) {
        
         if let theImage = originalImage{
        switch sender.selectedSegmentIndex {
        case 0:
                imgWallpaper.image = theImage
                displayImageProperTies(image: theImage)
        default:
            let imgData = NSData(data: originalImage!.jpegData(compressionQuality: CGFloat(sender.selectedSegmentIndex) * 0.25)!)
            let image = UIImage(data: imgData as Data)
            imgWallpaper.image = image
            displayImageProperTies(image: image!)
        }
         }else{
            self.view.makeToast("Wait for the image to be downloaded.")

        }
    }
    
    
    
    func displayImageProperTies(image: UIImage) {
        let heightInPoints = image.size.height
        let heightInPixels = heightInPoints * image.scale

        let widthInPoints = image.size.width
        let widthInPixels = widthInPoints * image.scale

        self.lblDimension.text = "\(widthInPixels) X \(heightInPixels)"
        
        let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
        let imageSize: Int = imgData.count
        self.lblSize.text = "\(Double(imageSize) / 1000.0) Kb"
    }


}


extension DetailViewController{
    func setupPinchAndZoom(for imageView: UIImageView) {
        frameMap[imageView] = imageView.center
        imageView.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handleZoom))
         let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.minimumNumberOfTouches = 2
         pan.maximumNumberOfTouches = 2
        pan.delegate = self
        pinch.delegate = self
        imageView.addGestureRecognizer(pinch)
        imageView.addGestureRecognizer(pan)
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
  
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleZoom(_ gesture: UIPinchGestureRecognizer) {

        let sideOffset:CGFloat = 20
        let topOffset: CGFloat = 88
        
        if zoomView == nil{
            zoomView = UIImageView()
            self.view.addSubview(zoomView!)
            zoomView?.isHidden = true
            self.view.bringSubviewToFront(zoomView!)
            zoomView?.contentMode = .scaleAspectFit
            zoomView?.frame = CGRect(x: sideOffset, y:topOffset , width: gesture.view!.frame.width, height: gesture.view!.frame.height)
            zoomView?.image = (gesture.view as! UIImageView).image
            setupPinchAndZoom(for: zoomView!)
            zoomView?.isHidden = false
            currentOriginalZoomedImage = (gesture.view as! UIImageView)
            currentOriginalZoomedImage?.isHidden = true
        }
        if gesture.view != zoomView{
            return
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        switch gesture.state {
        case .began, .changed:
            
            if gesture.scale >= 1 {
              
                let scale = gesture.scale
                gesture.view!.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
                      
            break;
        default:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
              gesture.view!.transform = .identity
            }) { _ in
                self.zoomView?.isHidden = true
                self.zoomView = nil
                self.currentOriginalZoomedImage?.isHidden = false
                self.navigationController?.setNavigationBarHidden(false, animated: true)

            }
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let sideOffset:CGFloat = 20
        let topOffset: CGFloat = 88
        
        if zoomView == nil{
            zoomView = UIImageView()
            self.view.addSubview(zoomView!)
            zoomView?.isHidden = true
            self.view.bringSubviewToFront(zoomView!)
            zoomView?.contentMode = .scaleAspectFit
            zoomView?.frame = CGRect(x: sideOffset, y:topOffset , width: gesture.view!.frame.width, height: gesture.view!.frame.height)
            zoomView?.image = (gesture.view as! UIImageView).image
            setupPinchAndZoom(for: zoomView!)
            zoomView?.isHidden = false
            currentOriginalZoomedImage = (gesture.view as! UIImageView)
            currentOriginalZoomedImage?.isHidden = true
        }
        if gesture.view != zoomView{
            return
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        switch gesture.state {
        case .began, .changed:
            let translation = gesture.translation(in: gesture.view)
            
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y + translation.y)
            gesture.setTranslation(.zero, in: gesture.view)

            UIView.animate(withDuration: 0.2) {
                self.overlay.alpha = 0.8
            }
            break;
        default:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                gesture.view!.center = self.frameMap[gesture.view as! UIImageView]!
            }) { _ in
              UIView.animate(withDuration: 0.2) {
                self.overlay.alpha = 0
              }
                self.zoomView?.isHidden = true
                self.zoomView = nil
                self.currentOriginalZoomedImage?.isHidden = false
                self.navigationController?.setNavigationBarHidden(false, animated: true)

            }
            break
        }
    }
}
