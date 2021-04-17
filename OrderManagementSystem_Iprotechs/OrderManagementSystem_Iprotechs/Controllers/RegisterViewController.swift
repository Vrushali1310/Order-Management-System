//
//  RegisterViewController.swift
//  OrderManagementSystem_Iprotechs
//
//  Created by Vrushali Pramod Mahajan on 16/04/21.
//

import UIKit

enum RegistrationTF: Int {
    case userName = 0
    case password
    case confirmPassword
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    var minCharLimit = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        checkIfRegisterBtnIsActive(isActive: false)
    }
    
    func setupController() {
        usernameTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        
        usernameTF.tag = RegistrationTF.userName.rawValue
        passwordTF.tag = RegistrationTF.password.rawValue
        confirmPasswordTF.tag = RegistrationTF.confirmPassword.rawValue

        registerBtn.layer.cornerRadius = registerBtn.frame.size.height / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
    @IBAction func onRegisterBtnTapped(_ sender: Any) {
        if let name = usernameTF.text, let password = passwordTF.text {
            DatabaseManager.shared.saveNewUserNameAndPassword(name: name, password: password)
            displaySuccessAlert()
        }
    }
    
    func displaySuccessAlert() {
        let alert = UIAlertController(title: nil, message: "New user added successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
    func checkIfRegisterBtnIsActive(isActive: Bool) {
        if isActive {
            registerBtn.backgroundColor = .systemBlue
            registerBtn.isEnabled = true
        } else {
            registerBtn.backgroundColor = .darkGray
            registerBtn.isEnabled = false
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isDoneButtonActive = false
        
        let text = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        if textField.tag == RegistrationTF.userName.rawValue {
            
            if resultString.count >= minCharLimit, passwordTF.text?.count ?? 0 >= minCharLimit, passwordTF.text == confirmPasswordTF.text {
                
                isDoneButtonActive = true
            }
            
        } else if textField.tag == RegistrationTF.password.rawValue {
            
            if usernameTF.text?.count ?? 0 >= minCharLimit, resultString.count >= minCharLimit, resultString == confirmPasswordTF.text {
                
                isDoneButtonActive = true
            }
        } else {
            if usernameTF.text?.count ?? 0 >= minCharLimit, passwordTF.text?.count ?? 0 >= minCharLimit, resultString == passwordTF.text {

                isDoneButtonActive = true
            }
        }
        checkIfRegisterBtnIsActive(isActive: isDoneButtonActive)
        return true
    }
}
