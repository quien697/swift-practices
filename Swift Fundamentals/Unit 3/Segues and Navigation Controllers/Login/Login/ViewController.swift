//
//  ViewController.swift
//  Login
//
//  Created by Quien on 2022/11/20.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var username: UITextField!
  
  @IBOutlet weak var forgotUserNameButton: UIButton!
  
  @IBOutlet weak var forgotPasswordButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let sender = sender as? UIButton else { return }
    
    if sender == forgotUserNameButton {
      segue.destination.navigationItem.title = "Forgot Username"
    } else if sender == forgotPasswordButton {
      segue.destination.navigationItem.title = "Forgot Password"
    } else {
      segue.destination.navigationItem.title = username.text
    }
  }

  @IBAction func forgotUserNameTapped(_ sender: Any) {
    performSegue(withIdentifier: "ForgottenUsernameOrPassword", sender: sender)
  }
  
  @IBAction func forgotPasswordTapped(_ sender: Any) {
    performSegue(withIdentifier: "ForgottenUsernameOrPassword", sender: sender)
  }
}

