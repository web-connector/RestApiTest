//
//  PostsCell.swift
//  ForATeams
//
//  Created by Павел on 20.10.2017.
//  Copyright © 2017 Павел. All rights reserved.
//

import UIKit

class PostsCell: UICollectionViewCell {

    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var postId: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var goTo: UITextField!
    
    var dataLoaded = false
    
    func loadDataFromJson(){
        
        if dataLoaded {
            return
        }
        
        dataLoaded = true
        
        let loadingView = Bundle.main.loadNibNamed("loadingView", owner: self, options: nil)?[0] as! UIView
        addSubview(loadingView)
        loadingView.frame = self.bounds
        loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        var goToText = self.goTo.text!
        
        if goToText == "" || Int(goToText)! <= 0 {
            goToText = "1"
            self.goTo.text = goToText
        }
        else if Int(goToText)! > 100 {
            goToText = "100"
            self.goTo.text = goToText
        }
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/"+goToText)!)
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
                        
                        self.postId.text = "#" + String(json!["id"] as! Int)
                        self.userId.text = "user: " + String(json!["userId"] as! Int)
                        self.title.text = json!["title"] as? String
                        self.body.text = json!["body"] as? String
                        
                        loadingView.removeFromSuperview()
                    }
                }
                
            }
            else{
                print("Ошибка на странице json")
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
            }
            
        }
        
    }
    
    @IBAction func goToAction(_ sender: Any) {
        dataLoaded = false
        endEditing(true)
        loadDataFromJson()
    }
    
}
