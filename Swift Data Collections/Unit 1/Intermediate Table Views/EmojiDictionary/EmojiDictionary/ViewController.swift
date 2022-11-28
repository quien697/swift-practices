//
//  ViewController.swift
//  EmojiDictionary
//
//  Created by Quien on 2022/11/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  let cities: [String] = ["Vancouver", "Burnaby", "Surrey", "Richmond", "Coquitlam", "Langley"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 1. Ask the tableView, please give me (dequeue) available rows
    let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath)
    // 2. configure your cell
    cell.textLabel!.text = cities[indexPath.row]
    return cell
  }
  
}

