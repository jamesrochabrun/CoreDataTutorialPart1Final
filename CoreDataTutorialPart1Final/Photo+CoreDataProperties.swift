//
//  Photo+CoreDataProperties.swift
//  CoreDataTutorialPart1Final
//
//  Created by James Rochabrun on 3/1/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var author: String?
    @NSManaged public var tags: String?
    @NSManaged public var mediaURL: String?

}
