//
//  ViewController.swift
//  DemoSwift
//
//  Created by Kenneth on 2021/11/11.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func verifyPhoneNumAction(_ sender: Any) {
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
            return
        }
        
        JJCode.verify(phoneNumber) { mobile, token in
            self.showAlert(title: "Success", message: "mobile: \(mobile), token: \(token)")
        } fail: { code, message in
            self.showAlert(title: "Fail", message: "code: \(code), error: \(message)")
        }

    }
    
    @IBAction func checkWxAction(_ sender: Any) {
        WXApi.checkUniversalLinkReady { step, stepResult in
            print("step: \(step.rawValue), stepResult success: \(stepResult.success), errorInfo: \(stepResult.errorInfo)")
        }
    }
    
    func showAlert(title: String = "", message: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

