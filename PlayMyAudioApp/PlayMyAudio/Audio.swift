//
//  Audio.swift
//  PlayMyAudio
//
//  Created by Tracy Sablon on 25/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit

class Audio: NSObject {
    
    var audioId : Int!;
    var audioData : String!;
    
    init(audioId:Int, audioData:String){
        self.audioId = audioId;
        self.audioData = audioData;
    }

}
