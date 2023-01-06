//
//  FoodTableViewController.swift
//  MealTracker
//
//  Created by Quien on 2022/11/25.
//

import UIKit

class FoodTableViewController: UITableViewController {
  
  var meal: [Meal] = [
    Meal(name: "Breakfast", food:[
      Food(name: "Coffee", description: "This is a coffee."),
      Food(name: "Taiwanese onion egg Pancake", description: "This is a Taiwanese common breakfast.")
    ]),
    Meal(name: "Lunch", food:[
      Food(name: "Fried Rice", description: "This is a Fried rice."),
      Food(name: "Soup", description: "This is a Soup.")
    ]),
    Meal(name: "Dinner", food:[
      Food(name: "Hot Pot", description: "This is a Hot Pot."),
    ]),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return meal.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return meal[section].name
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return meal[section].food.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =  tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
    let food = meal[indexPath.section].food[indexPath.row]
    cell.textLabel?.text = food.name
    cell.detailTextLabel?.text = food.description
    return cell
  }
  
}
