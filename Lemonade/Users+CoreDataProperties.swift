//
//  Users+CoreDataProperties.swift
//  
//
//  Created by Rebecca Bartels on 8/15/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Users {
    
    //don't mess with this class

    @NSManaged var birthdate: String?
    @NSManaged var username: String?

}
