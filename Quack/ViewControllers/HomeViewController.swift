//
//  HomeViewController.swift
//  Quack
//
//  Created by Katya  on 3/24/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    var socialPosts = [SocialPost]()
    var marketPlacePosts = [MarketPlacePost]()
    var housingPosts = [HousingPost]()
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.rowHeight = 198 //check row height again
        homeTableView.dataSource = self
        loadSocialPosts()
        loadPosts()
        loadHousingPosts()
        //checking why selection doesnt work
        homeTableView.allowsSelection = true
        self.homeTableView.delegate = self as? UITableViewDelegate
        self.homeTableView.isUserInteractionEnabled = true
        self.view.bringSubviewToFront(homeTableView)
    }
    //social posts
    func loadSocialPosts(){
        let ref = Firestore.firestore()
        
        ref.collection("social_posts").whereField("adStatus", isEqualTo: "active").order(by: "adDate", descending: true).limit(to:3).getDocuments{ (snapshot, error) in
            //            ref.collection("social_posts").whereField("adStatus", isEqualTo: "active").getDocuments{ (snapshot, error) in --------change whereField to display just the user's posts.
            if error != nil {
                print(error!)
            } else{
                for document in (snapshot?.documents)!{
                    if let dict = document.data() as? [String: Any]{
                        let captionCategory = dict["adCategory"] as! String
                        let captionDate = dict["adDate"] as! Double
                        let captionDescription = dict["adDescription"] as! String
                        let captionEventDate = dict["eventDate"] as! CLong
                        let captionStatus = dict["adStatus"] as! String
                        let captionTitle = dict["adTitle"] as! String
                        let captionUser = dict["idUser"] as! String
                        let captionImageUrl = dict["imageOne"] as! String
                        let spost = SocialPost(captionCategory: captionCategory, captionDescription: captionDescription, captionEventDate: captionEventDate, captionStatus: captionStatus, captionTitle: captionTitle, captionUser: captionUser, captionImageUrl: captionImageUrl, captionDate: captionDate)
                        self.socialPosts.append(spost)
                        print(self.socialPosts)
                        self.homeTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func loadPosts() {
        let ref = Firestore.firestore()
        ref.collection("marketplace_posts").whereField("adStatus", isEqualTo: "active").order(by: "adDate", descending: true).limit(to:3).getDocuments{ (snapshot, error) in
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
                        self.homeTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func loadHousingPosts(){
        let ref = Firestore.firestore()
        
        ref.collection("housing_posts").whereField("adStatus", isEqualTo: "active").order(by: "adDate", descending: true).limit(to:3).getDocuments{ (snapshot, error) in
            
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
                        self.homeTableView.reloadData()
                    }
                }
            }
        }
    }
    //prepares a connection to SocialDetailedViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSocial_DetailSegue" {
            if let socialDetailVC = segue.destination as? HomeDetailViewController{
                let postId = self.socialPosts[(sender as! IndexPath).row]
                socialDetailVC.sposts = postId
            }
        }
    }
}
extension HomeViewController: UITableViewDataSource{
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return socialPosts.count
        //return 9
    }
    func tableView (_ tableView: UITableView, cellForRowAt indepxPath: IndexPath) -> UITableViewCell{
        
      if indepxPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeSocialCell", for: indepxPath) as! HomeSocialTableViewCell
        let socialPost = socialPosts[indepxPath.row]
        cell.sposts = socialPost
        print(indepxPath.row)
        print(indepxPath.section)
        return cell
        }
        else if indepxPath.row == 1 {
        print(indepxPath.row)
        print(indepxPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeMarketPlaceCell", for: indepxPath) as! HomeMarketPlaceTableViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
            let marketplacePost = self.marketPlacePosts[0]
            cell.post = marketplacePost
        })
        return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeHousingCell", for: indepxPath) as! HomeHousingTableViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
            let housingPost = self.housingPosts[0]
            cell.hposts = housingPost
        })        
            return cell
        }
    }
}
//connects to homeDetailViewController
extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "homeSocial_DetailSegue", sender: indexPath)
    }
}

