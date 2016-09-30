//
//  ViewController.swift
//  Tipwer
//
//  Created by Claudiu Andrei on 9/17/16.
//  Copyright © 2016 Claudiu Andrei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    // Load the settings
    let userSettings = UserDefaults.standard
    
    // Setup a userLocale
    var userLocaleOptions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the locale
        userLocaleOptions = userSettings.array(forKey: "LocaleOptions") as! [String]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start editing by default
        billField.becomeFirstResponder()
        
        // Setup the segments
        setupSegments()
        
        // Run the calculations for the first time
        calculateTip(self)
    }
    
    // Setup the tips based on settings
    func getTipOptions(locale: String) -> [Double] {
        switch locale {
            case "en_US":
                return [0.20, 0.18, 0.15]
            default:
                return [0.15, 0.12, 0.10]
        }
    }
    
    // Setup the segments
    func setupSegments() {
        
        // Load the values based on user options
        let tips: [Double] = getTipOptions(locale: getUserLocale())
        
        // Remove the segments
        tipControl.removeAllSegments()
        
        // Setup the segments
        for (index, value) in tips.enumerated() {
            
            // Set the tilte
            let title: String = toPercent(value: value)
            
            // Update the title
            tipControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        
        // Select the index
        tipControl.selectedSegmentIndex = 0

    }
    
    // Creates a custom currency formatter for the locale
    func getFormat() -> NumberFormatter {
        
        // We want to format numbers
        let formatter: NumberFormatter = NumberFormatter()
        
        // Setup the properties
        formatter.locale = Locale(identifier: getUserLocale())
        
        // Return the new formatter
        return formatter
    }
    
    // Convert to percent
    func toPercent(value: Double) -> String {
        
        // We want to format numbers
        let formatter: NumberFormatter = getFormat()
        
        // Set the style
        formatter.numberStyle = .percent
        
        // Return the new formatter
        return formatter.string(from: NSNumber(value: value))!

    }
    
    // Creates a custom currency formatter for the locale
    func toCurrency(value: Double) -> String {
        
        // We want to format numbers
        let formatter: NumberFormatter = getFormat()
        
        // Set the style
        formatter.numberStyle = .currency
        
        // Return the new formatter
        return formatter.string(from: NSNumber(value: value))!
    }
    
    // Read the input
    func readFromInput() -> Double {
        
        // Load the current bill field
        let input: Double = Double(billField.text!) ?? 0
        
        // Return the bill in decimals
        return input / 100
    }
    
    // Write to screen
    func writeToScreen(value: Double, percent: Double) {
        
        // Compute tip
        let tip: Double = value * percent
        let total: Double = value + tip
        
        // Write the data
        billLabel.text = toCurrency(value: value)
        tipLabel.text = toCurrency(value: tip)
        totalLabel.text = toCurrency(value: total)
    }
    
    func getUserLocale() -> String {
        
        // Load the locale
        var userLocale = userSettings.string(forKey: "Locale")!
        
        // Make sure is valid
        if (userLocaleOptions.index(of: userLocale) == nil) {
            userLocale = userLocaleOptions[0]
        }
        
        // Done, return the locale
        return userLocale
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        
        // Load the values based on user options
        let tips: [Double] = getTipOptions(locale: getUserLocale())
        
        // Load the bill data from input
        writeToScreen(
            value: readFromInput(),
            percent: tips[tipControl.selectedSegmentIndex]
        )
    }
}

