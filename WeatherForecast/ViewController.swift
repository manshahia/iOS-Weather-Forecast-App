//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Ravi Inder Manshahia on 08/11/18.
//  Copyright © 2018 Ravi Inder Manshahia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let stringToLookFor = "</h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func findOutPressed(_ sender: Any) {
        if let city = cityTextField.text
        {
            let APIKey = "https://www.weather-forecast.com/locations/" + city + "/forecasts/latest"
            findOutWeather(api : APIKey)
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func findOutWeather( api : String)
    {
        var message : String = "Unable to fetch data for your city."
        let url = URL(string: api)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error
            {
                print("Client Error: ", error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
                else
            {
                print("Server error::", response as Any)
                return
            }
            
            if let mimeType = httpResponse.mimeType,
                mimeType == "text/html",
                let data = data,
                let stringData = String( data: data, encoding: .utf8)
            {
                let firstSeparation = stringData.components(separatedBy: self.stringToLookFor)
                if firstSeparation.count > 0 {
                    let secondSeparation = firstSeparation[1].components(separatedBy: "</span>")
                    if(secondSeparation.count > 0)
                    {
                        message = secondSeparation[0].replacingOccurrences(of: "&deg;", with: "°")
                    }
                }
                
                
                
//                print("Weather is :  ", replaceHTMLElementsWithSigns)
                
                
                DispatchQueue.main.async(execute: {
                    self.resultLabel.text = message
                })
            }
        }
        task.resume()
    }
}












