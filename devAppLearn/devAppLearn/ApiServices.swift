//
//  ApiServices.swift
//  devAppLearn
//
//  Created by İsmail Karakaş on 18.10.2022.
//

import Foundation

class ApiServices{
   
    public func fetchDataWithPage( completion:@escaping (_ resultData:[Data], _ resultWallpaperList:[Photo])->Void, pageId:Int,category:String){
        var dataList:[Data] = []
        var wallpaperList:[Photo] = []
              let token = "563492ad6f917000010000011c2395465707473e8b0fd3eb321e8d35"
        
        var urlString = "https://api.pexels.com/v1/curated?page=\(pageId)&per_page=8"
      if category != "" {
          urlString = "https://api.pexels.com/v1/search?query=\(category)&page=\(pageId)&per_page=8"
      }
                    let url = URL(string: urlString)
                    var request = URLRequest(url: url!)
                    request.httpMethod = "GET"
                    request.setValue("\(token)", forHTTPHeaderField: "Authorization")
              
              let task = URLSession.shared.dataTask(with: request) { [self](data, response, error) in
                        
                        guard let data = data else {
                            return
                        }
                        do {
                            //let jsonResponse = try JSONSerialization.jsonObject(with: data,options: .mutableContainers)
                            let jsonData = try JSONDecoder().decode(Wallpaper.self,from:data)
                            //print(jsonData),
                            wallpaperList = jsonData.photos.lazy.elements

                            
                            dataList = self.convertImageData(wallpaperList: jsonData.photos.lazy.elements)
                            
                        }catch{
                            print(error)
                        }
                  completion(dataList,wallpaperList)

                    }
                    task.resume()
             
    }
//https://api.pexels.com/v1/search?query=\(categoryName)&page=\(6)&per_page=4
    func convertImageData(wallpaperList:[Photo]) -> [Data] {
        var dataList:[Data] = []
           for item in wallpaperList {
               do {
                   let data = try  Data(contentsOf: URL(string: item.src.portrait)! )
                   dataList.append(data)
                   
               } catch  {
                   print("error")
               }
               
           }
          return dataList
       }
}
