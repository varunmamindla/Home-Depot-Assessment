//
//  ViewController.swift
//  Home Depot Assessment
//
//  Created by Varun Mamindla on 5/13/18.
//  Copyright © 2018 Varun Mamindla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usertxt: UITextField!
    var pageNo:Int = 1
    var itemsToDisplay = [AnyObject]()
    var gridLayout: GridLayout!
    lazy var listLayout: ListLayout = {
        var listLayout = ListLayout(itemHeight: 180)
        return listLayout
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        usertxt.text = "apple"
        getData(user: usertxt.text!)
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
        gridLayout = GridLayout(numberOfColumns: 2)
        collectionView.collectionViewLayout = gridLayout
        
    }
   
    
    // MARK: collectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailViewCell
        
        let detais:[String: Any] = itemsToDisplay[indexPath.row] as! [String: Any]
        
        let title = detais["name"]
        cell.Title.text = title as? String
        let desc = detais["description"]
        cell.Description.text = desc as? String
        let created = detais["created_at"]
        cell.Created.text = created as? String
        cell.License.text = "null"
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
            pageNo = pageNo + 1
            getData(user: usertxt.text!, page: pageNo)
        }
    }
    
    @IBAction func goBtnClicked(_ sender: Any) {
        let text = usertxt.text
        pageNo = 1
        itemsToDisplay.removeAll()
        getData(user: text!)
        
    }
    
    func getData(user:String, page:Int = 1) {
        let path = "https://api.github.com/users/"+user+"/repos"
        var urlComponents = URLComponents(string: path)!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(10))
        ]
        
        let url = urlComponents.url//URL(string: path)
        let session = URLSession.shared
        let task = session.dataTask(with:url!) { (data, response, error) -> Void in
            guard let content = data else {
                
                print("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyObject] else {
                print("Not containing JSON")
                return
            }
            self.itemsToDisplay = self.itemsToDisplay + json
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        task.resume()
        
    }


}

