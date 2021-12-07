//
//  EarthquakeViewModel.swift
//  EarthquakeTracker
//
//  Created by Анастасия Беспалова on 03.12.2021.
//

import SwiftUI
import CoreLocation

class EarthquakeViewModel: ObservableObject {
    
    @Published var earthquakeEntities: [EarthquakeEntity]
    
    private var coreDataManager = CoreDataManager()
    private var apiManager = APIManager()
    
    private var locationManager = LocationManager()
    private var userCoordinate: CLLocationCoordinate2D? {
        didSet {
            uploadNewEntities()
        }
    }
   
    
    init() {
        // get existing entities from CoreData (in case there is no internet or can't determine user location)
        earthquakeEntities = coreDataManager.getAllEntities()
    }
    
    private func getLocation() {
        locationManager.fetchLocation(handler: { location in
            self.userCoordinate = location.coordinate
        })
    }
    
    // MARK: -Intents
    
    func refreshEntities()  {
        // get user location
        // if it is set, it uploads data
        getLocation()
    }
    
    func uploadNewEntities() {
        
        // get entities from api
        if let longitude = userCoordinate?.longitude, let latitude = userCoordinate?.latitude {
            var newEarthquakeEntities: [EarthquakeEntityModel] = []
            apiManager.fetchEarthquakes(longitude: longitude, latitude: latitude) { (inner: () throws -> [EarthquakeEntityModel]?) -> Void in
                 do {
                     newEarthquakeEntities = try inner()!
                     self.coreDataManager.deleteAllEntities()
                     
                     
                     self.coreDataManager.addEntities(from: newEarthquakeEntities)
                     
                     
                     self.earthquakeEntities = self.coreDataManager.getAllEntities()
                 } catch let error {
                    print(error)
                 }
               }
            
            
        }
        
       
        
    }
    
}
