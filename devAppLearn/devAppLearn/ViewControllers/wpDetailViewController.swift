//
//  wpDetailViewController.swift
//  devAppLearn
//
//  Created by İsmail Karakaş on 19.06.2022.
//

import UIKit

class wpDetailViewController: UIViewController {

    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var wpImage: UIImageView!
    var portraitImgUrl:URL? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
       
        styleDownloadBtn()

    }
    
   

    @IBAction func downloadBtn(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.wpImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Successfully saved to gallery.", preferredStyle: .alert)
           
            ac.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .init(red: 0.220, green: 0.220, blue: 0.220, alpha: 0.8)
            
            ac.view.tintColor = .white
            ac.view.layer.masksToBounds = true
            ac.view.layer.cornerRadius = 10
            ac.view.layer.borderWidth = 2
            ac.view.layer.shadowOffset = CGSize(width: -1, height: 1)
            ac.view.layer.borderColor = .init(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)

            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    public func styleDownloadBtn(){
        downloadBtn.alpha = 0.8
        downloadBtn.layer.masksToBounds = true
        downloadBtn.layer.cornerRadius = 20
        downloadBtn.layer.borderWidth = 2
        downloadBtn.layer.shadowOffset = CGSize(width: -1, height: 1)
        downloadBtn.layer.borderColor = .init(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        
        if let prtImgUrl = portraitImgUrl {
            do {
                let data = try  Data(contentsOf: prtImgUrl )
                self.wpImage.image = UIImage(data: data)
               

            }catch {
                print("Image not converted")
            }
        }
    }

}
