//
//  TodosCellCollectionViewCell.swift
//  ForATeams
//
//  Created by Павел on 20.10.2017.
//  Copyright © 2017 Павел. All rights reserved.
//

import UIKit

class TodosCell: UICollectionViewCell {
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var completed: UISwitch!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var dataLoaded = false
    
    func loadDataFromJson(){
        
        refreshButton.layer.shadowColor = UIColor.lightGray.cgColor
        refreshButton.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        refreshButton.layer.shadowOpacity = 0.5
        refreshButton.layer.shadowRadius = 1.0
        refreshButton.layer.masksToBounds = false
        
        if dataLoaded {
            return
        }
        
        dataLoaded = true
        
        let loadingView = Bundle.main.loadNibNamed("loadingView", owner: self, options: nil)?[0] as! UIView
        addSubview(loadingView)
        loadingView.frame = self.bounds
        loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let randomNum:UInt32 = arc4random_uniform(199)+1
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/"+String(randomNum))!)
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

                        self.userId.text = "user: " + String(json!["userId"] as! Int)
                        self.title.text = json!["title"] as? String
                        self.completed.isOn = (json!["completed"] as? Bool)!
                        
                        if self.completed.isOn {
                            self.id.text = "#" + String(json!["id"] as! Int)+" completed"
                        }
                        else {
                            self.id.text = "#" + String(json!["id"] as! Int)+" not completed"
                        }
                        
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
    
    @IBAction func refresh(_ sender: Any) {
        dataLoaded = false
        loadDataFromJson()
    }
    
}
