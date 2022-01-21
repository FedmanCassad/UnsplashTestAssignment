//
//  UnsplashPhotoModel.swift
//  UnsplashTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import Foundation

public struct UnsplashPhotoModel: Hashable, Decodable {
    public static func == (lhs: UnsplashPhotoModel, rhs: UnsplashPhotoModel) -> Bool {
        lhs.photoID == rhs.photoID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(photoID)
        hasher.combine(date)
    }
    
    struct User: Decodable {
        var name: String
    }
    
    struct Location: Decodable {
        var title: String?
    }
    
    public enum URLType: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    var photoID: String
    var description: String?
    var date: Date?
    var downloadsCount: Int
    var user: User
    var location: Location
    var urls: [URLType.RawValue: URL]
    
    private enum CodingKeys: String, CodingKey {
        case downloadsCount = "downloads"
        case date = "created_at"
        case photoID = "id"
        case description, user, location, urls
    }
    
    init?(fromCDPhotoModel model: CDPhoto) {
        guard let photoID = model.id,
              let date = model.dateCreated,
              let regularURL = model.regularUrl,
              let smallURL = model.smallUrl
        else {
            return nil
        }
        
        let description = model.description
        let downloadsCount = Int(model.downloadsCount)
        let location = Location(title: model.location ?? "Undefined")
        var urls: [URLType.RawValue: URL] = [URLType.RawValue: URL]()
        let user = User(name: model.author ?? "Undefined")
        urls[URLType.regular.rawValue] = regularURL
        urls[URLType.small.rawValue] = smallURL
        self.photoID = photoID
        self.description = description
        self.date = date
        self.downloadsCount = downloadsCount
        self.location = location
        self.urls = urls
        self.user = user
    }
    
    init?(fromSearchedPhotoModel model: SearchedPhotoModel) {
        
        guard let description = model.description,
              let date = model.date else {
                  return nil
              }
        self.location = Location(title: model.user.location)
        self.user = User(name: model.user.name)
        self.description = description
        self.date = date
        self.downloadsCount = 0
        self.urls = model.urls
        self.photoID = model.photoID
    }
    
}

public struct UnsplashSearchModel: Decodable {
    var results: [SearchedPhotoModel]
}

public struct SearchedPhotoModel: Decodable {
    struct SearchedUser: Decodable {
        var name: String
        var location: String?
    }
    
    public enum URLType: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    var photoID: String
    var description: String?
    var date: Date?
    var user: SearchedUser
    var urls: [URLType.RawValue: URL]
    
    private enum CodingKeys: String, CodingKey {
        case date = "created_at"
        case photoID = "id"
        case description, user, urls
    }
}



