//
//  APODModel.swift
//  NasaApp
//
//  Created by Yash Rathore on 16/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

import UIKit
import CoreData

//enum Section {
//    case main
//}

enum APODModelConstants:String{
    case title = "title"
    case mediaType = "media_type"
    case sdUrl = "url"
    case hdUrl = "hdurl"
    case releaseDate = "date"
    case pictureDetail = "explanation"
    case copyrightMessage = "copyright"
    case serviceVersion = "service_version"
    case favourite = "favourite"
}

@objc class APODModel:NSObject  {
    
    @objc var title : String? = ""
    @objc var mediaType : String? = ""
    @objc var sdUrl : String? = ""
    @objc var hdUrl : String? = ""
    @objc var releaseDate : String? = ""
    @objc var pictureDetail : String? = ""
    @objc var copyrightMessage : String? = ""
    @objc var serviceVersion : String? = ""
    @objc var favourite : Bool = false
    @objc var image:UIImage? = nil
        
    @objc public init(title: String?, mediaType: String?, sdUrl: String?, hdUrl: String?, releaseDate: String?, pictureDetail: String?, copyrightMessage: String?, serviceVersion: String?, favourite: Bool, image: UIImage?) {
        self.title = title
        self.mediaType = mediaType
        self.sdUrl = sdUrl
        self.hdUrl = hdUrl
        self.releaseDate = releaseDate
        self.pictureDetail = pictureDetail
        self.copyrightMessage = copyrightMessage
        self.serviceVersion = serviceVersion
        self.favourite = favourite
        self.image = image
    }

    static func == (lhs: APODModel, rhs: APODModel) -> Bool {
        return lhs.favourite == rhs.favourite
    }
}
