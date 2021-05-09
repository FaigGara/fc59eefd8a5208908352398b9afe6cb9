//
//  StationViewModel.swift
//  United Space Travelers
//
//  Created by Faiq on 7.05.2021.
//

import UIKit
import CoreData

struct StationViewModel: Decodable {
    let name: String?
    let coordinateX: Float
    let coordinateY: Float
    let capacity: Int64
    
    var need: Int64
    var stock: Int64
    
    public func saveCoreData(isFav: Bool, wasTravel: Bool) {
        DispatchQueue.main.async {
            guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = delegate.persistentContainer.viewContext
            let station = Station(context: managedContext)
            station.name = name
            station.coordinateX = coordinateX
            station.coordinateY = coordinateY
            station.capasity = capacity
            station.need = need
            station.stock = stock
            station.isFav = isFav
            if name?.localizedLowercase == "dünya" {
                station.wasTravel = true
                TravelerViewModel.getTravelViewModel().fetchTraveler()?.station = station
            }else {
                station.wasTravel = wasTravel
            }
            
            delegate.saveContext()
        }
    }
    
    static func fetchStationViewModels() -> [StationViewModel]? {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            var stViewModels = [StationViewModel]()
            if stations.count > 0 {
                for station in stations {
                    let stViewModel = StationViewModel(name: station.name, coordinateX: station.coordinateX, coordinateY: station.coordinateY, capacity: station.capasity, need: station.need, stock: station.stock)
                    stViewModels.append(stViewModel)
                }
                return stViewModels
            }
            return nil
            
        } catch let error as NSError {
            print("Staion \(error)")
            return nil
        }
    }
    
    private func fetchStation() -> Station? {
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
                $0.name == name
            }
            
            if tempStations.count > 0 {
                return tempStations.first
            }
            return nil
            
        } catch let error as NSError {
            print("Staion Fav \(error)")
            return nil
        }
    }
    
    static func getFavStationViewModels() -> [StationViewModel]? {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            var stViewModels = [StationViewModel]()
            if stations.count > 0 {
                for station in stations {
                    if station.isFav {
                        let stViewModel = StationViewModel(name: station.name, coordinateX: station.coordinateX, coordinateY: station.coordinateY, capacity: station.capasity, need: station.need, stock: station.stock)
                        stViewModels.append(stViewModel)
                    }
                }
                return stViewModels
            }
            return nil
            
        } catch let error as NSError {
            print("Staion \(error)")
            return nil
        }
    }
    
    public func stationIsFav() -> Bool {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            let tempStations = stations.filter {
                $0.name == name
            }
            
            if tempStations.count > 0 {
                let station = tempStations.first
                return station!.isFav
            }
            return false
        } catch let error as NSError {
            print("Staion \(error)")
        }
        return false
    }
    
    public func getStationWasTravel() -> Bool {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            let tempStations = stations.filter {
                $0.name == name
            }
            
            if tempStations.count > 0 {
                let station = tempStations.first
                if(station!.name?.localizedLowercase == "dünya") {
                    return false
                }
                return station!.wasTravel
            }
            return false
        } catch let error as NSError {
            print("Staion Traveled \(error)")
        }
        return false
    }
    
    public func setStationFav() {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            let tempStations = stations.filter {
                $0.name == name
            }
            
            if tempStations.count > 0 {
                let station = tempStations.first
                station!.isFav = !station!.isFav
                delegate.saveContext()
            }
            
        } catch let error as NSError {
            print("Staion Fav \(error)")
        }
    }
    
    public func setStationTravelInfo() {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            let tempStations = stations.filter {
                $0.name == name
            }
            
            if tempStations.count > 0 {
                let station = tempStations.first
                station!.wasTravel = true
                delegate.saveContext()
            }
            
        } catch let error as NSError {
            print("Staion Fav \(error)")
        }
    }
    
    public func getStationTravelInfo() -> Bool {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            let tempStations = stations.filter {
                $0.name == name
            }
            
            if tempStations.count > 0 {
                let station = tempStations.first
                return station!.wasTravel
            }
            return false
            
        } catch let error as NSError {
            print("Station Fav \(error)")
            return false
        }
    }
    
    public func getWorldStationViewModel() -> StationViewModel? {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = delegate.persistentContainer.viewContext
        var stations: [Station] = []
        do {
            let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let f = try managedContext.fetch(r)
            stations = f as! [Station]
            if stations.count > 0 {
                for station in stations {
                    if station.name?.localizedLowercase == "dünya" {
                        let stViewModel = StationViewModel(name: station.name, coordinateX: station.coordinateX, coordinateY: station.coordinateY, capacity: station.capasity, need: station.need, stock: station.stock)
                        return stViewModel
                    }
                }
                return nil
            }
            return nil
            
        } catch let error as NSError {
            print("Staion \(error)")
            return nil
        }
    }
    
    public func startTravel() {
        if let station = fetchStation(), let traveler = TravelerViewModel().fetchTraveler() {
            
            guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let materialCount = Int(traveler.materialCapasity - station.need)
            if materialCount > 0 {
                traveler.materialCapasity -= station.need
                station.need = 0
                station.stock = station.capasity
            }else {
                if traveler.materialCapasity > 0 {
                    station.stock += traveler.materialCapasity
                    station.need -= traveler.materialCapasity
                    traveler.materialCapasity = 0
                }else {
                    return
                }
            }
            
            traveler.speed -= calculateDistance(traveler: traveler, station: station)
            traveler.coordinateX = station.coordinateX
            traveler.coordinateY = station.coordinateY
            
            station.traveler = traveler
            traveler.station = station
            delegate.saveContext()
        }
    }
    
    private func calculateDistance(traveler: Traveler, station: Station) -> Int64 {
        let coordianteX = traveler.coordinateX - station.coordinateX
        let coordianteY = traveler.coordinateY - station.coordinateY
        let distaceSquare = coordianteX * coordianteX + coordianteY * coordianteY
        let distanceDouble = sqrt(distaceSquare)
        let distanceSqrt = Int64(distanceDouble)
        return distanceSqrt
    }
    
}
