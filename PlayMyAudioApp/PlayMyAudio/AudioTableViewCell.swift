//
//  AudioTableViewCell.swift
//  PlayMyAudio
//
//  Created by Yannick Noël on 27/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTableViewCell: UITableViewCell {
    
    var player: AVAudioPlayer?
    var varPlay: Data?
    @IBOutlet weak var idTrack: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func actionPlay(_ sender: UIButton) {
        if let player = try?AVAudioPlayer(data: self.varPlay!) {
            player.play();
            player.numberOfLoops = -1
            //player.currentTime = 2 // décalage du son de 2 secondes
            self.player = player
        }
    }
}
