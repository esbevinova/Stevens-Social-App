//
//  MarketPlacePost.swift
//  Quack
//
//  Created by Katya  on 4/13/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import Foundation
class MarketPlacePost{
    var adCategory: String
    var adDate: Double
    var adDescription: String
    var adPrice: String
    var adStatus: String
    var adTitle: String
    var idUser: String
    var imageOne: String

    init(captionCategory: String, captionDate: Double, captionDescription: String, captionPrice: String, captionStatus: String, captionTitle: String, captionUser: String, captionImageUrl: String) {
        adCategory = captionCategory
        adDate = captionDate
        adDescription = captionDescription
        adPrice = captionPrice
        adStatus = captionStatus
        adTitle = captionTitle
        idUser = captionUser
        imageOne = captionImageUrl
    }
}

