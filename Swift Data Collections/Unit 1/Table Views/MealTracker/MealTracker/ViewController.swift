//
//  ViewController.swift
//  MealTracker
//
//  Created by Quien on 2022/11/23.
//

import UIKit

// UITableView
// - delegate: looks, behaviours of the tableView
// - data source: data, how many row?, what do I display in one cell?
class ViewController: UIViewController, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  var cities: [String] = ["Vancouver", "Burnaby", "Surrey", "Richmond", "Coquitlam", "Langley"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
  }

  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("IndexPath = \(indexPath)")
  }

}

