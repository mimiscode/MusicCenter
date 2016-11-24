//
//  ViewController.swift
//  PlayMyAudio
//
//  Created by Tracy Sablon on 24/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let audioManager = AudioAPIManager();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioManager.getAllPlaylist();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

