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
}
