//
//  SocialTableViewCell.swift
//  Quack
//
//  Created by Katya  on 4/14/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import UIKit
import FirebaseFirestore

class SocialTableViewCell: UITableViewCell {
   

    @IBOutlet weak var socialTitleLabel: UILabel!
    @IBOutlet weak var socialImageView: UIImageView!
    @IBOutlet weak var socialDescriptionView: UITextView!
    @IBOutlet weak var socialTimeLabel: UILabel!
    @IBOutlet weak var socialEventDateLabel: UILabel!
    @IBOutlet weak var socialUserPostLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var sposts: SocialPost? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        //disable scroll option on description label
        let textView = socialDescriptionView
        textView?.isScrollEnabled = false
        textView?.isEditable = false
        //updates and adds information to the tab
        socialTitleLabel.text = sposts?.adTitle
        socialDescriptionView.text = sposts?.adDescription
        socialEventDateLabel.text = getDateFromTimeStamp(timeStamp: sposts!.eventDate)
        if let photoUrlString = sposts?.imageOne {
            let imageUrl = URL(string: photoUrlString)
            socialImageView.sd_setImage(with: imageUrl)
        }
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
            timeLabel.text = timeText
        }
        setupUserInfo()
    }
    
    func setupUserInfo() {
        let docRef = Firestore.firestore().collection("Users").document(sposts!.idUser)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let doc = document.get("email")
                self.socialUserPostLabel.text = doc as? String
              //  print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension SocialTableViewCell{
//convert number date to string
func getDateFromTimeStamp(timeStamp : CLong) -> String {
    let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp/1000))
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "MMMM d, YYYY"
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    return dateString
    }
}
