//
//  DatabaseManager.swift
//  CarOwners
//
//  Created by Aleksandr Afanasiev on 15.08.17.
//  Copyright © 2017 Aleksandr Afanasiev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager: NSObject {
    
    private var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context: NSManagedObjectContext? = nil
    private var pojo: NSManagedObject? = nil
    
    private override init() { }
    
    static let shared = DatabaseManager()

    
    func initDb(type: Type) {
        self.context = self.appDelegate.persistentContainer.viewContext
        
        let typeString = getType(type: type)
        
        let entity = NSEntityDescription.entity(forEntityName: typeString, in: self.context!)
        self.pojo = NSManagedObject(entity: entity!, insertInto: self.context!)
    }
    
    func getType(type: Type) -> String {
        switch type {
        case .Owner:
            return "Owner"
        default:
            return "Car"
        }
    }
    
    func addData(name: String, type: Type) {
        initDb(type: type)
        self.pojo?.setValue(name, forKey: "name")
        
        do {
            try self.context?.save()
            print("Done")
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getAllData(type: Type) -> [NSManagedObject]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: getType(type: type))
        self.context = self.appDelegate.persistentContainer.viewContext
        
        var model = [NSManagedObject]()
        do {
            model = try self.context?.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print(error)
        }
        
        return model
    }
    
    
    func editDataForName(objectID: NSManagedObjectID, newValue: String, type: Type) {
        
        let model = self.context?.object(with: objectID)

        do {
            model?.setValue(newValue, forKey: "name")
            try self.context?.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteDataById(id: NSManagedObjectID) {
        
        self.context = appDelegate.persistentContainer.viewContext
        self.context?.delete((self.context?.object(with: id))!)
        do {
            _ = try self.context?.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteAllData(type: Type) {
        
        self.context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: self.getType(type: type))
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            _ = try self.context?.execute(request)
            _ = try self.context?.save()
        } catch let error as NSError {
            print(error)
        }
    }
}


enum Type {
    case Owner
    case Car
}

