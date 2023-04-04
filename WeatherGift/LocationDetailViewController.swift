//
//  LocationDetailViewController.swift
//  WeatherGift
//
//  Created by 顏逸修 on 2023/4/4.
//

import UIKit

class LocationDetailViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var weatherLocation: WeatherLocation!
    var weatherLocations = WeatherLocations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if weatherLocation == nil {
            weatherLocation = WeatherLocation(name: "Current Location", latitude: 0.0, longitude: 0.0)
            weatherLocations.weatherLocationArray.append(weatherLocation)
        }

        updateUserInterface()
    }
    
    
    func updateUserInterface() {
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        temperatureLabel.text = "--°C"
        summaryLabel.text = ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        destination.weatherLocations = weatherLocations
        
    }
    
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        weatherLocations = source.weatherLocations
        weatherLocation = weatherLocations.weatherLocationArray[source.selectedlocationIndex]
        updateUserInterface()
    }

}
