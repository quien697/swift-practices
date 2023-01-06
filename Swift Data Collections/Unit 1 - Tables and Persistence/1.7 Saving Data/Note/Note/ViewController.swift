//
//  ViewController.swift
//  Note
//
//  Created by Quien on 2022/11/28.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  
  let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  lazy var archiveURL = documentsDirectory.appendingPathComponent("notes_text").appendingPathExtension("plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func saveButtonTapped(_ sender: UIButton) {
    
    let newNote = Note(title: "Grocery run", text: "Pick up mayonnaise, mustard, lettuce, tomato, and pickles", timestamp: Date())
    
    // Writing data to a file
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL = documentsDirectory.appendingPathComponent("notes_text").appendingPathExtension("plist")
    
    // get encoder
    let jsonEncoder = JSONEncoder()
    if let encodedNote = try? jsonEncoder.encode(newNote) {
//       let jsonStr = String(data: encodedNote, encoding: .utf8)!
//       print("jsonStr = \(jsonStr)")
      do {
        try encodedNote.write(to: archiveURL, options: .noFileProtection)
        print("Saved.")
        let alertController = UIAlertController(title: "OK", message: "Text Saved.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
      } catch {
        print("Cannot write to the file system.")
      }
    }

  }
  
  @IBAction func loadButtonTapped(_ sender: UIButton) {
    // Read data from a file
    let jsonDecoder = JSONDecoder()
    if let noteData = try? Data(contentsOf: archiveURL) {
      if let decodedNote = try? jsonDecoder.decode(Note.self, from: noteData) {
        print("decodedNote = \(decodedNote)")
        label.text = decodedNote.text
      }
    }
  }
  
}

struct Note: Codable {
  let title: String
  let text: String
  let timestamp: Date
}

