//
//  MarketPlaceViewController.swift
//  Quack
//
//  Created by Katya  on 3/24/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import SDWebImage

class MarketPlaceViewController: UIViewController {
    fileprivate var isLoadingPost = false
    let refreshControl = UIRefreshControl() //refresh
    @IBOutlet weak var tableView: UITableView!
    var marketPlacePosts = [MarketPlacePost]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 198
        tableView.dataSource = self
        loadPosts()
        //checking why selection doesnt work
        tableView.allowsSelection = true
        self.tableView.delegate = self as? UITableViewDelegate
        self.tableView.isUserInteractionEnabled = true
        self.view.bringSubviewToFront(tableView)
        //refresh
        refreshControl.addTarget(self, action:#selector(refresh),for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //refresh
    @objc func refresh() {
        self.marketPlacePosts.removeAll()
        loadPosts()
    }
    
    func loadPosts() {
        
        //refresh
        isLoadingPost = true
        
        
     let ref = Firestore.firestore()
        ref.collection("marketplace_posts").whereField("adStatus", isEqualTo: "active").order(by: "adDate", descending: true).getDocuments{ (snapshot, error) in
            if error != nil {
                print(error!)
            } else {
                for document in (snapshot?.documents)! {
                    if let dict = document.data() as? [String: Any]{
                        let captionCategory = dict["adCategory"] as! String
                        let captionDate = dict["adDate"] as! Double
                        let captionDescription = dict["adDescription"] as! String
                        let captionPrice = dict["adPrice"] as! String
                        let captionStatus = dict["adStatus"] as! String
                        let captionTitle = dict["adTitle"] as! String
                        let captionUser = dict["idUser"] as! String
                        let captionImageUrl = dict["imageOne"] as! String
                        let mpost = MarketPlacePost(captionCategory: captionCategory, captionDate: captionDate, captionDescription: captionDescription, captionPrice: captionPrice, captionStatus: captionStatus, captionTitle: captionTitle, captionUser: captionUser, captionImageUrl: captionImageUrl)
                        self.marketPlacePosts.append(mpost)
                        print(self.marketPlacePosts)
                        self.tableView.reloadData()
                        self.isLoadingPost = false                    //refresh
                        if self.refreshControl.isRefreshing{          //refresh
                            self.refreshControl.endRefreshing()       //refresh
                        }
                    }     
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Marketplace_DetailSegue" {
            if let marketplaceDetailVC = segue.destination as? MarketPlaceDetailViewController{
                let postId = self.marketPlacePosts[(sender as! IndexPath).row]
                marketplaceDetailVC.post = postId
            }
        }
    }
}

extension MarketPlaceViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return marketPlacePosts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! MarketplaceTableViewCell
        let marketplacePost = marketPlacePosts[indexPath.row]
        cell.post = marketplacePost
        return cell
    }
}
//connects to MarketplaceDetailViewController
extension MarketPlaceViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "Marketplace_DetailSegue", sender: indexPath)
    }
}

