//
//  ViewController.swift
//  TipCalculator
//
//  Created by Quien on 2022/11/23.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var billAmountTextField: UITextField!
  @IBOutlet weak var tipPercentageTextField: UITextField!
  @IBOutlet weak var adjustTipPercentage: UISlider!
  
  @IBOutlet weak var billAmountLabel: UILabel!
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var totalTipLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyboardNotifications()
  }
  
  @IBAction func billAmountEditingDidEnd(_ sender: UITextField) {
    updateTotal()
  }

  @IBAction func tipPercentageEditingDidEnd(_ sender: UITextField) {
    var value = sender.text!.description
    if value.isEmpty {
      value = "0"
    }
    if Int(value)! > 100 {
      value = "100"
    }
    updateTipPercentage(value: value)
    updateTotal()
  }
  
  @IBAction func adjustTipPercentageValueChanged(_ sender: UISlider) {
    updateTipPercentage(value: Int(sender.value).description)
    updateTotal()
  }
 
  private func updateTipPercentage(value: String) {
    tipPercentageTextField.text = value
    totalTipLabel.text = "Total Tip(\(value)%) : "
  }
  
  private func updateTotal() {
    guard let billAmount = Float(billAmountTextField.text!) else { return }
    let tip = billAmount * Float(tipPercentageTextField.text!)! / 100
    billAmountLabel.text = "$\(String(format: "%.2f", billAmount))"
    tipLabel.text = "$\(String(format: "%.2f", tip))"
    totalLabel.text = "$\(String(format: "%.2f", billAmount+tip))"
  }

  func registerForKeyboardNotifications() {
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func hideKeyBoard() {
    self.view.endEditing(true)
  }
  
  @objc private func keyboardWillBeShown(_ notification: NSNotification) {
    
    guard let info = notification.userInfo,
          let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }

    let keyboardFrame = keyboardFrameValue.cgRectValue
    let keyboardSize = keyboardFrame.size

    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
  
  @objc private func keyboardWillBeHidden(_ notification: NSNotification) {
    let contentInsets = UIEdgeInsets.zero
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
  
}

