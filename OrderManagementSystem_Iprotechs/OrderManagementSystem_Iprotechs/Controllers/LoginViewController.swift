//
//  LoginViewController.swift
//  OrderManagementSystem_Iprotechs
//
//  Created by Vrushali Pramod Mahajan on 16/04/21.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    var minCharLimit = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        checkIfLoginBtnIsActive(isActive: false)
    }
    
    func setupController() {
        usernameTF.delegate = self
        passwordTF.delegate = self
        
        usernameTF.tag = RegistrationTF.userName.rawValue
        passwordTF.tag = RegistrationTF.password.rawValue

        loginBtn.layer.cornerRadius = loginBtn.frame.size.height / 2
        registerBtn.layer.cornerRadius = registerBtn.frame.size.height / 2
    }

    @IBAction func onLoginBtnTapped(_ sender: Any) {
        if let name = usernameTF.text, let password = passwordTF.text {
            DatabaseManager.shared.validateUserNameAndPassword(name: name, password: password) { (success) in
                if success {
                    navigateToOrdersScreen()
                } else {
                   displayInvalidUserNamePasswordAlert()
                }
            }
        }
    }
    
    @IBAction func onRegisterBtnTapped(_ sender: Any) {
        if let registerVC = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as? RegisterViewController {
            self.present(registerVC, animated: true, completion: nil)
        }
    }
    
    func displayInvalidUserNamePasswordAlert() {
        let alert = UIAlertController(title: nil, message: "Invalid username or password. Please check again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkIfLoginBtnIsActive(isActive: Bool) {
        if isActive {
            loginBtn.backgroundColor = .systemBlue
            loginBtn.isEnabled = true
        } else {
            loginBtn.backgroundColor = .darkGray
            loginBtn.isEnabled = false
        }
    }
    
    func navigateToOrdersScreen() {
        usernameTF.text = nil
        passwordTF.text = nil
        
        if let ordersVC = self.storyboard?.instantiateViewController(identifier: "OrdersViewController") as? OrdersViewController {
            self.navigationController?.pushViewController(ordersVC, animated: true)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isLoginButtonActive = false
        
        let text = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        if textField.tag == RegistrationTF.userName.rawValue {
            if resultString.count >= minCharLimit, passwordTF.text?.count ?? 0 > minCharLimit {
                isLoginButtonActive = true
            }
        } else {
            if usernameTF.text?.count ?? 0 >= minCharLimit, resultString.count >= minCharLimit {
                isLoginButtonActive = true
            }
        }
        checkIfLoginBtnIsActive(isActive: isLoginButtonActive)
        return true
    }
}
