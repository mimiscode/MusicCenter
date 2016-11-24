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
    
    func getAllPlaylist() {
        let allplaylistURL = localURL+"playlist";
        guard let url = URL(string: allplaylistURL)else{
            print("Error: cannot create URL");
            return
        }
        
        getHTTPRequest(requestURL: url);
    }
    
    func getHTTPRequest(requestURL: URL) {
        
        let config = URLSessionConfiguration.default;
        let session = URLSession(configuration: config);
        let url = requestURL;
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription);
            }else{
                
                do{
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]{
                        
                        print(json)
                    }
                }catch{
                    
                    print("error in JSONSerialisation");
                }
            }
        });
        
        task.resume();
        
    }
}
