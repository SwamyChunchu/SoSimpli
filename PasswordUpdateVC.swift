//
//  PasswordUpdateVC.swift
//  SOSIMPLE
//
//  Created by think360 on 28/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class PasswordUpdateVC: UIViewController {

    
    @IBOutlet weak var pesswordTF: UITextField!
    @IBOutlet weak var confirmPWTF: UITextField!
    var driverID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        var message = String()
        if (pesswordTF.text?.characters.count)! < 6
        {
            message = "Password should be minimum 6 characters"
        }
        else if !(pesswordTF.text == confirmPWTF.text)
        {
            message = "Confirm Password doesn't match please try again"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.updatePasswordAPImethod()
        }
    }
    
    func updatePasswordAPImethod() -> Void
    {
        let baseURL  = String(format: "%@driveredit",Constants.mainURL)
        let params = "id=\(driverID)&driver_name=\("")&driver_pic=\("")&password=\(pesswordTF.text!)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                   
                    let alertController = UIAlertController(title: "SO SIMPLI", message: "Password successfully Updated. Please login", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                        
                    _ = self.navigationController?.popToRootViewController(animated: true)
                        alertController.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else
                {
                AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    // MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
