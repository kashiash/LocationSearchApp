//
//  SearchView.swift
//  LocationSearchApp
//
//  Created by Jacek Kosinski U on 25/12/2022.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @StateObject var locationManager: LocationManager = .init()
    // Navigation tag to push view to mapview
    @State var navigationTag:String?
    var body: some View {
        VStack{
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                Text("Search Location")
                    .font(.title3)
                    .fontWeight(.semibold)
            }.frame(maxWidth: .infinity,alignment: .leading)
            HStack(spacing: 10){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Find locations here", text: $locationManager.searchText)
            }
            .padding(.vertical,12)
            .padding(.horizontal)
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(.gray)
            }
            .padding(.vertical,10)
            
            if let places = locationManager.fetchedPlaces, !places.isEmpty {
                List{
                    ForEach(places, id: \.self) { place in
                        HStack(spacing:15){
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            VStack(alignment: .leading, spacing: 6){
                                Text(place.name ?? "")
                                    .font(.title3.bold())
                                
                                Text(place.locality ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
   
                    }
                }
                .listStyle(.plain)
            }
            
            
            //MARK: Current location button
            Button{
               
                if let coordinate = locationManager.userLocation?.coordinate{
                    locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    locationManager.addDraggablePin(coordinate: coordinate)
                }
                navigationTag = "MAPVIEW"
            } label: {
                Label {
                    Text("Use Current Location")
                        .font(.callout)
                } icon: {
                    Image(systemName: "location.north.circle.fill")
                }
                .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
        }
        .padding()
        .frame(maxHeight: .infinity,alignment: .top)
        .background{
            NavigationLink(tag: "MAPVIEW", selection: $navigationTag){
                MapViewSelection().environmentObject(locationManager)
            } label : {}
                .labelsHidden()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapViewSelection: View{
    @EnvironmentObject var locationManager: LocationManager
    var body: some View{
        ZStack{
            MapViewHelper()
                .environmentObject(locationManager)
                .ignoresSafeArea()
        }
    }
}

struct MapViewHelper : UIViewRepresentable{
    @EnvironmentObject var locationManager: LocationManager
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
