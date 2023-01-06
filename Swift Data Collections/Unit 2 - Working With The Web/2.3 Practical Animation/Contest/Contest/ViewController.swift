//
//  ViewController.swift
//  Contest
//
//  Created by Quien on 2023/1/4.
//

import UIKit

class ViewController: UIViewController {
  
  struct PropertyKeys {
    static let toEnteredViewSegue = "toEnteredView"
  }
  
  @IBOutlet weak var emailAddressTextField: UITextField!
  
  @IBAction func enterButtonTapped(_ sender: UIButton) {
    if emailAddressTextField.text?.isEmpty ?? false {
      UIView.animate(withDuration: 0.2) {
        let rightTransform = CGAffineTransform(translationX: 10, y: 0)
        self.emailAddressTextField.transform = rightTransform
      } completion: { (_) in
        UIView.animate(withDuration: 0.2) {
          let leftTransform = CGAffineTransform(translationX: -10, y: 0)
          self.emailAddressTextField.transform = leftTransform
        } completion: { (_) in
          self.emailAddressTextField.transform = CGAffineTransform.identity
        }
      }
    } else {
      performSegue(withIdentifier: PropertyKeys.toEnteredViewSegue, sender: nil)
    }
  }

}

