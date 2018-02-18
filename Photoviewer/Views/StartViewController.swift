//
//  StartViewController.swift
//  Photoviewer
//
//  Created by Tomoya Matsuyama on 2018/02/17.
//  Copyright © 2018年 Tomoya Matsuyama. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBAction func startButtonTapped(_ sender: Any) {
        let vc = HomeViewController.instantiate()
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
