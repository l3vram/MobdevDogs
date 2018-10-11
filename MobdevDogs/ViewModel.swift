//
//  ViewModel.swift
//  MobdevDogs
//
//  Created by Marvel Alvarez Rojas on 09/10/2018.
//  Copyright © 2018 Marvel Alvarez Rojas. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

let imageCache = AutoPurgingImageCache(
    memoryCapacity: 100 * 1024 * 1024,
    preferredMemoryUsageAfterPurge: 40 * 1024 * 1024
)

class ViewModel{
    
    let urlDogList = "https://dog.ceo/api/breeds/list"
    let urlDogImages = "https://dog.ceo/api/breed/"
    let urlEndImg = "/images"
    
    
    
    func BreedList(url: String,completionHandler: @escaping (Doglist?,Error?)-> Void) {
        var dogl: Doglist?
        Alamofire.request(url).responseData{response in
            do{
                switch response.result{
                case .success(let data):
                    dogl = try JSONDecoder().decode(Doglist.self, from: data)
                    completionHandler(dogl!,nil)
                    
                case .failure(let error):
                    completionHandler(nil,error)
                }
            }catch let error{
                completionHandler(nil,error)
            }      
        }
    }
}
extension UIViewController {
    
    func Alert(tittle: String, message: String){
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func Heigth()-> CGSize{
        let heigth = (view.frame.size.width - 26) / 3
        return CGSize(width: heigth, height: heigth)
    }
    func SetImage(url: URL, completion: @escaping (UIImage?,Error?)-> Void){
       
        let filter = AspectScaledToFillSizeFilter(size: Heigth())
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        if let tempimg = imageCache.image(for: URLRequest(url: url)){
            completion(tempimg,nil)
        }else{
            imageview.af_setImage(withURL: url,filter: filter,imageTransition: .crossDissolve(0.2) , completion: { response in
                if response.result.isSuccess {
                    if let i = imageview.image{
                        completion(i,nil)
                        imageCache.add(i, for: URLRequest(url: url))
                    }
                }else{
                   completion(nil,response.result.error)
                }
            })
        }
    
    }   
}
