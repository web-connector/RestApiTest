//
//  PhotoCell.swift
//  ForATeams
//
//  Created by Павел on 20.10.2017.
//  Copyright © 2017 Павел. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
   
    var dataLoaded = false
    var cache:NSCache<NSString, UIImage>!
    
    func loadDataFromJson(){
        
        if dataLoaded {
            return
        }
        
        dataLoaded = true

        self.cache = NSCache()
        
        let loadingView = Bundle.main.loadNibNamed("loadingView", owner: self, options: nil)?[0] as! UIView
        addSubview(loadingView)
        loadingView.frame = self.bounds
        loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/photos/3")!)
        request.httpMethod = "GET"
        
        FirstViewController.httpConnection(request: request) { (ok, data) in
            if(!ok){
                print("Ошибка соединения")
                return
            }
            
            
            if let json = try? JSONSerialization.jsonObject(with: data!) as? [String : Any]{
                
                if(json==nil){
                    print("Ошибка при парсинге json")
                    print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                    return
                }
                else {
                    DispatchQueue.main.async {
                        
                        if json!.count == 0 {
                            print("Ошибка пустой массив json")
                            return
                        }
                        
                        self.button.tag = json!["id"] as! Int
                        self.button.setTitle(json!["title"] as? String, for: .normal)
                        
                        loadingView.removeFromSuperview()
                    }
                    
                    self.Downloadimage(img: (self.image)!, url: (json!["url"] as? String)!)
                }
                
            }
            else{
                print("Ошибка на странице json")
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
            }
            
        }
        
    }
    
    func Downloadimage(img: UIImageView, url: String)
    {
        let imageInCahe = self.cache.object(forKey: url as NSString)
        
        //Проверить кэш
        if imageInCahe != nil {
            
            DispatchQueue.main.async {
                img.image = imageInCahe
            }
        }
        else{
            //Скачать изображение, если его нет в кэше
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            FirstViewController.httpConnection(request: request) { (ok, data) in
                
                if !ok {
                    print("Не удалось скачать изображение",url)
                    return
                }
                
                if let img_tmp = UIImage(data: data!) {
                    
                    DispatchQueue.main.async {
                        //Поместить в кэш
                        self.cache.setObject(img_tmp, forKey: url as NSString)
                        img.image = img_tmp
                        
                        //Обновить collection view в FirstViewController
                        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Update"), object: nil)
                    }
                   
                }
            }

        }
    }
    
}
