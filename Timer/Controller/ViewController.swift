//
//  ViewController.swift
//  Timer
//
//  Created by Carlos on 12/07/23.
//

import UIKit
import CoreMotion

class TimerController: UIViewController {
    
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var timer = Timer()
    var timerRotation = Timer()
    
    var counterSec: Int = 0
    var counterMin: Int = 0
    var counterHour: Int = 1
    var rotationRate: Double = 0.0
    
    var manager = CMMotionManager()
    var deviceMotionData = CMDeviceMotion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupButtons()
        manager.startDeviceMotionUpdates(to: OperationQueue()) { (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            self.deviceMotionData = data
            self.manager.deviceMotionUpdateInterval = 0.5
        }
        timerLbl.text = "\(String(format: "%02d : %02d : %02d", self.counterHour, self.counterMin, self.counterSec))"
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
        switch startButton.tag {
        case TimerModel().statusCancelButton:
            resetCounters()
        default:
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
        counterHour = 1
        timerLbl.text = "\(String(format: "%02d : %02d : %02d", counterHour, counterMin, counterSec))"
        startButton.setAttributedTitle(TimerModel().startTimer, for: .normal)
        startButton.backgroundColor = .systemOrange
        timerRotation.invalidate()
        timer.invalidate()
        stopButton.isHidden = true
        stopButton.tag = TimerModel().statusPauseButton
        startButton.tag = TimerModel().statusPauseButton
    }
    
    private func startCounters() {
        messageLbl.isHidden = true
        startButton.isHidden = false
        startButton.setAttributedTitle(TimerModel().cancelTimer, for: .normal)
        startButton.backgroundColor = .red
        stopButton.setAttributedTitle(TimerModel().pauseTimer, for: .normal)
        stopButton.backgroundColor = .systemOrange
        stopButton.tag = TimerModel().statusPauseButton
        if counterMin == 0 && counterSec == 0 {
            self.counterSec = 59
            self.counterMin = 59
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.00000005, repeats: true) { _ in
            self.counterSec -= 1
            if self.counterSec >= 0 {
                self.timerLbl.text = "\(String(format: "%02d : %02d : %02d", self.counterHour, self.counterMin, self.counterSec))"
            } else if self.counterMin > 0 {
                self.counterMin -= 1
                self.counterSec = 59
                self.timerLbl.text = "\(String(format: "%02d : %02d : %02d", self.counterHour, self.counterMin, self.counterSec))"
            } else if self.counterHour > 0 {
                self.counterHour -= 1
                self.counterMin = 59
                self.timerLbl.text = "\(String(format: "%02d : %02d : %02d", self.counterHour, self.counterMin, self.counterSec))"
            }
            
            if self.counterMin == 0 && self.counterSec == 0 && self.counterHour == 0 {
                //HERE sound and vibrate behaivor
                print("FINISHED!!!")
            }
          }
        
    }
    
    private func setupButtons() {
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
        startButton.layer.cornerRadius = 20
        stopButton.layer.cornerRadius = 20
    }
}

