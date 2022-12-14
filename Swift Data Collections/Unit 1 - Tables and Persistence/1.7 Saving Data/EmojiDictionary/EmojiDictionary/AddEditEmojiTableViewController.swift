//
//  AddEditEmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Quien on 2022/11/27.
//

import UIKit

class AddEditEmojiTableViewController: UITableViewController {

  @IBOutlet weak var symbolTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var usageTextField: UITextField!
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  
  var emoji: Emoji?
  
  init?(coder: NSCoder, emoji: Emoji?) {
    self.emoji = emoji
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let emoji = emoji {
      symbolTextField.text = emoji.symbol
      nameTextField.text = emoji.name
      descriptionTextField.text = emoji.description
      usageTextField.text = emoji.usage
      title = "Edit Emoji"
    } else {
      title = "Add Emoji"
    }
    updateSaveButtonState()
  }
  
  @IBAction func textEditingChanged(_ sender: Any) {
    updateSaveButtonState()
  }
  
  func updateSaveButtonState() {
    let nameText = nameTextField.text ?? ""
    let descriptionText = descriptionTextField.text ?? ""
    let usageText = usageTextField.text ?? ""
    saveButton.isEnabled = containsSingleEmoji(symbolTextField) && !nameText.isEmpty && !descriptionText.isEmpty && !usageText.isEmpty
  }
  
  private func containsSingleEmoji(_ textField: UITextField) -> Bool {
    guard let text = textField.text, text.count == 1 else { return false }
    
    let isCombinedIntoEmoji = text.unicodeScalars.count > 1 && text.unicodeScalars.first?.properties.isEmoji ?? false
    let isEmojiPresentation = text.unicodeScalars.first?.properties.isEmojiPresentation ?? false
    
    return (isCombinedIntoEmoji || isEmojiPresentation)
  }

  @IBAction func CancelTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "saveUnwind" else { return }
    let symbol = symbolTextField.text ?? ""
    let name = nameTextField.text ?? ""
    let description = descriptionTextField.text ?? ""
    let usage = usageTextField.text ?? ""
    emoji = Emoji(symbol: symbol, name: name, description: description, usage: usage)
  }
  
}
