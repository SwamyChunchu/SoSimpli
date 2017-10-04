//
//  SOSdetailsVC.swift
//  SOSIMPLE
//
//  Created by think360 on 14/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class SOSdetailsVC: UIViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var zoneLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    var dataDic = NSDictionary()
    var sosZoneID = String()
    var sosID = String()
    var actRjctStatusStr = String()
    
    var  driverID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }
        
        dateLbl.text! = dataDic.object(forKey: "sos_date") as! String
        timeLbl.text! = dataDic.object(forKey: "city") as! String
        infoLbl.text! = dataDic.object(forKey: "message") as! String
        sosZoneID = dataDic.object(forKey: "zones") as! String
        
        var sosZoneStr = String()
        if sosZoneID == "1"
        {
            sosZoneStr = "EAST ZONE"
        }else if sosZoneID == "2"
        {
            sosZoneStr = "WEST ZONE"
        }else if sosZoneID == "3"
        {
            sosZoneStr = "NORTH ZONE"
        }else if sosZoneID == "4"
        {
            sosZoneStr = "SOUTH ZONE"
        }
        zoneLbl.text! = sosZoneStr
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        actRjctStatusStr = "1"
        self.acceptAndRejectAPImethod()
    }
    
    @IBAction func declinesdButtonAction(_ sender: Any) {
        actRjctStatusStr = "0"
        self.acceptAndRejectAPImethod()
    }
    
    func acceptAndRejectAPImethod () -> Void
    {
        let baseURL  = String(format: "%@acceptReject_sos",Constants.mainURL)
        let params = "sos_id=\(sosID)&driver_id=\(driverID)&status=\(actRjctStatusStr)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                   // print(responceDic)
                    let dataStatus: NSNumber = responceDic.value(forKey: "data") as! NSNumber
                    if dataStatus == 2
                    {
                    let imageView = UIImageView(frame: CGRect(x:120, y:5, width:34, height:35))
                    imageView.image = UIImage(named: "Tick30")
                        
                    let alertMessage = UIAlertController(title: "                                                                                ", message: "Your Approval has been successfully sent...", preferredStyle: .alert)
                    let image = UIImage(named: "Image")
                    let action = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                        
                    self.tabBarController?.selectedIndex = 0
                    _ = self.navigationController?.popViewController(animated: true)
                        
                        })
                    action.setValue(image, forKey: "image")
                    alertMessage.addAction(action)
                     //alertMessage.view.tintColor = #colorLiteral(red: 0.4285447896, green: 0.747687161, blue: 0.3533237576, alpha: 1)
                     self.present(alertMessage, animated: true, completion: nil)
                    alertMessage.view.addSubview(imageView)
                    }
                        
                    else if dataStatus == 3
                    {
                    let imageView = UIImageView(frame: CGRect(x:120, y:5, width:34, height:35))
                                 imageView.image = UIImage(named: "Tick30")
                        
                    let alertMessage = UIAlertController(title: "                                                       ", message: "Your Decline Request has been successfully sent...", preferredStyle: .alert)
                    let image = UIImage(named: "Image")
                    let action = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                            
                    _ = self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                    action.setValue(image, forKey: "image")
                    alertMessage.addAction(action)
                    //alertMessage.view.tintColor = #colorLiteral(red: 0.4285447896, green: 0.747687161, blue: 0.3533237576, alpha: 1)
                    //alertMessage.view.backgroundColor = UIColor.white
                    self.present(alertMessage, animated: true, completion: nil)
                    alertMessage.view.addSubview(imageView)
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//  UIAlertController
//  let alertMessage = UIAlertController(title: "SOSIMPLE", message: "Your Approval has been successfully sent...", preferredStyle: .alert)
//  let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//  action.setValue(UIImage(named: "Tick30")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
//  alertMessage .addAction(action)
//  self.present(alertMessage, animated: true, completion: nil)
