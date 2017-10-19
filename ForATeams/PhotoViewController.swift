//
//  PhotoViewController.swift
//  ForATeams
//
//  Created by Павел on 20.10.2017.
//  Copyright © 2017 Павел. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return image
    }
    

    @IBAction func closeButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func LoadDataFromJson(photoId: Int){
        
        let loadingView = Bundle.main.loadNibNamed("loadingView", owner: self, options: nil)?[0] as! UIView
        view.addSubview(loadingView)
        loadingView.frame = self.view.bounds
        loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/photos/"+String(photoId))!)
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

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        FirstViewController.httpConnection(request: request) { (ok, data) in
            
            if let img_tmp = UIImage(data: data!) {
                
                DispatchQueue.main.async {
                    img.image = img_tmp
                }
                
            }
        }    
    }

}
