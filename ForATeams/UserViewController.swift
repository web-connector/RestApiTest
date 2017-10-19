//
//  UserViewController.swift
//  ForATeams
//
//  Created by Павел on 20.10.2017.
//  Copyright © 2017 Павел. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phone: UITextView!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var website: UITextView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyCatchPhrase: UILabel!
    @IBOutlet weak var companyBs: UILabel!
    @IBOutlet weak var address: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func LoadDataFromJson(userId: Int){
        
        let loadingView = Bundle.main.loadNibNamed("loadingView", owner: self, options: nil)?[0] as! UIView
        view.addSubview(loadingView)
        loadingView.frame = self.view.bounds
        loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users/"+String(userId))!)
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
                        

                        self.name.text = json!["name"] as? String
                        self.userName.text = json!["username"] as? String
                        self.phone.text = json!["phone"] as? String
                        self.email.text = json!["email"] as? String
                        self.website.text = json!["website"] as? String
                        
                        let company = json!["company"] as? [String : String]
                        self.companyName.text = company?["name"]
                        self.companyCatchPhrase.text = company?["catchPhrase"]
                        self.companyBs.text = company?["bs"]
                        
                        var addressText = ""
                        let addressArr = json!["address"] as? [String : Any]
                        
                        if addressArr != nil {
                            for item in addressArr! {
                                
                                if addressText != "" {
                                    addressText += ", "
                                }
                                
                                if item.key == "geo" {
                                    
                                    let geoArr = addressArr!["geo"] as? [String : String]
                                    addressText += ""+item.key
                                    addressText += ": lat"+(geoArr?["lat"])!
                                    addressText += " lng"+(geoArr?["lng"])!
                                }
                                else {
                                    addressText += ""+item.key+": "+String(describing: item.value)
                                }
                            }
                        }
                        
                        self.address.text =  addressText
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
