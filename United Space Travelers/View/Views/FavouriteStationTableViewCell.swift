//
//  FavouriteStationTableViewCell.swift
//  United Space Travelers
//
//  Created by Faiq on 8.05.2021.
//

import UIKit
protocol FavouriteStationTableViewCellDelegate {
    func favouriteStationTableViewCellButtonFavTapped()
}

class FavouriteStationTableViewCell: UITableViewCell {
    @IBOutlet var labelStationName: UILabel!
    @IBOutlet var labelDistanceEus: UILabel!
    @IBOutlet var buttonFav: UIButton!
    @IBOutlet var backView: UIView!
    
    var station: StationViewModel? {
        didSet {
            if let station = station {
                labelStationName.text = station.name
                prepareFavButtonImage()
            }
        }
    }
    
    var distance: String? {
        didSet {
            labelDistanceEus.text = distance
        }
    }
    
    var delegate: FavouriteStationTableViewCellDelegate?
    
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
    
    private func prepareViewComponents() {
        backView.layer.borderWidth = 1
        if #available(iOS 11.0, *) {
            backView.layer.borderColor = UIColor.init(named: "buttonLayerColor")?.cgColor
        }else {
            backView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        prepareViewComponents()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareViewComponents()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func buttonFavAction(_ sender: Any) {
        if station != nil {
            let isFav: Bool = station!.stationIsFav()
            if isFav {
                buttonFav.setImage(UIImage(named: "emptyFav")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }else {
                buttonFav.setImage(UIImage(named: "fav")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            station?.setStationFav()
            self.delegate?.favouriteStationTableViewCellButtonFavTapped()
        }
    }
    
}
