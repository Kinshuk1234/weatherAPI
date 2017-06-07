//
//  ViewController.swift
//  API Demo
//
//  Created by Rob Percival on 21/06/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var cityTextField: UITextField!
    @IBAction func submit(_ sender: AnyObject) {
        
        var message = ""
        
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=" + cityTextField.text!.replacingOccurrences(of: " ", with: "%20") + ",uk&appid=08e64df2d3f3bc0822de1f0fc22fcb2d") {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in // URLSession.shared().dataTask(with: url) { (data, response, error) is now URLSession.shared.dataTask(with: url) { (data, response, error)
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if let urlContent = data {
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject // Added "as anyObject" to fix syntax error in Xcode 8 Beta 6
                            
                            print(jsonResult)
                            print(jsonResult["weather"])
                            
                            if let actualTemperature = (jsonResult["main"] as? NSDictionary)?["temp"] {
                                
                                message = message + String(describing: actualTemperature) + "K" + ", "
                                
                            }
                            
                            if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                                
                                message = message + description
                                
                                if message == "" {
                                    
                                    self.resultLabel.text = "Couldn't find weather for that city. Please try again."
                                    
                                } else {
                                    
                                    DispatchQueue.main.sync(execute: {
                                        
                                        self.resultLabel.text = message
                                        
                                    })
                                    
                                }
                                
                            }
                            
                        } catch {
                            
                            print("JSON Processing Failed")
                            
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
            task.resume()
            
        } else {
            
            resultLabel.text = "Couldn't find weather for that city. Please try again."
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

