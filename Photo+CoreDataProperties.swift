//
//  Photo+CoreDataProperties.swift
//  FlickrPhoto
//
//  Created by VEERASEKHAR ADDEPALLI on 26/12/16.
//  Copyright © 2016 VEERASEKHAR ADDEPALLI. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var title: String?
    @NSManaged public var photoID: String?
    @NSManaged public var remoteURL: NSURL?
    @NSManaged public var dateTaken: NSDate?

}
