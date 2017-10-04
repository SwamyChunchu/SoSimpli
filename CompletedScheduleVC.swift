//
//  CompletedScheduleVC.swift
//  SOSIMPLE
//
//  Created by think360 on 14/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class CompleteScheduleCell: UITableViewCell {
    
    @IBOutlet weak var zoneTypeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
   
}

class CompletedScheduleVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {

    @IBOutlet weak var completeSchedTV: UITableView!
    var  driverID = String()
    var dataArray = NSArray()
    var scheduleID = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }

        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.completedScheduleAPIMethod()
    }
    
    
    func completedScheduleAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@completeschdule",Constants.mainURL)
        let params = "driver_id=\(driverID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    self.completeSchedTV.isHidden = false
                    self.dataArray = responceDic.value(forKey: "data") as! NSArray
                    self.completeSchedTV.reloadData()
                }
                else
                {
                self.completeSchedTV.isHidden = true
                // AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
   
    // MARK: TableView Delegates:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        
        let identifier = "CompleteScheduleCell"
        var cell: CompleteScheduleCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? CompleteScheduleCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CompleteScheduleCell
        }
         cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        
        var zoneID:String = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "schdule_zone") as! String
        if zoneID == "<null>"
        {
            zoneID = ""
        }
        
        var sosZoneStr = String()
        if zoneID == "1"
        {
            sosZoneStr = "EAST ZONE"
        }else if zoneID == "2"
        {
            sosZoneStr = "WEST ZONE"
        }else if zoneID == "3"
        {
            sosZoneStr = "NORTH ZONE"
        }else if zoneID == "4"
        {
            sosZoneStr = "SOUTH ZONE"
        }
        cell.zoneTypeLbl.text! = sosZoneStr
        cell.dateLbl.text! = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "schdule_date") as! String
        cell.timeLbl.text! = String(format: "%@ - %@",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "TimeFrom") as! String,(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "TimeTo") as! String)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        scheduleID  = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "schdule_id") as! String
        self.sosNotDetailsAPImethod()
    }

    func sosNotDetailsAPImethod () -> Void
    {
        let baseURL  = String(format: "%@schdule_details",Constants.mainURL)
        let params = "schdule_id=\(scheduleID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    
                    print(responceDic)
                    
                let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "CompleteScheduleDetailsVC") as! CompleteScheduleDetailsVC
                self.navigationController?.pushViewController(simpliVC, animated: true)
                simpliVC.dataDic = responceDic.value(forKey: "data") as! NSDictionary
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
