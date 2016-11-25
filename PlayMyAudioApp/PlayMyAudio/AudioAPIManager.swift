//
//  AudioAPIManager.swift
//  PlayMyAudio
//
//  Created by Tracy Sablon on 24/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit

class AudioAPIManager: NSObject {
    static let sharedInstance = AudioAPIManager();
    
    let localURL = "http://localhost:8000/";
    
    //GET request to API : GET all audio file
    func getAllPlaylist() {
        let allplaylistURL = localURL+"playlist";
        guard let url = URL(string: allplaylistURL)else{
            print("Error: cannot create URL");
            return
        }
        
        getHTTPRequest(requestURL: url);
    }
    
    //GET request to API
    func getHTTPRequest(requestURL: URL) {
        
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        let url = requestURL;
        
        var audioArray :[Audio] = [];
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription);
            }else{
                
                //Parse JSON result
                do{
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]{
                        
                        if let audioList = json["list"] as? [[String:AnyObject]] {
                            print("OKAYYYY");
                            
                            for audioObj in audioList {
                                
                                if let id = audioObj["m_id"] as? Int{
                                    
                                    print("ID : \(id)");
                                    
                                    if let data = audioObj["m_data"] as? String{
                                        
                                        print("DATA OK!");
                                        //Create Audio Object from JSON result
                                        //Push it to an Array of Audio Object
                                        let audio = Audio(audioId: id, audioData: data);
                                        audioArray.append(audio);
                                        
                                        print(audioArray[0].audioData);
                                    }
                                    
                                }
                            }
                        }
                        
                        print(audioArray);
                    }
                }catch{
                    
                    print("error in JSONSerialisation");
                }
            }
        });
        
        task.resume();
        
        
        
    }
}
