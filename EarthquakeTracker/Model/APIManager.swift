//
//  APIManager.swift
//  EarthquakeTracker
//
//  Created by Анастасия Беспалова on 03.12.2021.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import CoreData

class APIManager {


    func fetchEarthquakes(longitude: Double, latitude: Double, completionHandler: @escaping (_ inner: () throws -> [EarthquakeEntityModel]?) -> ()) {

        let currentTime = Date()
        let oldTime = currentTime.addingTimeInterval(-2592000)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let currentTimeString = timeFormatter.string(from: currentTime)
        let oldTimeString = timeFormatter.string(from: oldTime)

        let requestString = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(oldTimeString)&endtime=\(currentTimeString)&latitude=\(latitude)&longitude=\(longitude)&maxradiuskm=2000"
        AF.request(requestString).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.data!)
                completionHandler({
                    var earthquakeEntities: [EarthquakeEntityModel] = []
                    if json["metadata"]["count"].int != nil, json["metadata"]["count"].int != 0 {

                        for index in 0..<json["metadata"]["count"].int! {
                            var earthquakeEntity = EarthquakeEntityModel()
                            earthquakeEntity.time = json["features"][index]["properties"]["time"].int64
                            earthquakeEntity.alert = json["features"][index]["properties"]["alert"].isEmpty ? false : true
                            earthquakeEntity.tsunami = json["features"][index]["properties"]["tsunami"].isEmpty ? false : true
                            earthquakeEntity.place = json["features"][index]["properties"]["place"].string
                            earthquakeEntity.title = json["features"][index]["properties"]["title"].string
                            earthquakeEntity.mag = json["features"][index]["properties"]["mag"].double
                            earthquakeEntity.latitude = json["features"][index]["geometry"]["coordinates"][0].double
                            earthquakeEntity.longitude = json["features"][index]["geometry"]["coordinates"][1].double
                            earthquakeEntity.code = json["features"][index]["properties"]["code"].string
                            earthquakeEntity.url = json["features"][index]["properties"]["url"].string

                            earthquakeEntities.append(earthquakeEntity)
                        }
                    }
                    return earthquakeEntities

                })
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler({ throw error })
            }
        }
    }
}
