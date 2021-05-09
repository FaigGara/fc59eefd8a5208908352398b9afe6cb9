//
//  StationAndTravelerJsonViewModel.swift
//  United Space Travelers
//
//  Created by Faiq on 8.05.2021.
//

import UIKit
import CoreData

struct StationAndTravelerJsonViewModel {
    public func traveler() -> TravelerViewModel{
        return TravelerViewModel.getTravelViewModel()
    }
    
    static var searchedStations: [StationViewModel]?
    
    public func stations(stations: [StationViewModel]? = nil, isResultEmpty: Bool = false) -> [StationViewModel]? {
        if isResultEmpty {
            StationAndTravelerJsonViewModel.searchedStations = stations
            return stations
        }
        
        if let sts = stations, sts.count > 0 {
            StationAndTravelerJsonViewModel.searchedStations = stations
            return StationAndTravelerJsonViewModel.searchedStations
        }
        
        if StationAndTravelerJsonViewModel.searchedStations != nil {
            return StationAndTravelerJsonViewModel.searchedStations
        }
        
        StationAndTravelerJsonViewModel.searchedStations = nil
        return StationViewModel.fetchStationViewModels()
    }
    
    
    public func travelerRemainingUgs() -> String {
        if let ugs = traveler().fetchTraveler()?.materialCapasity {
            let lastUgs = String(format: "UGS:%i", ugs)
            return lastUgs
        }
        return "UGS:0"
    }
    
    public func travelerRemainingEus() -> String {
        if let eus = traveler().fetchTraveler()?.speed {
            let lastEus = String(format: "EUS:%i", eus)
            return lastEus
        }
        return "EUS:0"
    }
    
    public func travelerRemainingDs() -> String {
        if let ds = traveler().fetchTraveler()?.hardness {
            let lastDs = String(format: "DS:%i", ds)
            return lastDs
        }
        return "DS:0"
    }
    
    public func travelerRemainingSecond() -> String {
        if let ds = traveler().fetchTraveler()?.hardness {
            let second = String(describing: ds / 1000)
            let lastSecond = "\(second)s"
            return lastSecond
        }
        return "0s"
    }
    
    public func travelerRemainingDamegeCapacity() -> String {
        return String(describing: traveler().damageCapasity)
    }
    
    public func stationAndTravelerEusDistance(stationIndex: Int) -> String {
        if let station = stations()?[stationIndex] {
            let coordianteX = traveler().coordinateX - station.coordinateX
            let coordianteY = traveler().coordinateY - station.coordinateY
            let distace = coordianteX * coordianteX + coordianteY * coordianteY
            let distanceString = String(describing: Int64(sqrt(distace)))
            return "\(distanceString)EUS"
        }
        return "0EUS"
    }
    
    public func worldStationAndFavStationsEusDistance(favStation: StationViewModel) -> String {
        var worldStViewModel: StationViewModel?
        guard let stationViewModels = StationViewModel.fetchStationViewModels() else {
            return "0EUS"
        }
        stationViewModels.forEach {
            if $0.name?.localizedLowercase == "dünya" {
                worldStViewModel = $0
            }
        }
        
        guard let worldStationViewModel = worldStViewModel  else {
            return "0EUS"
        }
        let coordianteX = worldStationViewModel.coordinateX - favStation.coordinateX
        let coordianteY = worldStationViewModel.coordinateY - favStation.coordinateY
        let distace = coordianteX * coordianteX + coordianteY * coordianteY
        let distanceString = String(describing: Int64(sqrt(distace)))
        return "\(distanceString)EUS"
    }
    
    public func getWorldStation() -> Station? {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            let tempStations = stations.filter {
                $0.name?.localizedLowercase == "dünya"
            }
            
            if tempStations.count > 0 {
                TravelerViewModel.getTravelViewModel().fetchTraveler()?.coordinateX = tempStations.first!.coordinateX
                TravelerViewModel.getTravelViewModel().fetchTraveler()?.coordinateY = tempStations.first!.coordinateY
                TravelerViewModel.getTravelViewModel().fetchTraveler()?.station = tempStations.first!
                delegate.saveContext()
                return tempStations.first
            }
            return nil
            
        } catch let error as NSError {
            print("Staion Fav \(error)")
            return nil
        }
    }
}
