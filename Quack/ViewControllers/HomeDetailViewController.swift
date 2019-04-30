//
//  HomeDetailViewController.swift
//  Quack
//
//  Created by Katya  on 4/26/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomeDetailViewController: UIViewController {
    
    var sposts: SocialPost!
    var socialPosts = [SocialPost]()
    
    @IBOutlet weak var homeDetailImageView: UIImageView!
    @IBOutlet weak var homeDetailTitleLabel: UILabel!
    @IBOutlet weak var homeDetailPriceLabel: UILabel!
    @IBOutlet weak var homeDetailUsernameLabel: UILabel!
    @IBOutlet weak var homeDetailDescriptionLabel: UITextView!
    @IBOutlet weak var homeDetailTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        homeDetailPriceLabel.text = getDateFromTimeStamp(timeStamp: sposts!.eventDate)
        homeDetailDescriptionLabel.text = sposts.adDescription
        homeDetailTitleLabel.text = sposts.adTitle
        if let photoUrlString = sposts?.imageOne {
            let imageUrl = URL(string: photoUrlString)
            homeDetailImageView.sd_setImage(with: imageUrl)
        }
        title = sposts.adTitle
        setupUserInfo()
        //this is to implement Time
        if let timestamp = sposts?.adDate {
            let timestampDate = Date(timeIntervalSince1970: timestamp/1000)
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
            var timeText = ""
            if diff.second! <= 0 {
                timeText = "Now"
            }
            if diff.second! > 0 && diff.minute! == 0 {
                timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
            }
            if diff.minute! > 0 && diff.hour! == 0 {
                timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
            }
            if diff.hour! > 0 && diff.day! == 0 {
                timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
            }
            if diff.day! > 0 && diff.weekOfMonth! == 0 {
                timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
            }
            if diff.weekOfMonth! > 0 {
                timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
            }
            homeDetailTimeLabel.text = timeText
        }
    }
    func setupUserInfo() {
        let docRef = Firestore.firestore().collection("Users").document(sposts!.idUser)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let doc = document.get("email")
                self.homeDetailUsernameLabel.text = doc as? String
            } else {
                print("Document does not exist")
            }
        }
    }
}
extension HomeDetailViewController{
    //convert number date to string
    func getDateFromTimeStamp(timeStamp : CLong) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp/1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM d, YYYY"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}

