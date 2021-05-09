//
//  SpaceStationsListViewController.swift
//  United Space Travelers
//
//  Created by Faiq on 7.05.2021.
//

import UIKit

class SpaceStationsListViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var txtFldSearchStation: UITextField!
    @IBOutlet var labelTravelerUgs: UILabel!
    @IBOutlet var labelTravelerEus: UILabel!
    @IBOutlet var labelTravelerDs: UILabel!
    @IBOutlet var labelTravelerName: UILabel!
    @IBOutlet var txtFldTravelerDamageCapacity: UITextField!
    @IBOutlet var txtFldTravelerRemainingSecond: UITextField!
    @IBOutlet var labelTravelerLastStation: UILabel!
    @IBOutlet var buttonGoToLeftStation: UIButton!
    @IBOutlet var buttonGoToRightStation: UIButton!
    
    var stationAndTravelerJoinViewModel = StationAndTravelerJsonViewModel()
    
    var stationViewModels = [StationViewModel]()
    
    var timeCount = TravelerViewModel.getTravelViewModel().hardness / 1000
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "SpaceStationCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "spaceSationCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        txtFldSearchStation.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        txtFldSearchStation.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "searchIcon")
        txtFldSearchStation.leftView?.addSubview(imageView)
        prepareButtonImageColor()
        updateViewComponentsDatas()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(processTimer), userInfo: nil, repeats: true)
    }
    
    @objc func processTimer() {
        if let value = TravelerViewModel.getTravelViewModel().canContinueTheTravel().values.first, !value {
            timer?.invalidate()
            _ = stationAndTravelerJoinViewModel.getWorldStation()
            updateViewComponentsDatas()
            let key = TravelerViewModel.getTravelViewModel().canContinueTheTravel().keys.first
            showAlertForStop(message: key!)
            return
        }
        if timeCount == 0 {
            timer?.invalidate()
            _ = stationAndTravelerJoinViewModel.getWorldStation()
            updateViewComponentsDatas()
            showAlertForStop(message: "Zamanınız bitti.")
            return
        }
        timeCount -= 1
        TravelerViewModel.getTravelViewModel().updateHardness(count: 1000)
        updateViewComponentsDatas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        prepareButtonImageColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func prepareButtonImageColor() {
        if #available(iOS 11.0, *) {
            buttonGoToLeftStation.setImage(UIImage(named: "leftArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
            buttonGoToRightStation.setImage(UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    private func updateViewComponentsDatas() {
        labelTravelerName.text = stationAndTravelerJoinViewModel.traveler().name
        txtFldTravelerDamageCapacity.text = stationAndTravelerJoinViewModel.travelerRemainingDamegeCapacity()
        txtFldTravelerRemainingSecond.text = stationAndTravelerJoinViewModel.travelerRemainingSecond()
        labelTravelerUgs.text = stationAndTravelerJoinViewModel.travelerRemainingUgs()
        labelTravelerEus.text = stationAndTravelerJoinViewModel.travelerRemainingEus()
        labelTravelerDs.text = stationAndTravelerJoinViewModel.travelerRemainingDs()
        labelTravelerLastStation.text = stationAndTravelerJoinViewModel.traveler().fetchTraveler()?.station?.name
    }
    
    @IBAction func searchStations(_ sender: UITextField) {
        stationViewModels.removeAll()
        if let text = sender.text, text.count > 0 {
            StationViewModel.fetchStationViewModels()?.forEach {
                if ($0.name!.localizedLowercase.contains(text.localizedLowercase)) {
                    stationViewModels.append($0)
                }
            }
            
        }else {
            StationViewModel.fetchStationViewModels()?.forEach {
                stationViewModels.append($0)
            }
        }
        _ = stationAndTravelerJoinViewModel.stations(stations: stationViewModels)
        collectionView.reloadData()
    }
    
    @IBAction func buttonGoToLeftAction(_ sender: UIButton) {
        let indexPathRow = Int(collectionView.contentOffset.x / (view.frame.size.width - 100)) - 1
        let indexPath = IndexPath(row: indexPathRow, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    @IBAction func buttonGoToRightAction(_ sender: UIButton) {
        if collectionView.contentSize.width <= collectionView.contentOffset.x + collectionView.frame.size.width {
            return
        }
        let indexPathRow = Int(collectionView.contentOffset.x / (view.frame.size.width - 100)) + 1
        let indexPath = IndexPath(row: indexPathRow, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
}

extension SpaceStationsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension SpaceStationsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stationAndTravelerJoinViewModel.stations()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spaceSationCell", for: indexPath) as! SpaceStationCollectionViewCell
        if let station = stationAndTravelerJoinViewModel.stations()?[indexPath.row] {
            cell.station = station
            cell.travelerViewModel = stationAndTravelerJoinViewModel.traveler()
            cell.distance = stationAndTravelerJoinViewModel.stationAndTravelerEusDistance(stationIndex: indexPath.row)
        }
        cell.delegate = self
        return cell
    }

}

extension SpaceStationsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 10, height: collectionView.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension SpaceStationsListViewController: SpaceStationCollectionViewCellDelegate {
    func spaceStationCollectionViewCellGetLastStation(staitonViewModel: StationViewModel) {
        updateViewComponentsDatas()
        collectionView.reloadData()
    }
    
    func spaceStationCollectionViewCellCanNotTravel(statitonViewModel: StationViewModel) {
        self.showAlert(stationName: statitonViewModel.name ?? "bu")
    }
}

extension SpaceStationsListViewController: UIActionSheetDelegate {
    func showAlert(stationName: String) {

        let alert: UIAlertController = UIAlertController(title: "Bilgi", message: "Daha Önce \(stationName) İstasyonda bulundunuz...", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Tamam", style: .cancel) { _ in
        }
        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertForStop(message: String) {

        let alert: UIAlertController = UIAlertController(title: "Bilgi", message: "\(message). Dünyaya geri döndünüz.", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Tamam", style: .cancel) { _ in
        }
        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
    }
}
