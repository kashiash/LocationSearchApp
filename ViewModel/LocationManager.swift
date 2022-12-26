//
//  LocationManager.swift
//  LocationSearchApp
//
//  Created by Jacek Kosinski U on 25/12/2022.
//

import SwiftUI
import CoreLocation
import MapKit
import Combine


class LocationManager: NSObject, ObservableObject,MKMapViewDelegate,CLLocationManagerDelegate{
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
   
    //MARK: Search Bar text
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?
    
    override init() {
        super.init()
        manager.delegate = self
        mapView.delegate = self
        
        //MARK: requesting location access
        manager.requestWhenInUseAuthorization()
        
        //MARK: Search Textfield watching
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                self.fetchPlaces(value: value)
            })
    }
    func fetchPlaces(value: String){
        Task{
            do{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                let response = try await MKLocalSearch(request: request).start()
                
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            } catch {
                //HANDLE ERROR
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ = locations.last else { return }
    }
    
    //Location Authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus{
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func handleLocationError(){
        
    }
}
