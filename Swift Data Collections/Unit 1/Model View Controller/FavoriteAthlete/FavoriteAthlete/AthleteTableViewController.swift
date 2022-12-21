//
//  AthleteTableViewController.swift
//  FavoriteAthlete
//
//  Created by Quien on 2022/12/20.
//

import UIKit

class AthleteTableViewController: UITableViewController {
  
  struct PropertyKeys {
    static let athleteCell = "athleteCell"
    static let editAthleteSegue = "editAthlete"
  }
  
  var athletes: [Athlete] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return athletes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.athleteCell, for: indexPath)
    let athlete = athletes[indexPath.row]
    cell.textLabel?.text = athlete.name
    cell.detailTextLabel?.text = athlete.description
    return cell
  }
  
  
  // MARK: - Navigation

  @IBSegueAction func addAthlete(_ coder: NSCoder, sender: Any?) -> AthleteFormViewController? {
    return AthleteFormViewController(coder: coder)
  }
  
  @IBSegueAction func editAthlete(_ coder: NSCoder, sender: Any?) -> AthleteFormViewController? {
    let athleteToEdit: Athlete?
    if let cell = sender as? UITableViewCell,
       let indexPath = tableView.indexPath(for: cell) {
        athleteToEdit = athletes[indexPath.row]
    } else {
        athleteToEdit = nil
    }
    
    return AthleteFormViewController(coder: coder, athlete:
       athleteToEdit)
  }
  
  @IBAction func unwindToAthleteTableViewController(segue: UIStoryboardSegue) {
    guard let athleteFormViewController = segue.source as? AthleteFormViewController,
        let athlete = athleteFormViewController.athlete else { return }
    
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
        athletes[selectedIndexPath.row] = athlete
    } else {
        athletes.append(athlete)
    }
  }
  
}
