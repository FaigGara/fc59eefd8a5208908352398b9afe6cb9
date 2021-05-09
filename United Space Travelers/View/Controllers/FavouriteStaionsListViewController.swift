//
//  FavouriteStaionsListViewController.swift
//  United Space Travelers
//
//  Created by Faiq on 8.05.2021.
//

import UIKit

class FavouriteStaionsListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var stationViewModels = StationViewModel.getFavStationViewModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FavouriteStationTableViewCell", bundle: nil), forCellReuseIdentifier: "favStationsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stationViewModels = StationViewModel.getFavStationViewModels()
        tableView.reloadData()
    }


}

extension FavouriteStaionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension FavouriteStaionsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationViewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favStationsCell", for: indexPath) as! FavouriteStationTableViewCell
        if let station = stationViewModels?[indexPath.row] {
            cell.station = station
            cell.distance = StationAndTravelerJsonViewModel().worldStationAndFavStationsEusDistance(favStation: station)
        }
        cell.delegate = self
        return cell
    }
}

extension FavouriteStaionsListViewController: FavouriteStationTableViewCellDelegate {
    func favouriteStationTableViewCellButtonFavTapped() {
        stationViewModels = StationViewModel.getFavStationViewModels()
        tableView.reloadData()
    }
}
