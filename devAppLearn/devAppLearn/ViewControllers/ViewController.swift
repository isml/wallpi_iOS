//
//  ViewController.swift
//  devAppLearn
//
//  Created by İsmail Karakaş on 9.06.2022.
//

import UIKit

class ViewController: UIViewController {
    var wallpaperList:[Photo] = []
    var dataList:[Data] = []
    var scrollControl:Bool = true
    var scrollPageId:Int = 1
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    @IBAction func segmentedAction(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("ilk ekran")
            self.collectionView.isHidden = false
            self.categoriesView.isHidden = true
            
        case 1:
            self.collectionView.isHidden = true
            self.categoriesView.isHidden = false
            print("ikinci ekran")
            
        default:
            break;
        }
    }
    @IBAction func wpClick(_ sender: Any) {
        print("Click wp : ")
    }
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("getWallpapers çalıştı cell oluşturma \(indexPath.row) ")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallpapercell", for:  indexPath) as! WallPaperCellCollectionViewCell
        
        do {
            DispatchQueue.main.async {
                
                cell.wallpaperImage.image = UIImage(data: self.dataList[indexPath.row])
            }
            
            
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 2
            cell.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.layer.borderColor = .init(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
            //print("cell image setlemesi : \(cell.wallpaperImage.image)")
            
        }catch {
            print("Image not converted")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let wpDetailVCRef = storyBoard.instantiateViewController(withIdentifier: "wpDetailViewController") as! wpDetailViewController
        if let portraitImgUrl = URL(string: wallpaperList[indexPath.row].src.portrait){
            do {
                
                wpDetailVCRef.portraitImgUrl = portraitImgUrl
                self.present(wpDetailVCRef, animated: true, completion: nil)
                
            }catch {
                print("Image not converted")
            }
        }
        
        
        
        print("item clicked")
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > (collectionView.contentSize.height + 100 - scrollView.frame.size.height) {
            if self.scrollControl {
               
                self.scrollControl = false
                createSpinnerView()
                ApiServices().fetchDataWithPage(completion: { resultData, resultWallpaperList in
                    self.dataList.append(contentsOf: resultData)
                    self.wallpaperList.append(contentsOf: resultWallpaperList)
                    
                               DispatchQueue.main.async {
                                   self.collectionView.scrollsToTop = true
                                   self.collectionView.reloadData()
                                   
                                   
                               }
                }, pageId: self.scrollPageId,category: "")
                self.scrollPageId += 1

            }
            
        }else{
            self.scrollControl = true
        }
    }
    
    func convertImageData(){
        for item in self.wallpaperList {
            do {
                let data = try  Data(contentsOf: URL(string: item.src.portrait)! )
                dataList.append(data)
                
            } catch  {
                print("error")
            }
            
        }
    }
    func createSpinnerView() {
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    public func styleCollectionView(){
        let collectionViewDesign:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = self.view.frame.width
        let cvSizeWidth = self.collectionView.frame.width
        collectionViewDesign.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        print("width : \(self.view.frame.width)")
        collectionViewDesign.itemSize = CGSize(width: (screenWidth - 30)/2, height: (screenWidth - 30)/2*1.6)
        collectionViewDesign.minimumLineSpacing = 10
        collectionViewDesign.minimumInteritemSpacing = 10
        collectionView!.collectionViewLayout = collectionViewDesign
    }

}

