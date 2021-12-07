//
//  ContentView.swift
//  EarthquakeTracker
//
//  Created by Анастасия Беспалова on 03.12.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var viewModel = EarthquakeViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.earthquakeEntities, id: \.self) { item in
                    NavigationLink(destination: DetailView(earthquakeEntry: item)) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Magnitude: ")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(String(format: "%.1f", item.mag))
                                    .fontWeight(.heavy)
                            }
                            Text(item.place!.replacingOccurrences(of: "?", with: "", options: NSString.CompareOptions.literal, range: nil))
                                .fontWeight(.medium)
                            Text("\(item.time!)")
                                .fontWeight(.light)
                            HStack {
                                Text(item.alert ? "Alert!" : "No alert")
                                    .fontWeight(.ultraLight)
                                Spacer()
                                Text(item.tsunami ? "Tsunami!" : "No tsunami")
                                    .fontWeight(.ultraLight)
                            }
                            
                           
                        }
                        
                    }
                }
            }
            .listStyle(InsetListStyle())
            .toolbar {
                ToolbarItem {
                    Button(action: refresh) {
                        Label("Refresh", systemImage: "goforward")
                    }
                }
            }
            .refreshable {
                refresh()
            }
            .navigationBarTitle("Earthquake Tracker", displayMode: .large)
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func refresh() {
         viewModel.refreshEntities()
    }


}


