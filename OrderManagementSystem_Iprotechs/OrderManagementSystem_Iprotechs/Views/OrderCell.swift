//
//  OrderCell.swift
//  OrderManagementSystem_Iprotechs
//
//  Created by Vrushali Pramod Mahajan on 16/04/21.
//

import UIKit

protocol OrderCellDelegate: class {
    func editOrder(order: OrderDetail)
    func deleteOrder(order: OrderDetail)
}

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderDueDate: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var orderTotal: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var currentOrder: OrderDetail?
    
    weak var delegate: OrderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editButton.layer.cornerRadius = editButton.frame.size.height / 2
        deleteButton.layer.cornerRadius = deleteButton.frame.size.height / 2
    }

    func setData(orderObj: OrderDetail) {
        
        currentOrder = orderObj
        
        orderNumber.text = orderObj.orderNumber
        customerName.text = orderObj.customerName
        customerAddress.text = orderObj.customerAddress
        customerPhone.text = orderObj.customerPhone
        orderTotal.text = "\(orderObj.orderTotal ?? 0)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "yyyy-MM-dd, h:mm a"
        orderDueDate.text = dateFormatter.string(from: orderObj.dueDate ?? Date())
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        if let order = currentOrder {
            delegate?.editOrder(order: order)
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        if let order = currentOrder {
            delegate?.deleteOrder(order: order)
        }
    }
    
}
