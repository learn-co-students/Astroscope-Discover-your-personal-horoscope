//
//  Users+CoreDataProperties.swift
//  
//
//  Created by Rebecca Bartels on 8/16/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Users {

    @NSManaged var birthdate: Int32
    @NSManaged var username: String


}
