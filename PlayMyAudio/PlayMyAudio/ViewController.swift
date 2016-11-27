//
//  ViewController.swift
//  PlayMyAudio
//
//  Created by Tracy Sablon on 24/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let localURL = "http://localhost:8000/";
    var player: AVAudioPlayer?;
    var playlistArray :[Audio] = [];
    var tracks :[NSData] = [];
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAllPlaylist();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //Request to API : GET all audio data
    func getAllPlaylist() {
        
        let allplaylistURL = localURL+"playlist";
        guard let requestURL = URL(string: allplaylistURL)else{
            print("Error: cannot create URL");
            return
        }
        
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        let url = requestURL;
        //var dataDict = [Int : String]();
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            guard error == nil else{
                print(error!.localizedDescription);
                return
            }
            guard let responseData = data else{
                print("Error: did not receive data")
                return
            }
            
            self.playlistArray = self.parseJson(data: responseData);
            
            DispatchQueue.main.async {
                for track in self.playlistArray {
                    print("Binary track");
                    print("MainQueue :\(track)");
                    let decodeTrack = track.decodeBase64String(base64String: track.audioData);
                    print("Binary track :\(decodeTrack)");
                    self.tracks.append(decodeTrack);
                }
                self.playAudio(audioData: self.tracks[1]);
                 
            }
            
            
        });
        
        task.resume();
        
    }
    //Parse JSON result
    func parseJson(data:Data) -> Array<Audio>{
        var dataArray :[Audio] = [];
        do{
            if let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any]{
                
                if let audioList = json["list"] as? [[String:AnyObject]] {
                    
                    for audioObj in audioList {
                        
                        if let id = audioObj["m_id"] as? Int{
                            
                            print("ID : \(id)");
                            
                            if let data = audioObj["m_data"] as? String{
                                
                                print("DATA OBJ");
                                //Create Audio Object from JSON result
                                //Push it to an Array of Audio Object
                                let audio = Audio(audioId: id, audioData: data);
                                
                                dataArray.append(audio)
                                
                            }
                            
                        }
                    }
                }
                
            }
        }catch{
            
            print("error trying to convert data to JSON");
        }
        
        print("Count : \(dataArray.count)");
        //print("Dictionary : \(audioArray)\n");
        
        return dataArray;
    }

}

