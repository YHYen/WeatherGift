//
//  ViewController.swift
//  WeatherGift
//
//  Created by 顏逸修 on 2023/4/4.
//

import UIKit
import GooglePlaces

class LocationListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addLocationBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var weatherLocations = WeatherLocations()
    var selectedlocationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        weatherLocations.weatherLocationArray.append(WeatherLocation(name: "Taipei", latitude: 0.0, longitude: 0.0))
//        weatherLocations.weatherLocationArray.append(WeatherLocation(name: "TaiChung", latitude: 0.0, longitude: 0.0))
//        weatherLocations.weatherLocationArray.append(WeatherLocation(name: "Tainan", latitude: 0.0, longitude: 0.0))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedlocationIndex = tableView.indexPathForSelectedRow!.row
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
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true, completion: nil)
        
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
        cell.detailTextLabel?.text = "Lat:\(weatherLocations.weatherLocationArray[indexPath.row].latitude), Long:\(weatherLocations.weatherLocationArray[indexPath.row].longitude)"
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


extension LocationListViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let newLocation = WeatherLocation(name: place.name ?? "unknown place", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        weatherLocations.weatherLocationArray.append(newLocation)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
