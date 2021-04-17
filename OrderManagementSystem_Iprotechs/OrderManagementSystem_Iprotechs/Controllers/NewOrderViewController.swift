//
//  NewOrderViewController.swift
//  OrderManagementSystem_Iprotechs
//
//  Created by Vrushali Pramod Mahajan on 16/04/21.
//

import UIKit
import CoreData

class NewOrderViewController: UIViewController {
    
    @IBOutlet weak var dueDateTF: UITextField!
    @IBOutlet weak var customerNameTF: UITextField!
    @IBOutlet weak var customerAddressTV: UITextView!
    @IBOutlet weak var customerPhoneTF: UITextField!
    @IBOutlet weak var orderTotalTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var selectedDueDate: Date?
    var currentOrder: OrderDetail?
    var datePicker :UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDueDatePicker()
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        
        if let order = currentOrder {
            customerNameTF.text = order.customerName
            customerPhoneTF.text = order.customerPhone
            customerAddressTV.text = order.customerAddress
            orderTotalTF.text = "\(order.orderTotal ?? 0)"
            selectedDueDate = order.dueDate
            setUpDueDateTF()
            navigationItem.title = "Edit order"
        } else {
            navigationItem.title = "Create new order"
        }
    }
    
    func setUpDueDatePicker() {
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        dueDateTF.inputView = datePicker
        datePicker.minimumDate = Date()
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        dueDateTF.inputAccessoryView = toolBar
    }
    
    @objc func datePickerDone() {
        dueDateTF.resignFirstResponder()
    }
    
    @objc func dateChanged() {
        selectedDueDate = datePicker.date
        setUpDueDateTF()
    }
    
    func setUpDueDateTF() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "yyyy-MM-dd, h:mm a"
        if let date = selectedDueDate {
            dueDateTF.text = dateFormatter.string(from: date)
        } else {
            dueDateTF.text = nil
        }
    }
    
    
    @IBAction func submitOrderBtnClicked(_ sender: UIButton) {
        if let custName = customerNameTF.text, custName.count > 0 {
            if let address = customerAddressTV.text, address.count > 0 {
                if let phoneNumber = customerPhoneTF.text, isValidPhone(phone: phoneNumber) {
                    if let dueDate = selectedDueDate {
                        if let total = orderTotalTF.text, total.count > 0 {

                            if currentOrder != nil {
                                currentOrder?.customerName = custName
                                currentOrder?.customerAddress = address
                                currentOrder?.customerPhone = phoneNumber
                                currentOrder?.dueDate = dueDate
                                currentOrder?.orderTotal = Float(total)
                                
                                DatabaseManager.shared.editOrder(order: currentOrder!)
                            } else {
                                
                                let currentOrder = OrderDetail(customerAddress: address, customerName: custName, customerPhone: phoneNumber, dueDate: dueDate, orderNumber: nil, orderTotal: Float(total))
                                
                                DatabaseManager.shared.saveNewOrderDetails(order: currentOrder)
                            }
                            
                            navigationController?.popViewController(animated: true)
                        } else {
                            displayErrorAlert(text: "Please enter a valid order total.")
                        }
                    } else {
                        displayErrorAlert(text: "Please enter a due date.")
                    }
                } else {
                    displayErrorAlert(text: "Please enter a valid phone number.")
                }
            } else {
                displayErrorAlert(text: "Please enter customer address.")
            }
        } else {
            displayErrorAlert(text: "Please enter customer name.")
        }
        
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    func displayErrorAlert(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
