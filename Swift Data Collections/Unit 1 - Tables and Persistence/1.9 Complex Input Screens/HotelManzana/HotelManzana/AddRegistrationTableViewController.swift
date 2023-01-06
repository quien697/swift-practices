//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Quien on 2023/1/2.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
  
  @IBOutlet var firstNameTextField: UITextField!
  @IBOutlet var lastNameTextField: UITextField!
  @IBOutlet var emailTextField: UITextField!
  
  @IBOutlet var checkInDateLabel: UILabel!
  @IBOutlet var checkInDatePicker: UIDatePicker!
  @IBOutlet var checkOutDateLabel: UILabel!
  @IBOutlet var checkOutDatePicker: UIDatePicker!
  
  @IBOutlet var numberOfAdultsLabel: UILabel!
  @IBOutlet var numberOfAdultsStepper: UIStepper!
  @IBOutlet var numberOfChildrenLabel: UILabel!
  @IBOutlet var numberOfChildrenStepper: UIStepper!
  
  @IBOutlet var wifiSwitch: UISwitch!
  
  @IBOutlet weak var roomTypeLabel: UILabel!
  
  var roomType: RoomType?
  
  let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
  let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
  
  let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
  let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
  
  var isCheckInDatePickerVisible: Bool = false {
    didSet {
      checkInDatePicker.isHidden = !isCheckInDatePickerVisible
    }
  }
  var isCheckOutDatePickerVisible: Bool = false {
    didSet {
      checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
    }
  }
  
  var registration: Registration? {
    guard let roomType = roomType else { return nil }
    
    let firstName = firstNameTextField.text ?? ""
    let lastName = lastNameTextField.text ?? ""
    let email = emailTextField.text ?? ""
    let checkInDate = checkInDatePicker.date
    let checkOutDate = checkOutDatePicker.date
    let numberOfAdults = Int(numberOfAdultsStepper.value)
    let numberOfChildren = Int(numberOfChildrenStepper.value)
    let hasWifi = wifiSwitch.isOn

    return Registration (
      firstName: firstName,
      lastName: lastName,
      emailAddress: email,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      numberOfAdults: numberOfAdults,
      numberOfChildren: numberOfChildren,
      wifi: hasWifi,
      roomType: roomType
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let midnightToday = Calendar.current.startOfDay(for: Date())
    checkInDatePicker.minimumDate = midnightToday
    checkInDatePicker.date = midnightToday
    
    updateDateViews()
    updateNumberOfGuests()
    updateRoomType()
  }
  
  // MARK: - Update
  
  func updateDateViews() {
    checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
    checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
  }
  
  func updateNumberOfGuests() {
    numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
    numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
  }
  
  func updateRoomType() {
    if let roomType = roomType {
      roomTypeLabel.text = roomType.name
    } else {
      roomTypeLabel.text = "Not Set"
    }
  }
  
  // MARK: - Action
  
  @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
    updateDateViews()
  }
  
  @IBAction func stepperValueChanged(_ sender: UIStepper) {
    updateNumberOfGuests()
  }
  
  @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBSegueAction func selectRoomType(_ coder: NSCoder, sender: Any?) -> SelectRoomTypeTableViewController? {
    let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
    selectRoomTypeController?.delegate = self
    selectRoomTypeController?.roomType = roomType
    
    return selectRoomTypeController
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
      // Check-in label selected, check-out picker is not visible, toggle check-in picker
      isCheckInDatePickerVisible.toggle()
    } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false {
      // Check-out label selected, check-in picker is not visible, toggle check-out picker
      isCheckOutDatePickerVisible.toggle()
    } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {
      // Either label was selected, previous conditions failed meaning at least one picker is visible, toggle both
      isCheckInDatePickerVisible.toggle()
      isCheckOutDatePickerVisible.toggle()
    } else {
      return
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath {
    case checkInDatePickerCellIndexPath where
      isCheckInDatePickerVisible == false:
      return 0
    case checkOutDatePickerCellIndexPath where
      isCheckOutDatePickerVisible == false:
      return 0
    default:
      return UITableView.automaticDimension
    }
  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath {
    case checkInDatePickerCellIndexPath:
      return 190
    case checkOutDatePickerCellIndexPath:
      return 190
    default:
      return UITableView.automaticDimension
    }
  }
  
  // MARK: - Delegate
  
  func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
    self.roomType = roomType
    updateRoomType()
  }
  
}
