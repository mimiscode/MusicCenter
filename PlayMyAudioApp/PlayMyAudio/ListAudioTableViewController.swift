//
//  ListAudioTableViewController.swift
//  PlayMyAudio
//
//  Created by Yannick Noël on 27/11/2016.
//  Copyright © 2016 Tracy Sablon. All rights reserved.
//

import UIKit
import AVFoundation

class ListAudioTableViewController: UITableViewController {
    
    let localURL = "http://localhost:8000/";
    var playlistArray :[Audio] = [];
    var tracks :[NSData] = [];
    var dataArray :[Audio] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getAllPlaylist();

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    //print("MainQueue :\(track)");
                    let decodeTrack = track.decodeBase64String(base64String: track.audioData);
                    //print("Binary track :\(decodeTrack)");
                    self.tracks.append(decodeTrack);
                }
                //self.playAudio(audioData: self.tracks[1]);
                self.tableView.reloadData()
            }
            
            
        });
        
        task.resume();
        
    }
    
    //Parse JSON result
    func parseJson(data:Data) -> Array<Audio>{
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ListAudioTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AudioTableViewCell

        // Fetches the appropriate audio for the data source layout.
        let audioInt = dataArray[indexPath.row]
        let audioData = tracks[indexPath.row]
        
        cell.idTrack.text = String(audioInt.audioId)
        cell.varPlay = audioData as Data

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
