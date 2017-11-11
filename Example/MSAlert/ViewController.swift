//
//  ViewController.swift
//  MSAlert
//
//  Created by Maor Shamsian on 11/11/2017.
//  Copyright © 2017 Maor Shamsian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonAction(_ sender: UIButton) {
        
        let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3")!
        
        MSAlert(viewController: self,
                sourceView: sender,
                title: "Change button color",
                message: "Are you sure?")
               .add(.ok,defaultImage: true)
               .add(.cancel)
               .setSound(from: soundURL).show { didPress in
                
                if didPress == .ok{
                    sender.setTitleColor(.red, for: .normal)
                }
                
        }
        
    }
}

