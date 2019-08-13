//
//  Person+CoreDataClass.swift
//  Contacts
//
//  Created by Ruslan Kasian on 8/9/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//
//

import Foundation
import CoreData


public class Person: NSManagedObject {
    
    convenience init() {
        self.init(entity: CoreDataManager.sharedInstance.entityForName("Person"), insertInto: CoreDataManager.sharedInstance.persistentContainer.viewContext)
    }
}
