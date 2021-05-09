//
//  TravelerConfigurationViewController.swift
//  United Space Travelers
//
//  Created by Faiq on 7.05.2021.
//

import UIKit

class TravelerConfigurationViewController: UIViewController {
    @IBOutlet var txtFldSpaceCraftName: UITextField!
    @IBOutlet var buttonContinue: UIButton!
    @IBOutlet var txtFldMaxScore: UITextField!
    
    @IBOutlet var hardnessSlider: UISlider!
    @IBOutlet var materialCapasitySlider: UISlider!
    @IBOutlet var speedSlider: UISlider!
    
    var travelerViewModel = TravelerViewModel.getTravelViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewComponents()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        prepareButtonLayerBorderColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func prepareViewComponents() {
        
        hardnessSlider.minimumValue = 0
        materialCapasitySlider.minimumValue = 0
        speedSlider.minimumValue = 0
        
        hardnessSlider.maximumValue = 15
        materialCapasitySlider.maximumValue = 15
        speedSlider.maximumValue = 15
        
        
        hardnessSlider.value = Float(travelerViewModel.hardness / 10000)
        materialCapasitySlider.value = Float(travelerViewModel.materialCapasity / 10000)
        speedSlider.value = Float(travelerViewModel.speed / 20)
        
        
        txtFldSpaceCraftName.delegate = self
        txtFldSpaceCraftName.text = travelerViewModel.name
        
        txtFldMaxScore.text = travelerViewModel.getTotalScore()
        
        buttonContinue.layer.borderWidth = 1
        prepareButtonLayerBorderColor()
    }
    
    private func prepareButtonLayerBorderColor() {
        if #available(iOS 11.0, *) {
            buttonContinue.layer.borderColor = UIColor.init(named: "buttonLayerColor")?.cgColor
        } else {
            buttonContinue.layer.borderColor = UIColor.black.cgColor
        }
    }

    @IBAction func contunieButtonAction(_ sender: UIButton) {
        let message = travelerViewModel.saveTravelerInformation()
        if message.count > 0 {
            self.showAlert(message: message)
            return
        }
        ServiceManager.sharedManager.fetchStations { (results, error) in
            guard let results = results, results.count > 0 else {
                self.showAlert(message: error?.localizedDescription ?? "Servisten beklenmedik bir hata alındı.")
                return
            }
            
            DispatchQueue.main.async {
                if let customTabbarController: CustomTabbarController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabbarController") as? CustomTabbarController {
                    customTabbarController.modalPresentationStyle = .fullScreen
                    self.present(customTabbarController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func hardnessSliderChange(_ sender: UISlider) {
        travelerViewModel.hardness = Int64(sender.value) * 10000
        txtFldMaxScore.text = travelerViewModel.getTotalScore()
    }
    
    @IBAction func materialCapasitySliderChange(_ sender: UISlider) {
        travelerViewModel.materialCapasity = Int64(sender.value) * 10000
        txtFldMaxScore.text = travelerViewModel.getTotalScore()
    }
    
    @IBAction func speedSliderChange(_ sender: UISlider) {
        travelerViewModel.speed = Int64(sender.value) * 20
        txtFldMaxScore.text = travelerViewModel.getTotalScore()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        travelerViewModel.name = sender.text ?? ""
    }
}

extension TravelerConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TravelerConfigurationViewController: UIActionSheetDelegate {
    func showAlert(message: String) {

        let alert: UIAlertController = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Tamam", style: .cancel) { _ in
        }
        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
    }
}
