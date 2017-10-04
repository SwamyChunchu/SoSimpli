//
//  ViewController.swift
//  SOSIMPLE
//
//  Created by think360 on 11/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,HMDiallingCodeDelegate {

    var mobileFullString = String()
    var diallingCode = HMDiallingCode()
    
//    @IBOutlet weak var rememberImage: UIImageView!
//    @IBOutlet weak var rememberButton: UIButton!
    @IBOutlet weak var emailTF: ACFloatingTextfield!
    @IBOutlet weak var passwordTF: ACFloatingTextfield!
    
    
  //  var rememberString = String()
    var DeviceToken = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
        DeviceToken = ""
        }else{
        DeviceToken  = UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
        print(DeviceToken)
        self.diallingCode.delegate = self
//        rememberButton.isSelected = true
//        rememberImage.image = #imageLiteral(resourceName: "Checkbox-Gray")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
//        rememberString = "NotRemember"
//        rememberButton.isSelected = true
//        rememberImage.image = #imageLiteral(resourceName: "Checkbox-Gray")
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        let savedMailID = UserDefaults.standard.value(forKey: "userEmail")
//        let savedPW = UserDefaults.standard.value(forKey: "userPW")
//        if savedMailID == nil || savedPW == nil {
//            
//            rememberButton.isSelected = true
//            rememberImage.image = #imageLiteral(resourceName: "Checkbox-Gray")
//        }else{
//            emailTF.text! = savedMailID as! String
//            passwordTF.text! = savedPW as! String
//            rememberButton.isSelected = false
//            rememberImage.image = #imageLiteral(resourceName: "Checked-Right")
//        }
    }
//    @IBAction func rememberButtonAction(_ sender: UIButton) {
//        
//        if emailTF.text!.isEmpty || passwordTF.text!.isEmpty
//        {
//            AFWrapperClass.alert(Constants.applicationName, message: "Please enter Email OR Password", view: self)
//        }else{
//            if sender.isSelected {
//                sender.isSelected = false
//                self.rememberImage.image = #imageLiteral(resourceName: "Checked-Right")
//                rememberString = "Remember"
//            } else {
//                sender.isSelected = true
//                rememberImage.image = #imageLiteral(resourceName: "Checkbox-Gray")
//                rememberString = "NotRemember"
//            }
//        }
//    }
//    
    // MARK: DialingCodeDelegates:
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        let countryCode = String(format: "+%@",diallingCode)
        mobileFullString = String(format: "%@%@",countryCode,emailTF.text!)
        mobileFullString = String(mobileFullString.replacingOccurrences(of: "+", with: "%2B"))
        
        self.simpleLoginMethod()
    }
    public func failedToGetDiallingCode() {
        
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }
    
    @IBAction func signInBittomAction(_ sender: Any) {
        var message = String()
        if (emailTF.text?.isEmpty)!
        {
            message = "Please enter valid e-mail / Phone number"
        }
        else if (passwordTF.text?.isEmpty)!
        {
            message = "Please enter Password"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            let str: String = emailTF.text!
            if str.isNumber == true
            {
                let vc = SLCountryPickerViewController()
                vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
                    self.diallingCode.getForCountry(code!)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if str.isNumber == false
            {
                mobileFullString = emailTF.text!
                self.simpleLoginMethod()
            }
            else
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter Email/Mobile Number", view: self)
            }
        }
    }
    func simpleLoginMethod () -> Void
    {
        let deviceID = UserDefaults.standard.object(forKey: "DeviceToken")
        if deviceID == nil
        {
            DeviceToken = ""
        }else{
            DeviceToken  = UserDefaults.standard.object(forKey: "DeviceToken") as! String
        }
       print(DeviceToken)
        
       self.view.endEditing(true)
       let baseURL  = String(format: "%@login",Constants.mainURL)
       let params = "email=\(mobileFullString)&password=\(passwordTF.text!)&device_type=\("ios")&device_id=\(DeviceToken)"
       //  let params = ["email"           : emailTF.text!,
       //                "password"        : passwordTF.text!     ]
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    UserDefaults.standard.set((responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "driver_id") as! String, forKey: "driverID")
                    UserDefaults.standard.set((responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "driver_name") as! String, forKey: "DriverNameSave")
                    UserDefaults.standard.set((responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "operator_phone") as! String, forKey: "OperatorPhnNum")
                    
                    UserDefaults.standard.set("LoginSuccess", forKey: "success")
                    
                    UserDefaults.standard.synchronize()
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    
//                    if self.rememberString == "Remember"
//                    {
//                    UserDefaults.standard.synchronize()
//                    }
//
                    self.emailTF.text! = ""
                    self.passwordTF.text! = ""
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
    
    @IBAction func forgotButtonAction(_ sender: Any) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

