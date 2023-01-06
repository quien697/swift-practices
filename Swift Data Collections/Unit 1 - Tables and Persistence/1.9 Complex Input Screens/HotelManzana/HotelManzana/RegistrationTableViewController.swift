//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Quien on 2023/1/2.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
  
  var registrations: [Registration] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return registrations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
    
    let registration = registrations[indexPath.row]
    
    var content = cell.defaultContentConfiguration()
    content.text = registration.firstName + " " + registration.lastName
    content.secondaryText = (registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted) + ": " + registration.roomType.name
    cell.contentConfiguration = content
    
    return cell
  }
  
  // MARK: - Navigation
  
  @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {
      guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
      let registration = addRegistrationTableViewController.registration else { return }
      registrations.append(registration)
      tableView.reloadData()
  }
  
}
