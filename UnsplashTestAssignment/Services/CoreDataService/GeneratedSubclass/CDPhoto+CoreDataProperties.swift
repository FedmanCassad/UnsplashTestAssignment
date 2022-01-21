//
//  CDPhoto+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 20.01.2022.
//
//

import Foundation
import CoreData


extension CDPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPhoto> {
        return NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
    }

    @NSManaged public var author: String?
    @NSManaged public var location: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: String?
    @NSManaged public var downloadsCount: Int64
    @NSManaged public var regularUrl: URL?
    @NSManaged public var smallUrl: URL?

}

extension CDPhoto {
    func prepareFromCodablePhotoModel(_ model: UnsplashPhotoModel) {
        self.author = model.user.name
        self.location = model.location.title
        self.dateCreated = model.date
        self.id = model.photoID
        self.downloadsCount = Int64(model.downloadsCount)
        self.regularUrl = model.urls[UnsplashPhotoModel.URLType.regular.rawValue]
        self.smallUrl = model.urls[UnsplashPhotoModel.URLType.small.rawValue]
    }
}
