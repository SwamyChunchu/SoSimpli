//
//  NonApprovedShiftVC.swift
//  SOSIMPLE
//
//  Created by think360 on 21/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class NonApprovedShiftVC: UIViewController,UITableViewDelegate,UITableViewDataSource
 {
    var notAvailCell: NonAvailCell!
    
    @IBOutlet weak var nonApprovedTblVw: UITableView!
    var  driverID = String()
    var dataArry = NSArray()
    var selectedID = String()
    
    @IBOutlet weak var noDataFndLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noDataFndLbl.isHidden = true
        self.nonApprovedTblVw.isHidden = true
        if UserDefaults.standard.value(forKey: "driverID") != nil
        {
        driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.getNonApprovedAvailableAPIMethod()
    }
    
    func getNonApprovedAvailableAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@avalibilitynonapprove",Constants.mainURL)
        let params = "driver_id=\(driverID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    self.nonApprovedTblVw.isHidden = false
                    self.noDataFndLbl.isHidden = true
                    self.dataArry = responceDic.object(forKey: "data") as! NSArray
                    self.nonApprovedTblVw.reloadData()
                }
                else
                {
                    self.nonApprovedTblVw.isHidden = true
                    self.noDataFndLbl.isHidden = false
            // AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }

    
//MARK: TableView Delegates and Datasource:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        let identifier = "NonAvailCell"
        notAvailCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NonAvailCell
        
        if notAvailCell == nil
        {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            notAvailCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NonAvailCell
        }
        notAvailCell.selectionStyle = UITableViewCellSelectionStyle.none
        notAvailCell.dayLbl.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Day") as! String
        notAvailCell.monthLbl.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Month") as! String
        notAvailCell.timeLbl.text!  = String(format:"%@-%@",(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "from_time") as! String,(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "to_time") as! String)
         notAvailCell.zoneLbl.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "zone") as! String
         notAvailCell.cityLbl.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "cityname") as! String
        
        return notAvailCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "EditAvailibilityVC") as! EditAvailibilityVC
//        self.navigationController?.pushViewController(simpliVC, animated: true)
        
         self.selectedID = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "availability_id") as! String
        self.getDetailsAvailableAPIMethod()

    }
    
        func getDetailsAvailableAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@getnon_approvedavalibality",Constants.mainURL)
        let params = "id=\(selectedID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    //print(responceDic)
                    let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "EditAvailibilityVC") as! EditAvailibilityVC
                    self.navigationController?.pushViewController(simpliVC, animated: true)
                    simpliVC.dataDic = responceDic.object(forKey: "data") as! NSDictionary
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
