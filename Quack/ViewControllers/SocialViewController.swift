//
//  SocialViewController.swift
//  Quack
//
//  Created by Katya  on 3/24/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class SocialViewController: UIViewController {
    fileprivate var isLoadingPost = false //refresh
    let refreshControl = UIRefreshControl() //refresh
    @IBOutlet weak var sTableView: UITableView!
    var socialPosts = [SocialPost]()
    override func viewDidLoad() {
        super.viewDidLoad()
        sTableView.rowHeight = 198 
        sTableView.dataSource = self
        loadSocialPosts()
        //checking why selection doesnt work
        sTableView.allowsSelection = true
        self.sTableView.delegate = self as? UITableViewDelegate
        self.sTableView.isUserInteractionEnabled = true
        self.view.bringSubviewToFront(sTableView)
        //refresh
        refreshControl.addTarget(self, action:#selector(refresh),for: .valueChanged)
        sTableView.addSubview(refreshControl)
    }
    
    //refresh
    @objc func refresh() {
        self.socialPosts.removeAll()
        loadSocialPosts()
    }
    
    func loadSocialPosts(){
        
        //refresh
        isLoadingPost = true
        
        let ref = Firestore.firestore()
        
        ref.collection("social_posts").whereField("adStatus", isEqualTo: "active").order(by: "adDate", descending: true).getDocuments{ (snapshot, error) in
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
                        self.sTableView.reloadData()
                        self.isLoadingPost = false                    //refresh
                        if self.refreshControl.isRefreshing{          //refresh
                            self.refreshControl.endRefreshing()       //refresh
                        }
                    }
                }
            }
        }
    }
    //prepares a connection to SocialDetailedViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Social_DetailSegue" {
            if let socialDetailVC = segue.destination as? SocialDetailedViewController{
            let postId = self.socialPosts[(sender as! IndexPath).row]
            socialDetailVC.sposts = postId
            }
        }
    }
}
//feeds data from SocialTalbeViewCell
extension SocialViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return socialPosts.count
    }
    func tableView (_ tableView: UITableView, cellForRowAt indepxPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "socialPostCell", for: indepxPath) as! SocialTableViewCell
        let socialPost = socialPosts[indepxPath.row]
        cell.sposts = socialPost
        return cell
    }
}
//connects to SocialDetailedViewController
extension SocialViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "Social_DetailSegue", sender: indexPath)
    }
}
