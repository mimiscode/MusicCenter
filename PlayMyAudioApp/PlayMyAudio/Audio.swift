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
    private var player: AVAudioPlayer?;
    
    init(audioId:Int, audioData:String){
        self.audioId = audioId;
        self.audioData = audioData;
    }
    
    //Decode base64 String from Audio object
    func decodeBase64String(base64String: String ){
        let decodeString = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0));
        print("DecodeString: \(decodeString)");
        
        playAudio(audioData: decodeString!);
    }
    
    //Play Audio with infinite loop
    func playAudio(audioData : NSData) {
        if let player = try?AVAudioPlayer(data: audioData as Data) {
            player.play();
            player.numberOfLoops = -1
            //player.currentTime = 2 // décalage du son de 2 secondes
            self.player = player
        }
        
        
    }

}
