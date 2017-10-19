//
//  CommentsCell.swift
//  ForATeams
//
//  Created by Павел on 20.10.2017.
//  Copyright © 2017 Павел. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var goTo: UITextField!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var postId: UILabel!
    
    var dataLoaded = false
    
    func loadDataFromJson(){
        
        //Чтобы при скролинге страницы не было лишних запросов к серверу
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
        else if Int(goToText)! > 500 {
            goToText = "500"
            self.goTo.text = goToText
        }

        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/comments/"+goToText)!)
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
                        
                        self.id.text = "#" + String(json!["id"] as! Int)
                        self.postId.text = "This comment to post with id: " + String(json!["postId"] as! Int)
                        self.name.text = json!["name"] as? String
                        self.email.text = json!["email"] as? String
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
