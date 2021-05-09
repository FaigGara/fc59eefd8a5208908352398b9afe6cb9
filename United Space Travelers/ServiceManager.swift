//
//  ServiceManager.swift
//  United Space Travelers
//
//  Created by Faiq on 7.05.2021.
//

import UIKit

class ServiceManager: NSObject {
    static let sharedManager: ServiceManager = ServiceManager()
    
    func fetchStations(complation: @escaping (_ result: [StationViewModel]?, _ error: Error?) -> Void) {
        let stations:[StationViewModel]? = StationViewModel.fetchStationViewModels()
        if let stations = stations {
            complation(stations, nil)
        }else {
            let url = URL(string: "https://run.mocky.io/v3/e7211664-cbb6-4357-9c9d-f12bf8bab2e2")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                if error != nil {
                    complation(nil, error)
                }
                
                if let data = data {
                    guard let jsonString = String(data: data, encoding: .utf8) else{
                        complation(nil, error)
                        return
                    }
                    let jsonData = Data(jsonString.utf8)
                    
                    let decoder = JSONDecoder()
                    do {
                        let stations = try decoder.decode([StationViewModel].self, from: jsonData)
                        _ = stations.map { $0.saveCoreData(isFav: false, wasTravel: false) }
                        complation(stations, nil)
                    } catch {
                        complation(nil, error)
                    }
                    
                }
            }

            task.resume()
        }
    }
}
