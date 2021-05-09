//
//  SpaceStationCollectionViewCell.swift
//  United Space Travelers
//
//  Created by Faiq on 7.05.2021.
//

import UIKit

protocol SpaceStationCollectionViewCellDelegate {
    func spaceStationCollectionViewCellGetLastStation(staitonViewModel: StationViewModel)
    func spaceStationCollectionViewCellCanNotTravel(statitonViewModel: StationViewModel)
}

class SpaceStationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var backView: UIView!
    @IBOutlet var buttonTravel: UIButton!
    @IBOutlet var buttonFav: UIButton!
    @IBOutlet var labelMaterialInformation: UILabel!
    @IBOutlet var labelDistance: UILabel!
    @IBOutlet var labelStationName: UILabel!
    
    var distance: String? {
        didSet {
            labelDistance.text = distance
        }
    }
    
    var delegate: SpaceStationCollectionViewCellDelegate?
    
    var station: StationViewModel! {
        didSet {
            if let station = station {
                labelStationName.text = station.name
                labelMaterialInformation.text = "\(String(describing: station.capacity))/\(String(describing: station.stock))"
                prepareFavButtonImage()
                prepareButtonTravelText()
            }
        }
    }
    
    var travelerViewModel: TravelerViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareViewComponents()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        prepareViewsColor()
    }
    
    public func prepareFavButtonImage() {
        if station != nil {
            let isFav: Bool = station!.stationIsFav()
            if isFav {
                buttonFav.setImage(UIImage(named: "fav")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }else {
                buttonFav.setImage(UIImage(named: "emptyFav")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        }
    }
    
    private func prepareButtonTravelText() {
        if let station = station, station.getStationTravelInfo() {
            buttonTravel.setTitle("Traveled", for: .normal)
        }else {
            buttonTravel.setTitle("Travel", for: .normal)
        }
    }
    
    private func prepareViewComponents() {
        backView.layer.borderWidth = 1
        backView.layer.cornerRadius = 20
        
        buttonTravel.layer.borderWidth = 1
        
        prepareViewsColor()
    }
    
    private func prepareViewsColor() {
        if #available(iOS 11.0, *) {
            backView.layer.borderColor = UIColor.init(named: "buttonLayerColor")?.cgColor
            buttonTravel.layer.borderColor = UIColor.init(named: "buttonLayerColor")?.cgColor
            buttonFav.tintColor = UIColor.init(named: "buttonLayerColor")
        } else {
            backView.layer.borderColor = UIColor.black.cgColor
            buttonTravel.layer.borderColor = UIColor.black.cgColor
            buttonFav.tintColor = .black
        }
    }
    
    @IBAction func buttonFavAction(_ sender: UIButton) {
        if station != nil {
            let isFav: Bool = station!.stationIsFav()
            if isFav {
                buttonFav.setImage(UIImage(named: "emptyFav")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }else {
                buttonFav.setImage(UIImage(named: "fav")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            station?.setStationFav()
        }
    }
    
    @IBAction func buttonTravelAction(_ sender: Any) {
        if let s = station, s.getStationWasTravel() {
            delegate?.spaceStationCollectionViewCellCanNotTravel(statitonViewModel: s)
            return
        }
        if station.isTravelSuitableForTraveler() {
            station.setStationTravelInfo()
            station.startTravel()
            prepareButtonTravelText()
            delegate?.spaceStationCollectionViewCellGetLastStation(staitonViewModel: station!)
            if !station.isTravelSuitableForTraveler() {
                returnToWorldStation()
            }
            
        }else {
            returnToWorldStation()
        }
    }
    
    private func returnToWorldStation() {
        if let s = self.station.getWorldStationViewModel() {
            delegate?.spaceStationCollectionViewCellGetLastStation(staitonViewModel: s)
        }
    }
}
