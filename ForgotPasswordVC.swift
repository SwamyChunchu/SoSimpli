//
//  ForgotPasswordVC.swift
//  SOSIMPLE
//
//  Created by think360 on 17/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController,HMDiallingCodeDelegate{

    @IBOutlet weak var seneOTPView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var verifyOTPview: UIView!
    @IBOutlet weak var otpTF: UITextField!
    var otpStr = String()
    var mobileFullString = String()
    var diallingCode = HMDiallingCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.diallingCode.delegate = self
        verifyOTPview.isHidden = true
        AFWrapperClass.dampingEffect(view:seneOTPView)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {   super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func cancelOtpBtnAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: DialingCodeDelegates:
    func didGetDiallingCode(_ diallingCode: String!, forCountry countryCode: String!) {
        let countryCode = String(format: "+%@",diallingCode)
        mobileFullString = String(format: "%@%@",countryCode,emailTF.text!)
        mobileFullString = String(mobileFullString.replacingOccurrences(of: "+", with: "%2B"))
        self.forgotPassWordAPIMethod()
    }
    public func failedToGetDiallingCode() {
        AFWrapperClass.alert(Constants.applicationName, message: "Country Code not available", view: self)
    }
    
   //MARK: SendOTP Methods:
    @IBAction func sendOTPbtnAction(_ sender: Any) {
        self.view.endEditing(true)
        var message = String()
        if (emailTF.text?.isEmpty)!
        {
            message = "Please enter Email/Mobile Number"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            let str: String = emailTF.text!
            if str.isNumber == true
            {
                let vc = SLCountryPickerViewController()
                vc.completionBlock = {(_ country: String?, _ code: String?) -> Void in
                    print(code!)
                    self.diallingCode.getForCountry(code!)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if str.isNumber == false
            {
                mobileFullString = emailTF.text!
                self.forgotPassWordAPIMethod()
            }
            else
            {
                AFWrapperClass.alert(Constants.applicationName, message: "Please enter Email/Mobile Number", view: self)
            }
        }
    }
    
func forgotPassWordAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@forget_password",Constants.mainURL)
        let params = "mobile=\(mobileFullString)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                print(responceDic)
                if responceDic.object(forKey: "code") as! NSNumber == 2
                {
                    self.seneOTPView.isHidden = true
                    AFWrapperClass.dampingEffect(view:self.verifyOTPview)
                    self.verifyOTPview.isHidden = false
                    self.otpStr = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "id") as! String
                    print(self.otpStr)
                    AFWrapperClass.alert(Constants.applicationName, message: "OTP successfully sent", view: self)
                    
                } else if responceDic.object(forKey: "code") as! NSNumber == 3
                   {
                   
                let alertController = UIAlertController(title: "SO SIMPLI", message: "Password successfully sent to your e-mail. Please login", preferredStyle: .alert)
                    
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                    
                _ = self.navigationController?.popViewController(animated: true)
                    alertController.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                   }
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
    
    //MARK: Verify OTP Methods:
    @IBAction func verifyOTPbtnAction(_ sender: Any) {
       self.view.endEditing(true)
        var message = String()
        if (otpTF.text?.isEmpty)!
        {
            message = "Please enter OTP"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.OtpAPIMethod()
        }
    }
    func OtpAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@verify_otp",Constants.mainURL)
        let params = "id=\(otpStr)&otp=\(otpTF.text!)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    
                    let myVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordUpdateVC") as? PasswordUpdateVC
                    self.navigationController?.pushViewController(myVC!, animated: true)
                    myVC?.driverID = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "id") as! String
                    
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
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
    
    @IBAction func resendOTPbtnAction(_ sender: Any) {
        self.view.endEditing(true)
        let baseURL  = String(format: "%@resend_otp",Constants.mainURL)
        let params = "id=\(otpStr)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
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
    
    @IBAction func cancelBtnAction(_ sender: Any) {
         _ = navigationController?.popViewController(animated: true)
    }
    

     // MARK: TextField Dekegate Methods:
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func otpTFeditingChanged(_ sender: UITextField) {
        
        if sender.text?.trimmingCharacters(in: .whitespaces).characters.count == 4
        {
            self.view.endEditing(true)
        }
    }
  
    @IBAction func BackButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
