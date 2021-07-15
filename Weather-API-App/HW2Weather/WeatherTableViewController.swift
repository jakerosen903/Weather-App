//
//  WeatherTableViewController.swift
//  HW2Weather
//
//  Created by Jacob Rosen on 2/24/21.
//

import UIKit
import Foundation

class WeatherTableViewController: UITableViewController {
    
   
    @IBOutlet weak var timeLabel: UILabel!
    
    struct Weather: Decodable {
        var location: Location
        var current: Current
    }

    // MARK: - Location
    struct Location: Decodable {
        var name, region, country: String
        var lat, lon: Double
        var tzID: String
        var localtimeEpoch: Int
        var localtime: String

        enum CodingKeys: String, CodingKey {
            case name, region, country, lat, lon
            case tzID = "tz_id"
            case localtimeEpoch = "localtime_epoch"
            case localtime
        }
    }

    // MARK: - Current
    struct Current: Decodable {
        var lastUpdatedEpoch: Int
        var lastUpdated: String
        var tempC, tempF: Double
        var isDay: Int
        var condition: Condition
        var windMph, windKph: Double
        var windDegree: Int
        var windDir: String
        var pressureMB, pressureIn, precipMm, precipIn, humidity, cloud: Double
        var feelslikeC, feelslikeF, visKM: Double
        var visMiles, uv, gustMph, gustKph: Double

        enum CodingKeys: String, CodingKey {
            case lastUpdatedEpoch = "last_updated_epoch"
            case lastUpdated = "last_updated"
            case tempC = "temp_c"
            case tempF = "temp_f"
            case isDay = "is_day"
            case condition
            case windMph = "wind_mph"
            case windKph = "wind_kph"
            case windDegree = "wind_degree"
            case windDir = "wind_dir"
            case pressureMB = "pressure_mb"
            case pressureIn = "pressure_in"
            case precipMm = "precip_mm"
            case precipIn = "precip_in"
            case humidity, cloud
            case feelslikeC = "feelslike_c"
            case feelslikeF = "feelslike_f"
            case visKM = "vis_km"
            case visMiles = "vis_miles"
            case uv
            case gustMph = "gust_mph"
            case gustKph = "gust_kph"
        }
    }
    // MARK: - Condition
    struct Condition: Decodable {
        var text, icon: String
        var code: Int
    }

    
    
    
    struct cityWeather {
        var name = ""
        var temp = ""
        var forecast = ""
        var image: UIImage!
    }
   


    var cities: [String] = ["Durham,NC", "Miami,FL", "Austin,TX", "Raleigh,NC", "London,UK", "Munich,DE",  "Dublin,IE", "Jerusalem, IL", "Sydney,AU", "Vancouver,CA", "Albany,NY"]
        //var temps: [String] = ["78°", "78°", "77°", "80°", "82°", "81°"]
        //var forecasts: [String] = ["Cloudy", "Sunny", "Sunny", "Cloudy", "Rain", "Rain"]
       
    
        var cityWeathers: [cityWeather] = []
    let weatherImages: [String] = ["Sunny", "Snow", "Rain", "Cloudy"]
    var count = 0
        //matches cities with their weather files
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        timeLabel.text = getTime()
        
        
        for thisCity in cities{
            getData(city: thisCity)
        }
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    func getTime() -> String
    {
        var dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium

        return "The Weather at: \(dateFormatter.string(from: NSDate() as Date))"
        
        
    }
    func getData(city : String) {
        
        let headers = [
            "x-rapidapi-key": "e0fbbae25bmshf9f17eb9856c709p115a5ajsnc639955f5cb6",
            "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
        ]
        
        let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = [
                "x-rapidapi-key": "e0fbbae25bmshf9f17eb9856c709p115a5ajsnc639955f5cb6",
                "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
            ]
            config.timeoutIntervalForRequest = 1.0
            config.requestCachePolicy = .useProtocolCachePolicy
            
            let mySession = URLSession(configuration: config)
        
            let cityCode = city.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: ",", with: "%2C")
        
            let url = URL(string: ("https://weatherapi-com.p.rapidapi.com/current.json?q=" + cityCode))!
        
            print("method runs step 1")
        
                var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers

        
        let dataTask = mySession.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        
                        print ("Error: \(error!)")
                        DispatchQueue.main.async {
                        
                            let alert = UIAlertController(title: "Error - ", message: "Offline Connection Error", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                        }
                        return
                    }
                    
                    // ensure there is data returned from this HTTP response
                    guard let jsonData = data else {
                        print("No data")
                        return
                    }

                do {
                    print("method runs step 3")
                    
                    let weather = try JSONDecoder().decode(Weather.self, from: jsonData)
                    
                    //self.allWeatherInfos.append(weather)
                    let condition = weather.current.condition.text
                    //must set picture using the forecast
                    let weatherImage = UIImage(named: condition)
                    
                    self.cityWeathers.append(cityWeather(name: String(city.split(separator: ",")[0]), temp: " \(weather.current.tempF)", forecast: condition, image: weatherImage))
                    
                    DispatchQueue.main.async {
                    self.tableView.reloadData()
                                    }

                    
                    print("elements: " + String(self.cityWeathers.count))
                    
                    
                    
                }catch {
                    print("error 3")
                    print("JSONDecoder error : \(error)")
                }
            }
            dataTask.resume()
        print(cityWeathers.count)
        print("Data is loaded")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityWeathers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCell", for: indexPath) as! WeatherTableViewCell
                
        
        
        
                print(cities[indexPath.row])
        
                cell.cityLabel.text = cityWeathers[indexPath.row].name
                cell.tempLabel.text = String(cityWeathers[indexPath.row].temp) + "°"
              //  print(cityWeathers[indexPath.row].forecast)
    
            
        
        cell.weatherImage.image = self.getImage(forecast: cityWeathers[indexPath.row].forecast)
                
                
                return cell

        
        // Configure the cell...

    }
    
    func getImage (forecast: String) -> UIImage {
        
        if(forecast.contains("rain") || forecast.contains("Mist")){
            return (UIImage(named: "rain"))!}
        else if(forecast.contains("cloud") || forecast.contains("overcast")){
            return (UIImage(named: "Cloudy"))!}
        else if(forecast.contains("sun") || forecast.contains("clear")){
            return (UIImage(named: "Sunny"))!}
        else if(forecast.contains("snow") || forecast.contains("sleet")){
            return (UIImage(named: "Snow"))!
        }
        
        return UIImage(named: "Sunny")!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cityWeathers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        
                let temp = cityWeathers[fromIndexPath.row]
                cityWeathers.remove(at: fromIndexPath.row)
                cityWeathers.insert(temp, at: to.row)
            

    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        let destVC = segue.destination as! detailViewController
                let selectRow = tableView.indexPathForSelectedRow?.row
        destVC.city = cityWeathers[selectRow!].name
        let tempDouble = cityWeathers[selectRow!].temp
                let tempStr : String = String(tempDouble) + "°"
                destVC.temp = tempStr
        destVC.forecast = cityWeathers[selectRow!].forecast
        destVC.image = getImage(forecast: cityWeathers[selectRow!].forecast)

    }
    

}
