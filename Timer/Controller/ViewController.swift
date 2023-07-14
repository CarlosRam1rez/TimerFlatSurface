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
    var counterHour: Int = 2
    var rotationRate: Double = 0.0
    
    var manager = CMMotionManager()
    var deviceMotionData = CMDeviceMotion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
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
        timer.invalidate()
        startButton.isHidden = false
        stopButton.isHidden = true
        messageLbl.isHidden = true
        
    }
    
    @objc func startTimer() {
        resetCounters()
        self.messageLbl.isHidden = false
        self.startButton.isHidden = true
        self.stopButton.isHidden = false
        timerRotation = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            
            let motion: CMAttitude = self.deviceMotionData.attitude
            DispatchQueue.main.async {
                let motionPitchDegrees = motion.pitch * 180 / .pi
                switch motionPitchDegrees {
                case 0 ... 0.45:
                    print("success")
                    print(motionPitchDegrees)
                    self.startCounters()
                    self.timerRotation.invalidate()
                default:
                    print("failure")
                }
            }
        }
    }
    
    private func resetCounters() {
        timerLbl.text = "\(String(format: "%02d : %02d : %02d", self.counterHour, self.counterMin, self.counterSec))"
    }
    
    private func startCounters() {
        messageLbl.isHidden = true
        self.counterSec = 59
        self.counterMin = 59
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
          }
    }
}

