//
//  TravelerViewModel.swift
//  United Space Travelers
//
//  Created by Faiq on 7.05.2021.
//

import UIKit
import CoreData

struct TravelerViewModel {
    var name: String = ""
    var speed: Int64 = 100
    var damageCapasity: Int64 = 100
    var materialCapasity: Int64 = 50000
    var hardness: Int64 = 50000
    var coordinateX: Float = 0.0
    var coordinateY: Float = 0.0
    
    init() {
        if let traveler =  fetchTraveler() {
            name = traveler.name ?? ""
            speed = traveler.speed
            materialCapasity = traveler.materialCapasity
            hardness = traveler.hardness
            coordinateX = traveler.coordinateX
            coordinateY = traveler.coordinateY
            damageCapasity = traveler.damageCapasity
        }
    }
    
    public mutating func saveTravelerInformation() -> String {
        
        if validateTravelerInfo().count > 0 {
            return validateTravelerInfo()
        }
        
        updateInformations()
        
        return ""
    }
    
    private func validateTravelerInfo() -> String{
        if name.count == 0 {
            return "Uzay geminize bir isim veriniz"
        }
        
        if speed == 0 {
            return "Hız 0 olamaz"
        }
        
        if materialCapasity == 0 {
            return "Kapasite 0 olamaz"
        }
        
        if hardness == 0 {
            return "Dayananıklılık 0 olamaz"
        }
        
        if Int64(self.getTotalScore()) ?? 0 > 15 {
            return "Dayananıklılık, Hız ve Kapasite toplam puanı 15den büyük olamaz"
        }
        
        return ""
    }
    
    public func getTravelerLastStation() -> Station? {
        return fetchTraveler()?.station
    }
    
    public func setTravelerLastStation(stantion: Station) {
        fetchTraveler()?.station = stantion
        if let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.saveContext()
        }
    }
    
    public func getTotalScore() -> String {
        let total = speed / 20 + hardness / 10000 + materialCapasity / 10000
        return String(describing: total)
    }
    
    public func fetchTraveler() -> Traveler? {
        if let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = delegate.persistentContainer.viewContext
            var travelers: [Traveler] = []
            do {
                let r = NSFetchRequest<NSFetchRequestResult>(entityName: "Traveler")
                let f = try managedContext.fetch(r)
                travelers = f as! [Traveler]
            } catch let error as NSError {
                print("Traveler \(error)")
            }
            
            if travelers.count > 0{
                return travelers.first!
            }else {
                return nil
            }
        }
        return nil
    }
    
    static func getTravelViewModel() -> Self {
        return TravelerViewModel()
    }
    
    mutating func updateInformations() {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        var traveler: Traveler!
        if let temptraveler = fetchTraveler() {
            traveler = temptraveler
        }else {
            let managedContext = delegate.persistentContainer.viewContext
            traveler = Traveler(context: managedContext)
        }
        
        traveler.name = name
        traveler.speed = speed
        traveler.materialCapasity = materialCapasity
        traveler.hardness = hardness
        traveler.coordinateX = coordinateX
        traveler.coordinateY = coordinateY
        traveler.damageCapasity = traveler.damageCapasity == 0 ? 100 : traveler.damageCapasity
        
        
        if let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.saveContext()
        }
    }
    
    public func updateHardness(count: Int64) {
        guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        var traveler: Traveler!
        if let temptraveler = fetchTraveler() {
            traveler = temptraveler
        }else {
            let managedContext = delegate.persistentContainer.viewContext
            traveler = Traveler(context: managedContext)
        }
        
        traveler.hardness = traveler.hardness - count
        if traveler.hardness == 0 {
            traveler.damageCapasity -= 10
        }
        
        if let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.saveContext()
        }
    }
    
    public func canContinueTheTravel() -> [String:Bool] {
        var traveler: Traveler!
        if let temptraveler = fetchTraveler() {
            traveler = temptraveler
        }else {
            return ["Traveler bulunamadı": false]
        }
        
        if traveler.materialCapasity == 0 {
            return ["UGS 0'landı": false]
        }
        
        if traveler.speed == 0 {
            return ["EUS 0'landı": false]
        }
        
        if traveler.hardness == 0 {
            return ["DS 0'landı": false]
        }
        
        if traveler.damageCapasity == 0 {
            return ["Hasar Kapasitesi 0'landı": false]
        }
        
        return ["": true]
    }
    
}
