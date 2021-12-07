//
//  CoreDataManager.swift
//  EarthquakeTracker
//
//  Created by Анастасия Беспалова on 03.12.2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    init() {
        persistentContainer = NSPersistentContainer(name: "EarthquakeTracker")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
        }
    }
    
    func saveContext () {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func getAllEntities() -> [EarthquakeEntity] {
        let request: NSFetchRequest<EarthquakeEntity> = EarthquakeEntity.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteAllEntities() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EarthquakeEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try viewContext.execute(deleteRequest)
            saveContext()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func addEntities(from entries: [EarthquakeEntityModel]) {
        for entry in entries {
            EarthquakeEntity.update(from: entry, context: viewContext)
        }
    }
    
}
