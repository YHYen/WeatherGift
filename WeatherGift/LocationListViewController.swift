//
//  ViewController.swift
//  WeatherGift
//
//  Created by 顏逸修 on 2023/4/4.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addLocationBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var weatherLocations = WeatherLocations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        weatherLocations.weatherLocationArray.append(WeatherLocation(name: "Taipei", latitude: 0.0, longitude: 0.0))
        weatherLocations.weatherLocationArray.append(WeatherLocation(name: "TaiChung", latitude: 0.0, longitude: 0.0))
        weatherLocations.weatherLocationArray.append(WeatherLocation(name: "Tainan", latitude: 0.0, longitude: 0.0))
    }
    
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addLocationBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addLocationBarButton.isEnabled = false
        }
    }
    
    
    
    @IBAction func addLocationBarButtonPressed(_ sender: Any) {
    }
}

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return tableView rows number
        return weatherLocations.weatherLocationArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = weatherLocations.weatherLocationArray[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherLocations.weatherLocationArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations.weatherLocationArray[sourceIndexPath.row]
        weatherLocations.weatherLocationArray.remove(at: sourceIndexPath.row)
        weatherLocations.weatherLocationArray.insert(itemToMove, at: destinationIndexPath.row)
    }
}
