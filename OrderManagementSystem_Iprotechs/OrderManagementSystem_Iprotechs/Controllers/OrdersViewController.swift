//
//  OrdersViewController.swift
//  OrderManagementSystem_Iprotechs
//
//  Created by Vrushali Pramod Mahajan on 16/04/21.
//

import UIKit
import CoreData

class OrdersViewController: UIViewController {

    @IBOutlet weak var ordersTable: UITableView!

    var orders: [OrderDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarBtnItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(onNewBtnTapped))
        navigationItem.rightBarButtonItem = rightBarBtnItem
        
        let leftBarBtnItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutBtnTapped))
        navigationItem.leftBarButtonItem = leftBarBtnItem
        
        navigationItem.title = "Orders for \(DatabaseManager.shared.currentUser?.userName ?? "Test")"
    }
    
    @objc func onLogoutBtnTapped(sender: UINavigationItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func onNewBtnTapped(sender: UINavigationItem) {
        if let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "NewOrderViewController") as? NewOrderViewController {
            self.navigationController?.pushViewController(popupVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayOrder()
    }

    func displayOrder() {
        DatabaseManager.shared.fetchAllOrders { [weak self] (orders) in
            
            self?.orders = orders
            
            DispatchQueue.main.async { [weak self] in
                self?.ordersTable.reloadData()
            }
        } onFailure: {
            DispatchQueue.main.async { [weak self] in
                self?.displayErrorAlert(text: "Failed to fetch all orders")
            }
        }
    }
    
    func displayErrorAlert(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let orderCell = ordersTable.dequeueReusableCell(withIdentifier: "OrderCell") as? OrderCell {
            orderCell.setData(orderObj: orders[indexPath.row])
            orderCell.delegate = self
            return orderCell
        }
        return UITableViewCell()
    }
}

extension OrdersViewController: OrderCellDelegate {
    
    func editOrder(order: OrderDetail) {
        if let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "NewOrderViewController") as? NewOrderViewController {
            popupVC.currentOrder = order
            self.navigationController?.pushViewController(popupVC, animated: true)
        }
    }
    
    func deleteOrder(order: OrderDetail) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete order?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action) in
            DatabaseManager.shared.deleteOrder(order: order)
            self?.displayOrder()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
