//
//  EarthquakeEntity.swift
//  EarthquakeTracker
//
//  Created by Анастасия Беспалова on 03.12.2021.
//

import Foundation
import CoreData


extension EarthquakeEntity: Comparable {
    
    static func withCode(_ model: EarthquakeEntityModel, context: NSManagedObjectContext) -> EarthquakeEntity {
        // look up existing entry in Core Data
        let request = fetchRequest(NSPredicate(format: "code = %@", NSString(string: model.code ?? "")))
        let entries = (try? context.fetch(request)) ?? []
        if let entry = entries.first {
            // if found, return it
            return entry
        } else {
            // if not, create one and fetch from EarthquakeEntityModel
            let entry = EarthquakeEntity(context: context)
            entry.code = model.code ?? ""
            self.update(from: model, context: context)
            return entry
        }
        
    }
    
    static func update(from model: EarthquakeEntityModel, context: NSManagedObjectContext) {
        let entry = self.withCode(model, context: context)
        entry.alert = model.alert ?? false
        entry.time = Date(timeIntervalSince1970: Double(model.time ?? 0)/1000)
        entry.latitude = model.latitude ?? 0
        entry.longitude = model.longitude ?? 0
        entry.mag = model.mag ?? 0
        entry.place = model.place ?? ""
        entry.tsunami = model.tsunami ?? false
        entry.title = model.title ?? ""
        entry.url = model.url ?? ""
        
        try? context.save()
    }
    
    
    
    public static func < (lhs: EarthquakeEntity, rhs: EarthquakeEntity) -> Bool {
        lhs.time! < rhs.time!
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<EarthquakeEntity> {
        let request = NSFetchRequest<EarthquakeEntity>(entityName: "EarthquakeEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    
}

struct EarthquakeEntityModel {
    
    var alert: Bool?
    var time: Int64?
    var latitude: Double?
    var longitude: Double?
    var mag: Double?
    var place: String?
    var tsunami: Bool?
    var title: String?
    var code: String?
    var url: String?
    
}
