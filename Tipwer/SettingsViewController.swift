//
//  SettingsViewController.swift
//  Tipwer
//
//  Created by Claudiu Andrei on 9/27/16.
//  Copyright © 2016 Claudiu Andrei. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // Load the settings
    let userSettings = UserDefaults.standard
    
    // Load the options
    var userLocaleOptions: [String] = []
    var userLocaleLabels: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the locale
        userLocaleOptions = userSettings.array(forKey: "LocaleOptions") as! [String]
        userLocaleLabels = userSettings.array(forKey: "LocaleLabels") as! [String]
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

    // Table view sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Setup the section names
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Country"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLocaleOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Load the country cell template
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        // Load the countries text
        cell.textLabel?.text = userLocaleLabels[indexPath.row]
        
        // Show chekmark if selected
        if getUserLocale() == userLocaleOptions[indexPath.row] {
            cell.accessoryType = .checkmark
        }

        // Done for country cells
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        // Get previous path
        let prevIndex = userLocaleOptions.index(of: getUserLocale())
        let prevIndexPath = IndexPath(row: prevIndex!, section: indexPath.section)
        
        // Save the next data
        let userLocale = userLocaleOptions[indexPath.row]
        
        // Save settings
        userSettings.set(userLocale, forKey: "Locale")
        
        // Check/Uncheck previous paths
        checkRow(at: prevIndexPath, checked: false)
        checkRow(at: indexPath, checked: true)
        
        // Dismiss
        self.dismiss(animated: true, completion: {});
    }
    
    func checkRow(at: IndexPath, checked: Bool) {
        tableView.cellForRow(at: at)?.accessoryType = checked ? .checkmark : .none
    }
}
