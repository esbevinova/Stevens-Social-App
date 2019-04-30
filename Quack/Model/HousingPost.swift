//
//  HousingPost.swift
//  Quack
//
//  Created by Katya  on 4/14/19.
//  Copyright © 2019 Katya . All rights reserved.
//

import Foundation

class HousingPost{
    var adCategory: String
    var adDate: Double
    var adDescription: String
    var adRent: String
    var adStatus: String
    var adTitle: String
    var idUser: String
    var imageOne: String
    
    init(housingCategory: String, housingDate: Double, housingDescription: String, housingPrice: String, housingStatus: String, housingTitle: String, housingUser: String, housingImageUrl: String) {
        adCategory = housingCategory
        adDate = housingDate
        adDescription = housingDescription
        adRent = housingPrice
        adStatus = housingStatus
        adTitle = housingTitle
        idUser = housingUser
        imageOne = housingImageUrl
    }
}

