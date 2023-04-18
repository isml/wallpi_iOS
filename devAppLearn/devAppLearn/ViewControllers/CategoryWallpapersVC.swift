//
//  CategoryWallpapersVC.swift
//  devAppLearn
//
//  Created by İsmail Karakaş on 30.06.2022.
//

import UIKit

class CategoryWallpapersVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var categoryName:String = ""
    var wallpaperList:[Photo] = []
    var dataList:[Data] = []
    
    var scrollControl:Bool = true
    var scrollPageId:Int = 1
    
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        backBtn.alpha = 0.8
        backBtn.layer.masksToBounds = true
        backBtn.layer.cornerRadius = 25
        backBtn.layer.borderWidth = 2
        backBtn.layer.shadowOffset = CGSize(width: -1, height: 1)
        backBtn.layer.borderColor = .init(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        
        let collectionViewDesign:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = self.view.frame.width
        let cvSizeWidth = self.collectionView.frame.width
        collectionViewDesign.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        print("width : \(self.view.frame.width)")
        collectionViewDesign.itemSize = CGSize(width: (screenWidth - 30)/2, height: (screenWidth - 30)/2*1.6)
        collectionViewDesign.minimumLineSpacing = 10
        collectionViewDesign.minimumInteritemSpacing = 10
        collectionView!.collectionViewLayout = collectionViewDesign
        
        //getWallPapers()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    public func getWallPapers(){

        let token = "563492ad6f917000010000019b1141fa420d46bb917fd27895e259e5"
        let url = URL(string: "https://api.pexels.com/v1/search?query=\(categoryName)&page=\(6)&per_page=4")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        print("getWallpapers çalıştı ")
        if wallpaperList.isEmpty {
            print("getWallpapers çalıştı is empty")
            
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                print("getWallpapers çalıştı task")
                
                guard let data = data else {
                    return
                }
                do {
                    //let jsonResponse = try JSONSerialization.jsonObject(with: data,options: .mutableContainers)
                    let jsonData = try JSONDecoder().decode(Wallpaper.self,from:data)
                    //print(jsonData),
                    
                    self.wallpaperList = jsonData.photos.lazy.elements
                    self.convertImageData()
                    //print(jsonData)
                    DispatchQueue.main.async {
                        print("reload data kısmı çalıştı")
                        self.collectionView.reloadData()
                        
                    }
                    
                    
                }catch{
                    print(error)
                }
                
            }
            task.resume()
        }
    }
}
extension CategoryWallpapersVC:UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
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
        wallpaperList.count
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
        if position > (collectionView.contentSize.height - scrollView.frame.size.height) {
            if self.scrollControl {
                print("fetch more")
                self.scrollControl = false
             createSpinnerView()
                ApiServices().fetchDataWithPage(completion: { resultData, resultWallpaperList in
                    self.dataList.append(contentsOf: resultData)
                    self.wallpaperList.append(contentsOf: resultWallpaperList)
                               DispatchQueue.main.async {
                                   self.collectionView.scrollsToTop = true
                                   self.collectionView.reloadData()
                                   
                               }
                }, pageId: self.scrollPageId,category: self.categoryName)
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
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
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
    
}

