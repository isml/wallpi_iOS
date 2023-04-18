//
//  categoriesVC.swift
//  devAppLearn
//
//  Created by İsmail Karakaş on 29.06.2022.
//

import UIKit

class categoriesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    let categories = ["abstract","sea","night","nature","art","creatives","animals","minimalism"]
    let categoriesImgUrls = [
    "https://img.freepik.com/free-vector/multicolored-abstract-background_23-2148463672.jpg?w=2000",
    "https://thumbs.dreamstime.com/b/sea-water-ocean-wave-surfing-surface-colorful-vibrant-sunset-barrel-shape-124362369.jpg",
    "https://images.unsplash.com/photo-1488866022504-f2584929ca5f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bmlnaHR8ZW58MHx8MHx8&w=1000&q=80",
    "https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg",
    "https://www.pictureframesexpress.co.uk/blog/wp-content/uploads/2020/05/7-Tips-to-Finding-Art-Inspiration-Header-1024x649.jpg",
    "https://cms.qz.com/wp-content/uploads/2020/01/GettyImages-1177426181-1-e1579044448252.jpg?quality=75&strip=all&w=1600&h=900&crop=1",
    "https://images.unsplash.com/photo-1598755257130-c2aaca1f061c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8d2lsZCUyMGFuaW1hbHxlbnwwfHwwfHw%3D&w=1000&q=80",
    "https://images.theconversation.com/files/386440/original/file-20210225-17-10rcki4.jpg?ixlib=rb-1.1.0&q=20&auto=format&w=320&fit=clip&dpr=2&usm=12&cs=strip",
    ]
    var dataList:[Data] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      
        styleCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        convertImageData()
      
    }


}
extension categoriesVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("getWallpapers çalıştı cell oluşturma \(indexPath.row) ")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriescell", for:  indexPath) as! CategoriesViewCell
        
        do {
            
         
            if !dataList.isEmpty {
                DispatchQueue.main.async {
                    
                    cell.categoryImage.image = UIImage(data:self.dataList[indexPath.row])
                    
                }
            }
           
            cell.categoryLabel.text = categories[indexPath.row].uppercased()
            
            
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
        categories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let categoryWpVC = storyBoard.instantiateViewController(withIdentifier: "categorywallpapervc") as! CategoryWallpapersVC
        categoryWpVC.modalPresentationStyle = .fullScreen
        categoryWpVC.categoryName = categories[indexPath.row]
        self.present(categoryWpVC, animated: true, completion: nil)
    
    }
    func convertImageData(){
        print("convert item data çalıştı")
        for item in self.categoriesImgUrls {
            do {
                let data = try  Data(contentsOf: URL(string: item)! )
                dataList.append(data)
                
            } catch  {
                print("error")
            }
            
        }
    }
    public func styleCollectionView(){
        let collectionViewDesign:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = self.view.frame.width
        let cvSizeWidth = self.collectionView.frame.width
        collectionViewDesign.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        print("width : \(self.view.frame.width)")
        collectionViewDesign.itemSize = CGSize(width: (screenWidth - 30), height: (screenWidth - 30)/2*1.2)
        collectionViewDesign.minimumLineSpacing = 10
        collectionViewDesign.minimumInteritemSpacing = 10
        collectionView!.collectionViewLayout = collectionViewDesign
    }
}
