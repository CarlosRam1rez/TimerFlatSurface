//
//  ViewController.swift
//  Timer
//
//  Created by Carlos on 12/07/23.
//

import UIKit
import CoreMotion
import SideMenu
import AVFoundation

class TimerController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var sideMenuButton: UIButton!
    
    @IBOutlet weak var hoursTxtField: UITextField!
    @IBOutlet weak var minutesTxtField: UITextField!
    @IBOutlet weak var secondsTxtField: UITextField!
    
    var timer = Timer()
    var timerRotation = Timer()
    
    var counterSec: Int = 0
    var counterMin: Int = 0
    var counterHour: Int = 0
    var rotationRate: Double = 0.0
    
    var manager = CMMotionManager()
    var deviceMotionData = CMDeviceMotion()
    
    var menu: SideMenuNavigationController?
    
    var pickerView = UIPickerView()
    
    var soundOption: Int?
    var vibrateLevel: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupButtons()
        setupMotionUpdates()
        setupPickerView()
        menu?.leftSide = false
        SideMenuManager.default.rightMenuNavigationController = menu
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func stopTimer() {
        
        startButton.isHidden = false
        stopButton.isHidden = false
        messageLbl.isHidden = true
        
        switch stopButton.tag {
        case TimerModel().statusPauseButton:
            timer.invalidate()
            stopButton.setAttributedTitle(TimerModel().continueTimer, for: .normal)
            stopButton.tag = TimerModel().statusContinueButton
            timerUserInteraction(isEnable: false)
        case TimerModel().statusContinueButton:
            stopButton.setAttributedTitle(TimerModel().pauseTimer, for: .normal)
            stopButton.tag = TimerModel().statusPauseButton
            startCounters()
        case TimerModel().statusCancelButton:
            resetCounters()
        default:
            break
            
        }
        
    }
    
    @objc func startTimer() {
        if counterHour == 0 && counterMin == 0 && counterSec == 0 {
            let alert = UIAlertController(title: TimerModel().alertTitle, message: TimerModel().alertMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: TimerModel().alertOk, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        switch startButton.tag {
        case TimerModel().statusCancelButton:
            resetCounters()
        default:
            timerUserInteraction(isEnable: false)
            messageLbl.isHidden = false
            startButton.isHidden = true
            startButton.tag = TimerModel().statusCancelButton
            stopButton.isHidden = false
            stopButton.setAttributedTitle(TimerModel().cancelTimer, for: .normal)
            stopButton.backgroundColor = .red
            stopButton.tag = TimerModel().statusCancelButton
            messageLbl.text = TimerModel().waitMessage
            checkRotationUpdate()
        }
    }
    
    private func checkRotationUpdate() {
        sideMenuButton.isEnabled = false
        timerRotation = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            let motion: CMAttitude = self.deviceMotionData.attitude
            DispatchQueue.main.async {
                let motionPitchDegrees = motion.pitch * 180 / .pi
                switch motionPitchDegrees {
                case  0.1 ... 2.0:
                    print("success")
                    print(motionPitchDegrees)
                    self.startCounters()
                    self.timerRotation.invalidate()
                default:
                    print("failure")
                    print(motionPitchDegrees)
                }
            }
        }
    }
    
    private func resetCounters() {
        counterMin = 0
        counterSec = 0
        counterHour = 0
        hoursTxtField.text = "\(String(format: "%02d", counterHour))"
        minutesTxtField.text = "\(String(format: "%02d", counterMin))"
        secondsTxtField.text = "\(String(format: "%02d", counterSec))"
        startButton.setAttributedTitle(TimerModel().startTimer, for: .normal)
        startButton.backgroundColor = .systemOrange
        timerRotation.invalidate()
        timer.invalidate()
        stopButton.isHidden = true
        stopButton.tag = TimerModel().statusPauseButton
        startButton.tag = TimerModel().statusPauseButton
        timerUserInteraction(isEnable: true)
        sideMenuButton.isEnabled = true
    }
    
    private func startCounters() {
        messageLbl.isHidden = true
        startButton.isHidden = false
        startButton.setAttributedTitle(TimerModel().cancelTimer, for: .normal)
        startButton.backgroundColor = .red
        stopButton.setAttributedTitle(TimerModel().pauseTimer, for: .normal)
        stopButton.backgroundColor = .systemOrange
        stopButton.tag = TimerModel().statusPauseButton
        timer = Timer.scheduledTimer(withTimeInterval: 0.00000005, repeats: true) { _ in
            self.counterSec -= 1
            if self.counterSec >= 0 {
                self.setCounterValue()
            } else if self.counterMin > 0 {
                self.counterMin -= 1
                self.counterSec = 59
                self.setCounterValue()
            } else if self.counterHour > 0 {
                self.counterHour -= 1
                self.counterMin = 59
                self.self.setCounterValue()
            }
            
            if self.counterMin == 0 && self.counterSec == 0 && self.counterHour == 0 {
                //HERE sound and vibrate behaivor
                print("FINISHED!!!")
                self.soundAndVibrate()
                self.resetCounters()
            }
        }
        
    }
    
}
// MARK: - SetupUI
extension TimerController {
    private func setupButtons() {
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
        startButton.layer.cornerRadius = 20
        stopButton.layer.cornerRadius = 20
    }
    
    private func setupMotionUpdates() {
        manager.startDeviceMotionUpdates(to: OperationQueue()) { (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            self.deviceMotionData = data
            self.manager.deviceMotionUpdateInterval = 0.5
        }
        hoursTxtField.text = "\(String(format: "%02d", counterHour))"
        minutesTxtField.text = "\(String(format: "%02d", counterMin))"
        secondsTxtField.text = "\(String(format: "%02d", counterSec))"
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        hoursTxtField.inputView = pickerView
        minutesTxtField.inputView = pickerView
        secondsTxtField.inputView = pickerView
        hoursTxtField.tintColor = .clear
        minutesTxtField.tintColor = .clear
        secondsTxtField.tintColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPickerView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissPickerView() {
        self.view.endEditing(true)
    }
    
    private func timerUserInteraction(isEnable : Bool) {
        hoursTxtField.isUserInteractionEnabled = isEnable
        minutesTxtField.isUserInteractionEnabled = isEnable
        secondsTxtField.isUserInteractionEnabled = isEnable
    }
    
    private func setCounterValue() {
        self.hoursTxtField.text = "\(String(format: "%02d", self.counterHour))"
        self.minutesTxtField.text = "\(String(format: "%02d", self.counterMin))"
        self.secondsTxtField.text = "\(String(format: "%02d", self.counterSec))"
    }
}

// MARK: - SideMenu
extension TimerController: SideMenuProtocol {
    func pushToCommentView() {
        print("pushToCommentView")
    }
    
    func pushToConfigureView() {
        print("pushToConfigureView")
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfigureController") as? ConfigureController else { return }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSideMenu" {
            let navViewController = segue.destination as! SideMenuNavigationController
            let vc = navViewController.viewControllers.first as! SideMenuController
            vc.delegate = self
        }
    }
}

// MARK: - PickerView

extension TimerController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return TimerModel().hours.count
        case 1:
            return TimerModel().minutes.count
        case 2:
            return TimerModel().seconds.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return String(TimerModel().hours[row])
        case 1:
            return String(TimerModel().minutes[row])
        case 2:
            return String(TimerModel().seconds[row])
        default:
            return String()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            counterHour = TimerModel().hours[row]
            hoursTxtField.text = String(format: "%02d", TimerModel().hours[row])
        case 1:
            counterMin = TimerModel().minutes[row]
            minutesTxtField.text = String(format: "%02d",TimerModel().minutes[row])
        case 2:
            counterSec = TimerModel().seconds[row]
            secondsTxtField.text = String(format: "%02d",TimerModel().seconds[row])
        default:
            break
        }
        
    }
}

// MARK: - ConfigureController
extension TimerController: ConfigureControllerDelegate {
    func setupConfiguration(sound: Int?, vibrate: Int?) {
        self.soundOption = sound
        self.vibrateLevel = vibrate
        
    }
    
    func vibrateDevice(level: Int) {
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
    
    func playSound(type: Int) {

        let systemSoundID: SystemSoundID = type == 1 ? 1023 : 1033 // 1016tweet 1033 telegram
        var timerCount = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            AudioServicesPlaySystemSound(systemSoundID)
            timerCount += 1
            if timerCount == 5 {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Sound and Vibrate handler
extension TimerController {
    private func soundAndVibrate() {
        if vibrateLevel == nil && soundOption == nil { return }
        
        if vibrateLevel == nil && soundOption != nil {
            if let sound = soundOption {
                playSound(type: sound)
            }
        } else if vibrateLevel != nil && soundOption == nil {
            if let level = vibrateLevel {
                vibrateDevice(level: level)
            }
        } else {
            guard let vibrateLevel = vibrateLevel else { return }
            guard let soundOption = soundOption else { return }
            DispatchQueue.main.async {
                self.vibrateDevice(level: vibrateLevel)
                self.playSound(type: soundOption)
            }
        }
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
