//
//  HousingViewController.swift
//  Quack
//
//  Created by Katya  on 3/24/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseFirestore
import SDWebImage
class HousingViewController: UIViewController {
    fileprivate var isLoadingPost = false
    let refreshControl = UIRefreshControl() //refresh
    @IBOutlet weak var hTablewView: UITableView!
    var housingPosts = [HousingPost]()
    override func viewDidLoad() {
        super.viewDidLoad()
       // hTablewView.estimatedRowHeight = 185
        hTablewView.rowHeight = 202
        hTablewView.dataSource = self
        loadHousingPosts()
        //checking why selection doesnt work
        hTablewView.allowsSelection = true
        self.hTablewView.delegate = self as? UITableViewDelegate
        self.hTablewView.isUserInteractionEnabled = true
        self.view.bringSubviewToFront(hTablewView)
        //refresh
        refreshControl.addTarget(self, action:#selector(refresh),for: .valueChanged)
        hTablewView.addSubview(refreshControl)
    }
    
    //refresh
    @objc func refresh() {
        self.housingPosts.removeAll()
        loadHousingPosts()
    }
    
    func loadHousingPosts(){
        
        //refresh
        isLoadingPost = true
        
        let ref = Firestore.firestore()
        
       ref.collection("housing_posts").whereField("adStatus", isEqualTo: "active").order(by: "adDate", descending: true).getDocuments{ (snapshot, error) in
      
            if error != nil {
                print(error!)
            } else{
                for document in (snapshot?.documents)!{
                    if let dict = document.data() as? [String: Any]{
                        let housingCategory = dict["adCategory"] as! String
                        let housingDate = dict["adDate"] as! Double
                        let housingDescription = dict["adDescription"] as! String
                        let housingPrice = dict["adRent"] as! String
                        let housingStatus = dict["adStatus"] as! String
                        let housingTitle = dict["adTitle"] as! String
                        let housingUser = dict["idUser"] as! String
                        let housingImageUrl = dict["imageOne"] as! String
                        let hpost = HousingPost(housingCategory: housingCategory, housingDate: housingDate, housingDescription: housingDescription, housingPrice: housingPrice, housingStatus: housingStatus, housingTitle: housingTitle, housingUser: housingUser, housingImageUrl: housingImageUrl)
                        self.housingPosts.append(hpost)
                        print(self.housingPosts)
                        self.hTablewView.reloadData()
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
        if segue.identifier == "Housing_DetailSegue" {
            if let housingDetailVC = segue.destination as? HousingDetailViewController{
                let postId = self.housingPosts[(sender as! IndexPath).row]
                housingDetailVC.hposts = postId
            }
        }
    }
}

extension HousingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return housingPosts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "HousingPostCell", for: indexPath) as! HousingTableViewCell
        let housingPost = housingPosts[indexPath.row]
        cell.hposts = housingPost
        return cell
    }
}

//connects to MarketplaceDetailViewController
extension HousingViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "Housing_DetailSegue", sender: indexPath)
    }
}
