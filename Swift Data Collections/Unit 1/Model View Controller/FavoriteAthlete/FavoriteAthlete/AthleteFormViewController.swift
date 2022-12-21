//
//  AthleteFormViewController.swift
//  FavoriteAthlete
//
//  Created by Quien on 2022/12/20.
//

import UIKit

class AthleteFormViewController: UIViewController {
  
  struct PropertyKeys {
    static let unwindSegue = "unwindToAthleteTableView"
  }
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var ageTextField: UITextField!
  @IBOutlet weak var leagueTextField: UITextField!
  @IBOutlet weak var teamTextField: UITextField!
  
  var athlete: Athlete?
  
  init?(coder: NSCoder, athlete: Athlete?) {
    super.init(coder: coder)
    self.athlete = athlete
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateView()
  }
  
  func updateView() {
    if let athlete = athlete {
      nameTextField.text = athlete.name
      ageTextField.text = String(athlete.age)
      leagueTextField.text = athlete.league
      teamTextField.text = athlete.team
    }
  }
  
  @IBAction func saveButtonTapped(_ sender: UIButton) {
    guard let name = nameTextField.text,
          let ageString = ageTextField.text,
          let age = Int(ageString),
          let league = leagueTextField.text,
          let team = teamTextField.text else { return }
    
    athlete = Athlete(name: name, age: age, league: league, team: team)
    performSegue(withIdentifier: PropertyKeys.unwindSegue, sender: self)
  }
  
}
