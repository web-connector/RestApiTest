//
//  FirstViewControllerCollectionViewController.swift
//  ForATeams
//
//  Created by Павел on 20.10.2017.
//  Copyright © 2017 Павел. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

//Карточки сделаны на UICollectionViewController, чтобы в горизонтальном режиме телефона и на айпаде можно было разместить их в две или три колонки
class FirstViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName:"PostsCell", bundle: nil), forCellWithReuseIdentifier: "Posts")
        self.collectionView!.register(UINib(nibName:"CommentsCell", bundle: nil), forCellWithReuseIdentifier: "Comments")
        self.collectionView!.register(UINib(nibName:"TodosCell", bundle: nil), forCellWithReuseIdentifier: "Todos")
        
        NotificationCenter.default.addObserver(self, selector: #selector(Update), name: NSNotification.Name(rawValue: "Update"), object: nil)

        changeCellsSize(width: UIScreen.main.bounds.width)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        var width = UIScreen.main.bounds.width
        
        if UIDevice.current.orientation.isLandscape && width < UIScreen.main.bounds.height {
            width = UIScreen.main.bounds.height
        }
        
        if !UIDevice.current.orientation.isLandscape && width > UIScreen.main.bounds.height {
            width = UIScreen.main.bounds.height
        }
        
        changeCellsSize(width: width)
    }
    
    func changeCellsSize(width: CGFloat){
        
        var halfWidth = (width - 24) / 2
        
        if halfWidth < 300 {
            halfWidth = width - 16
        }
        
        if halfWidth > 450 {
            halfWidth = (width - 36) / 3
        }
        
        let cellSize = CGSize(width:halfWidth , height:335)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        collectionView?.setCollectionViewLayout(layout, animated: true)
        
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowUser"
        {
            let b = sender as! UIButton
            
            if let UserVC = segue.destination as? UserViewController {
                UserVC.LoadDataFromJson(userId: b.tag)
            }
        }
        
        if segue.identifier == "ShowPhoto"
        {
            let b = sender as! UIButton
            
            if let UserVC = segue.destination as? PhotoViewController {
                UserVC.LoadDataFromJson(photoId: b.tag)
            }
        }
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Posts", for: indexPath) as? PostsCell
            cell?.loadDataFromJson()
            setCellShadow(cell: cell!)
            return cell!
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Comments", for: indexPath) as? CommentsCell
            cell?.loadDataFromJson()
            setCellShadow(cell: cell!)
            return cell!
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Users", for: indexPath) as? UsersCell
            
            cell?.loadDataFromJson()
            setCellShadow(cell: cell!)
            return cell!
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as? PhotoCell
            
            cell?.loadDataFromJson()
            setCellShadow(cell: cell!)
            return cell!
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Todos", for: indexPath) as? TodosCell
            
            cell?.loadDataFromJson()
            setCellShadow(cell: cell!)
            return cell!
        }
    }
    
    func setCellShadow(cell: UICollectionViewCell){
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 1.0
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
    }
    
    class func httpConnection(request: URLRequest, taskCallback: @escaping (Bool,
        Data?) -> ()) {
        
        print(request)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                
                print("httpConnection error",error ?? "")
                
                taskCallback(false, nil)
                return
            }
            
            taskCallback(true, data)
        }
        task.resume()
    }
    
    //Обновить
    @objc func Update(notification: NSNotification){
        collectionView?.reloadData()
    }

}
