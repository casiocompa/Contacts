//
//  Person+CoreDataProperties.swift
//  Contacts
//
//  Created by Ruslan Kasian on 8/9/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var profileImage: NSData?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var phoneNumbers: NSObject?
    @NSManaged public var emails: NSObject?
    @NSManaged public var addresses: NSObject?
    
  

}
