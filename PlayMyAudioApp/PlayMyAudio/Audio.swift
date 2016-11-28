//
//  Audio.swift
//  PlayMyAudio
//
//  Created by Tracy Sablon on 25/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import AVFoundation

class Audio: NSObject {
    
    var audioId : Int!;
    var audioData : String!;
    //private var player: AVAudioPlayer?;
    
    override init() {
    }
    
    init(audioId:Int, audioData:String){
        self.audioId = audioId;
        self.audioData = audioData;
    }
    
    //Decode base64 String from Audio object
    func decodeBase64String(base64String: String ) -> NSData{
        let decodeString = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0));
        //print("DecodeString: \(decodeString)");
        
        return decodeString!;
    }
}
