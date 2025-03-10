//
//  ParseViewController.swift
//  CoreGPX_Example
//
//  Created by Vincent on 12/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import CoreGPX

class ParseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var tracks = [GPXTrack]()
    var waypoints = [GPXWaypoint]()
    var waypoint = GPXWaypoint()
    var trackpoint = GPXTrackPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.autocorrectionType = .no
        trackpoint = GPXTrackPoint(latitude: 2, longitude: 0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPress(_ sender: Any) {
        
        let input = inputTextField.text
        
        if input != nil {
            if let inputURL = URL(string: input!) {
                guard let gpx = GPXParser(withURL: inputURL)?.parsedData() else { return }
                self.tracks = gpx.tracks
                self.waypoints = gpx.waypoints
                self.tableView.reloadData()
                print("gpx creator: \(gpx.creator ?? "") ver: \(gpx.version ?? "")")
            }
        }
    }
    
    func trackpointsCount() -> Int {
        var totalCount: Int = 0
        for track in self.tracks {
            for trackSegment in track.tracksegments {
                totalCount += trackSegment.trackpoints.count
            }
        }
        return totalCount
    }
    func waypointsCount() -> Int {
        var totalCount: Int = 0
        totalCount = self.waypoints.count
        return totalCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return waypointsCount()
        }
        else {
            return trackpointsCount()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Waypoints"
        }
        else {
            return "Trackpoints"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if indexPath.section == 0 { //waypoints
    
            var coordinates = [String]()
            var subtitles = [String]()
            
            for waypoint in self.waypoints {
        
                coordinates.append("Lat=\(waypoint.latitude ?? 0), Lon=\(waypoint.longitude ?? 0)")
                subtitles.append("Date:\(waypoint.time ?? Date()), Ele:\(waypoint.elevation ?? 0)")
                
            }
        
            cell.textLabel?.text = coordinates[indexPath.row]
            cell.detailTextLabel?.text = subtitles[indexPath.row]
        }
            
        else {
            
            var coordinates = [String]()
            var subtitles = [String]()
            
            for track in self.tracks {
                for tracksegment in track.tracksegments {
                    for trackpoint in tracksegment.trackpoints {
                        
                        coordinates.append("Lat=\(trackpoint.latitude!), Lon=\(trackpoint.longitude!)")
                        subtitles.append("Date:\(trackpoint.time ?? Date()), Ele:\(trackpoint.elevation ?? 0), Ext:\(trackpoint.extensions?[nil] ?? [String:String]())")
                        
                    }
                }
            }
            cell.textLabel?.text = coordinates[indexPath.row]
            cell.detailTextLabel?.text = subtitles[indexPath.row]
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
