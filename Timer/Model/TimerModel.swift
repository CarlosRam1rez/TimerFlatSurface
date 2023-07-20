//
//  TimerModel.swift
//  Timer
//
//  Created by Carlos on 18/07/23.
//

import Foundation
import UIKit

struct TimerModel {
    
    let waitMessage: String = "Configurando \nEsperando para iniciar... "
    let continueTimer: NSAttributedString =  NSAttributedString(string: "Reaunudar",
                                                                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 43)])
    let cancelTimer: NSAttributedString =  NSAttributedString(string: "Cancelar",
                                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 43)])
    let pauseTimer: NSAttributedString =  NSAttributedString(string: "Pausa",
                                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 43)])
    let startTimer: NSAttributedString =  NSAttributedString(string: "Comenzar",
                                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 43)])
    let configureButtonTitle: NSAttributedString =  NSAttributedString(string: "Configuración",
                                                                       attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                                                                                    NSAttributedString.Key.foregroundColor: UIColor .white])
    let commentButtonTitle: NSAttributedString =  NSAttributedString(string: "Comentarios",
                                                                     attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                                                                                  NSAttributedString.Key.foregroundColor: UIColor .white])
    let statusPauseButton: Int = 0
    let statusContinueButton: Int = 1
    let statusCancelButton: Int = 2
    let hours: [Int] = [23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
    let minutes: [Int] = [59,58,57,56,55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
    let seconds: [Int] = [59,58,57,56,55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
    let allFunctionsButton = "Vibración y Sonido"
    let onlyVibrateButton = "Sólo Vibración"
    let onlySoundButton = "Sólo Sonido"
    let sound1 = "Sonido 1"
    let sound2 = "Sonido 2"
    let vibrate1 = "Vibración 1"
    let vibrate2 = "Vibración 2"
    let chooseSoundButton = "Selecciona un Sonido"
    let chooseVibrateButton = "Selecciona una Vibración"
}


