//
//  UsersCell.swift
//  ForATeams
//
//  Created by Павел on 20.10.2017.
//  Copyright © 2017 Павел. All rights reserved.
//

import UIKit

class UsersCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var usersArr: [[String:Any]]!
    var dataLoaded = false

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if usersArr == nil {
            return 0
        }
        else {
            return usersArr.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "Row", for: indexPath) as? UsersRow
        cell?.userName.setTitle(usersArr[indexPath.item]["name"] as? String, for: .normal)
        cell?.userName.tag = usersArr[indexPath.item]["id"] as! Int
        return cell!


    }
    
    func loadDataFromJson(){
        
        if dataLoaded {
            return
        }
        
        dataLoaded = true
        
        let loadingView = Bundle.main.loadNibNamed("loadingView", owner: self, options: nil)?[0] as! UIView
        addSubview(loadingView)
        loadingView.frame = self.bounds
        loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        //Ограничиваем с помощью _limit количество строк, чтобы не тянуть на клиент весь массив
        //СМ. https://github.com/typicode/json-server/blob/master/README.md#paginate
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users/?_limit=5")!)
        request.httpMethod = "GET"
        
        FirstViewController.httpConnection(request: request) { (ok, data) in
            if(!ok){
                print("Ошибка соединения")
                return
            }
            
            
            if let json = try? JSONSerialization.jsonObject(with: data!) as? [[String : Any]]{
                
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
                        
                        self.usersArr = json
                        self.tableView.reloadData()
                    }
                }
                
            }
            else{
                print("Ошибка на странице json")
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
            }
            
        }
        
    }
    
    
}
