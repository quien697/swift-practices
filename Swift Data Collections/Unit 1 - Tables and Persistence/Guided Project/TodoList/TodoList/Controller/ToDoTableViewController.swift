//
//  TodoTableViewController.swift
//  TodoList
//
//  Created by Quien on 2022/11/29.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
  
  var toDos = [ToDo]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = editButtonItem
    if let savedTodos = ToDo.loadToDos() {
      toDos = savedTodos
    } else {
      toDos = ToDo.loadSampleToDos()
    }
  }
  
  @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
    guard segue.identifier == "saveUnwind" else { return }
    let sourceViewContoller = segue.source as! ToDoDetailTableViewController
    
    if let toDo = sourceViewContoller.toDo {
      if let indexOfExistingTodo = toDos.firstIndex(of: toDo) {
        toDos[indexOfExistingTodo] = toDo
        tableView.reloadRows(at: [IndexPath(row: indexOfExistingTodo, section: 0)], with: .automatic)
      } else {
        let newIndexPath = IndexPath(row: toDos.count, section: 0)
        toDos.append(toDo)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    }
    ToDo.saveToDos(toDos)
  }
  
  @IBSegueAction func editTodo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
    let detailController = ToDoDetailTableViewController(coder: coder)
    guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
      return detailController
    }
    tableView.deselectRow(at: indexPath, animated: true)
    detailController?.toDo = toDos[indexPath.row]
    return detailController
  }
  
  func checkmarkTapped(sender: ToDoTableViewCell) {
    if let indexPath = tableView.indexPath(for: sender) {
      var toDo = toDos[indexPath.row]
      toDo.isComplete.toggle()
      toDos[indexPath.row] = toDo
      tableView.reloadRows(at: [indexPath], with: .automatic)
      ToDo.saveToDos(toDos)
    }
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return toDos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! ToDoTableViewCell
    let toDo = toDos[indexPath.row]
    cell.dekegate = self
    cell.titleLabel.text = toDo.title
    cell.isCompleteButton.isSelected = toDo.isComplete
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      toDos.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      ToDo.saveToDos(toDos)
    }
  }
  
}
