//
//  DetailView.swift
//  EarthquakeTracker
//
//  Created by Анастасия Беспалова on 03.12.2021.
//

import SwiftUI
import MapKit


struct DetailView: View {
    
    var earthquakeEntry: EarthquakeEntity?
    
    @State var region: MKCoordinateRegion
    
    @State var annotations: [CLLocationCoordinate2D]
    
    init(earthquakeEntry: EarthquakeEntity) {
        self.earthquakeEntry = earthquakeEntry
        self.annotations = [CLLocationCoordinate2D(latitude: earthquakeEntry.latitude, longitude: earthquakeEntry.longitude)]
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: earthquakeEntry.latitude, longitude: earthquakeEntry.longitude), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 5) {
                Map(coordinateRegion: $region, annotationItems: annotations) {
                    MapPin(coordinate: $0)
                }
                .frame(width: geometry.size.width,
                       height: 300,
                       alignment: .center)
                VStack (alignment: .leading){
                    HStack {
                        Text("Magnitude: ")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(String(format: "%.1f", earthquakeEntry!.mag))
                            .fontWeight(.heavy)
                            .font(.system(size: 20))
                    }
                    

                    Text("\(earthquakeEntry!.time!)")
                        .fontWeight(.light)
                        .padding(.bottom, 20)
                    
                    
                    HStack {
                        Text("Longitude: ")
                            .fontWeight(.light)
                        Spacer()
                        Text(String(format: "%.2f", earthquakeEntry?.longitude ?? 0))
                    }
                    
                    
                    
                    HStack {
                        Text("Latitude: ")
                            .fontWeight(.light)
                        Spacer()
                        Text(String(format: "%.2f", earthquakeEntry?.latitude ?? 0))
                    }
                    
                    Text(earthquakeEntry?.place!.replacingOccurrences(of: "?", with: "", options: NSString.CompareOptions.literal, range: nil) ?? "")
                        .fontWeight(.medium)
                        .padding(.bottom, 20)
                    
                    
                    Link("Click here to check details on USGS!",
                         destination: URL(string: earthquakeEntry?.url ?? "https://earthquake.usgs.gov")!)
                }
                .padding(15)
                
                
                Spacer()
            }
            
            .navigationTitle("Code: \(earthquakeEntry?.code ?? "")")
        }
        
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}

