//
//  ConfigureController.swift
//  Timer
//
//  Created by Carlos on 18/07/23.
//

import UIKit
import AVFoundation

class ConfigureController: UIViewController {
    
    @IBOutlet weak var allFunctionsCheckBoxButton: UIButton!
    @IBOutlet weak var onlyVibrateButton: UIButton!
    @IBOutlet weak var onlySoundButton: UIButton!
    
    
    @IBOutlet weak var chooseVibrateButton: UIButton!
    @IBOutlet weak var chooseSoundButton: UIButton!
    
    lazy var setSound1 = { (action: UIAction) in
        self.setSound(sound: 0)
    }
    
    lazy var setSound2 = { (action: UIAction) in
        self.setSound(sound: 1)
    }
    
    lazy var setVibrate1 = { (action: UIAction) in
        self.setVibrate(level: 0)
    }
    
    lazy var setVibrate2 = { (action: UIAction) in
        self.setVibrate(level: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupButtons()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func setupButtons() {
        allFunctionsCheckBoxButton.setTitle(TimerModel().allFunctionsButton, for: .normal)
        onlySoundButton.setTitle(TimerModel().onlySoundButton, for: .normal)
        onlyVibrateButton.setTitle(TimerModel().onlyVibrateButton, for: .normal)
        chooseSoundButton.setTitle(TimerModel().chooseSoundButton, for: .normal)
        chooseVibrateButton.setTitle(TimerModel().chooseVibrateButton, for: .normal)
        
        chooseSoundButton.isEnabled = false
        chooseVibrateButton.isEnabled = false
        
        allFunctionsCheckBoxButton.tag = 0
        onlyVibrateButton.tag = 1
        onlySoundButton.tag = 2
        
        chooseSoundButton.menu = UIMenu(children: [UIAction(title: TimerModel().sound1, handler: setSound1),
                                                   UIAction(title: TimerModel().sound2, handler: setSound2)])
        chooseVibrateButton.menu = UIMenu(children: [UIAction(title: TimerModel().vibrate1, handler: setVibrate1),
                                                   UIAction(title: TimerModel().vibrate2, handler: setVibrate2)])
    }
    
    @IBAction func checkBoxHandler(_ sender: UIButton) {
        
        switch sender.tag {
        case 0: //All functions
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                allFunctionsCheckBoxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                onlySoundButton.isEnabled = false
                onlyVibrateButton.isEnabled = false
                chooseSoundButton.isEnabled = true
                chooseVibrateButton.isEnabled = true
            } else {
                allFunctionsCheckBoxButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                onlySoundButton.isEnabled = true
                onlyVibrateButton.isEnabled = true
                chooseSoundButton.isEnabled = false
                chooseVibrateButton.isEnabled = false
            }
            print(sender.isSelected)
            
        case 1: // Only Vibrate
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                onlyVibrateButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                onlySoundButton.isEnabled = false
                allFunctionsCheckBoxButton.isEnabled = false
                chooseVibrateButton.isEnabled = true
                chooseSoundButton.isEnabled = false
            } else {
                onlyVibrateButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                onlySoundButton.isEnabled = true
                allFunctionsCheckBoxButton.isEnabled = true
                chooseVibrateButton.isEnabled = false
                chooseSoundButton.isEnabled = false
            }
        case 2: // Only Sound
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                onlySoundButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                onlyVibrateButton.isEnabled = false
                allFunctionsCheckBoxButton.isEnabled = false
                chooseVibrateButton.isEnabled = false
                chooseSoundButton.isEnabled = true
            } else {
                onlySoundButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                onlyVibrateButton.isEnabled = true
                allFunctionsCheckBoxButton.isEnabled = true
                chooseVibrateButton.isEnabled = false
                chooseSoundButton.isEnabled = false
            }
        default:
            break
        }
    }
    
    
    func setSound(sound: Int) {
        print("sound: ", sound)
    }
    
    func setVibrate(level: Int) {
        print("vibrate: ", level)
        switch level {
        case 0:
            var timerCount = 0
             Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {  timer in
                UIDevice.vibrate()
                 timerCount += 1
                 
                 if timerCount == 5 {
                     timer.invalidate()
                 }
            }
        case 1:
            var timerCount = 0
            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) {  timer in
                UIDevice.vibrate()
                 timerCount += 1
                 
                 if timerCount == 40 {
                     timer.invalidate()
                 }
            }
        default:
            break
        }
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
