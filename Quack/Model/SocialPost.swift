//
//  socialPost.swift
//  Quack
//
//  Created by Katya  on 4/14/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import Foundation

class SocialPost{
    var adCategory: String
    var adDate: Double
    //  var editDate: CLong
    var adDescription: String
    var eventDate: CLong
    var adStatus: String
    var adTitle: String
    var idUser: String
    var imageOne: String
    
    init(captionCategory: String, captionDescription: String, captionEventDate: CLong, captionStatus: String, captionTitle: String, captionUser: String, captionImageUrl: String, captionDate: Double) {
        adCategory = captionCategory
        adDate = captionDate
        adDescription = captionDescription
        eventDate = captionEventDate
        adStatus = captionStatus
        adTitle = captionTitle
        idUser = captionUser
        imageOne = captionImageUrl
    }
}

