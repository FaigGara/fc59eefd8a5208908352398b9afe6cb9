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
            buttonFav.setImage(UIImage(named: "fav")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    private func prepareViewComponents() {
        backView.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                backView.layer.borderColor = UIColor.black.cgColor
                buttonFav.tintColor = UIColor.black
            } else {
                backView.layer.borderColor = UIColor.white.cgColor
                buttonFav.tintColor = UIColor.white
            }
        }else {
            backView.layer.borderColor = UIColor.black.cgColor
            buttonFav.tintColor = UIColor.black
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
            buttonFav.setImage(UIImage(named: "emptyFav")?.withRenderingMode(.alwaysTemplate), for: .normal)
            station?.setStationFav()
            self.delegate?.favouriteStationTableViewCellButtonFavTapped()
        }
    }
    
}
