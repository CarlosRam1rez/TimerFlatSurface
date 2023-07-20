//
//  SideMenuController.swift
//  Timer
//
//  Created by Carlos on 18/07/23.
//

import Foundation
import UIKit

protocol SideMenuProtocol: Any {
    func pushToCommentView()
    func pushToConfigureView()
}


class SideMenuController: UIViewController {
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var configureButoon: UIButton!
    
    var delegate: SideMenuProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        commentButton.addTarget(self, action: #selector(showCommentView), for: .touchUpInside)
        configureButoon.addTarget(self, action: #selector(showConfigureView), for: .touchUpInside)
        commentButton.setAttributedTitle(TimerModel().commentButtonTitle, for: .normal)
        configureButoon.setAttributedTitle(TimerModel().configureButtonTitle, for: .normal)
    }
    
}

extension SideMenuController {
    
    @objc func showCommentView() {
        dismiss(animated: true)
        delegate?.pushToCommentView()
    }
    
    @objc func showConfigureView() {
        dismiss(animated: true)
        delegate?.pushToConfigureView()
    }
}
