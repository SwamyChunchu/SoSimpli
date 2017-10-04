//
//  MenuViewVC.swift
//  SOSIMPLE
//
//  Created by think360 on 11/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class MenuViewVC: UIViewController {
    
    @IBOutlet weak var profilrImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
    var  drivrID = String()
    var dataDic = NSDictionary()
    var appDel = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        appDel = UIApplication.shared.delegate as! AppDelegate
        if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            drivrID = UserDefaults.standard.value(forKey: "driverID") as! String
        }
        self.getDriverDetailsAPIMethod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.getDriverDetailsAPIMethod()
        
        self.dataDic = self.appDel.profileDataDic
        if dataDic.count != 0{
        let imageURL: String = self.dataDic.object(forKey: "driver_image") as! String
        let url = NSURL(string:imageURL)
        self.profilrImageView.setShowActivityIndicator(true)
        self.profilrImageView.setIndicatorStyle(.gray)
        self.profilrImageView.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "ProfilePlaceHolder"))
        self.nameLabel.text! = self.dataDic.object(forKey: "driver_name") as! String
        }
    }
    
// MARK: -> User Profile Method
    func getDriverDetailsAPIMethod () -> Void
    {
        let baseURL: String  = String(format: "%@driver_history/",Constants.mainURL)
        let params = "id=\(drivrID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                   // print(responceDic)
                    self.dataDic = responceDic.object(forKey: "data") as! NSDictionary
                    self.appDel.profileDataDic = self.dataDic
                    
                    let imageURL: String = self.dataDic.object(forKey: "driver_image") as! String
                    let url = NSURL(string:imageURL)
                    self.profilrImageView.setShowActivityIndicator(true)
                    self.profilrImageView.setIndicatorStyle(.gray)
                    self.profilrImageView.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "ProfilePlaceHolder"))
                    self.nameLabel.text! = self.dataDic.object(forKey: "driver_name") as! String
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "No Data Found", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            let alertMessage = UIAlertController(title: "SOSIMPLI", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertMessage .addAction(action)
            DispatchQueue.main.async {
                self.present(alertMessage, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addAvailibilitybtnAction(_ sender: Any) {
        
        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAvailibilityVC") as! AddAvailibilityVC
        self.navigationController?.pushViewController(simpliVC, animated: true)
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func scheduleBtnAction(_ sender: Any) {
        
        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "CompletedScheduleVC") as! CompletedScheduleVC
        self.navigationController?.pushViewController(simpliVC, animated: true)
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func changeAssignrdSchdBtnAction(_ sender: Any) {
        
        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeAssignedSchedule") as! ChangeAssignedSchedule
        self.navigationController?.pushViewController(simpliVC, animated: true)
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func logOutBtnAction(_ sender: Any) {
//        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        self.navigationController?.pushViewController(simpliVC, animated: true)
//        self.revealViewController().revealToggle(animated: true)
        
//        UserDefaults.standard.removeObject(forKey: "userEmail")
//        UserDefaults.standard.removeObject(forKey: "userPW")
//        UserDefaults.standard.synchronize()
        
        self.logOutAPIMethod()
       
    }
    
    func logOutAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@userlogout",Constants.mainURL)
        let params = "id=\(drivrID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                  //   print(responceDic)DeviceToken
                    
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    UserDefaults.standard.removeObject(forKey:"success")
                    UserDefaults.standard.removeObject(forKey:"DriverNameSave")
                    UserDefaults.standard.removeObject(forKey:"driverID")
                    UserDefaults.standard.removeObject(forKey:"DeviceToken")
                    UserDefaults.standard.synchronize()
                    
                    AFWrapperClass.alert(Constants.applicationName, message: "Logout Successfully", view: self)
                }
                else
                    {
                    AFWrapperClass.alert(Constants.applicationName, message: "Please try Again", view: self)
                    }
            }
            })
            { (error) in
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
