//
//  ScheduleVC.swift
//  SOSIMPLE
//
//  Created by think360 on 11/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ScheduleTVCell: UITableViewCell {
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var zoneCityLbl: UILabel!
    @IBOutlet weak var bookIdLbl: UILabel!
    @IBOutlet weak var runningStusImage: UIImageView!
    @IBOutlet weak var scheduleName: UILabel!
}

class ScheduleVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scheduleTblView: UITableView!
    @IBOutlet weak var noDataFndLbl: UILabel!
    
    var driverID = String()
    var dataArry = NSArray()
    var runningStatusAry = NSArray()
    var appDel = AppDelegate()
    var frontView = UIView()
    
    var timeString = String()
    var cityString = String()
    var zoneString = String()
    var bookIDString = String()
    var infoString = String()
    var availabilityID = String()
    var runningStusString = String()
    var tripID = String()
    var tripStaredTime = String()
    var scheduleNameStr = String()
    var sosZoneStr = String()
    var scheduleID = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noDataFndLbl.isHidden = true
        self.scheduleTblView.isHidden = true

        appDel = UIApplication.shared.delegate as! AppDelegate
        if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }
        
        frontView.frame = CGRect(x:0, y:64, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1")!)
        frontView.isHidden=true
        if UI_USER_INTERFACE_IDIOM() == .pad {
            frontView.frame = CGRect(x:0, y:80, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
        self.view.addSubview(frontView)

        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 260
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        //self.getApprovedAvailableAPIMethod()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.appDel.startTripString = ""
        
        self.revealViewController().delegate=self
        
        frontView.frame = CGRect(x:0, y:64, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1")!)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            frontView.frame = CGRect(x:0, y:80, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
        frontView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        frontView.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        frontView.isHidden=true
        self.view.addSubview(frontView)
        
        self.getApprovedAvailableAPIMethod()
        self.badgeCountAPIMethod()
    }
    
    func getApprovedAvailableAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@avalibilityapprove",Constants.mainURL)
        let params = "driver_id=\(driverID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    self.noDataFndLbl.isHidden = true
                    self.scheduleTblView.isHidden = false
                    self.dataArry = responceDic.object(forKey: "data") as! NSArray
                    
                    self.runningStatusAry = self.dataArry.value(forKey: "trip_status") as! NSArray
                    print(self.runningStatusAry)
                    for item in 0..<self.dataArry.count
                    {
                        let str = self.runningStatusAry.object(at: item) as! String
                        if str.contains("0")
                        {
                            self.appDel.startTripString = "TripStarted"
                            print("one Trip is Running")
                        }
                    }
                    self.scheduleTblView.reloadData()
                }
                else
                {
                    self.noDataFndLbl.isHidden = false
                    self.scheduleTblView.isHidden = true
                //  AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
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
        return self.dataArry.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        
        let identifier = "ScheduleTVCell"
        var cell: ScheduleTVCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ScheduleTVCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ScheduleTVCell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.dayLbl.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Day") as! String
        cell.monthLbl.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Month") as! String
        cell.bookIdLbl.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "randonno") as! String
        cell.timeLbl.text!  = String(format:"%@-%@",(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Schdule_TimeFrom") as! String,(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Schdule_TimeTo") as! String)
        cell.scheduleName.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_name") as! String
        
        var zoneID:String = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_zones") as! String
        if zoneID == "<null>"
        {
            zoneID = ""
        }
        
        var sosZoneStr = String()
        if zoneID == "1"
        {
            sosZoneStr = "East Zone"
        }else if zoneID == "2"
        {
            sosZoneStr = "West Zone"
        }else if zoneID == "3"
        {
            sosZoneStr = "North Zone"
        }else if zoneID == "4"
        {
            sosZoneStr = "South Zone"
        }
       cell.zoneCityLbl.text!  = String(format:"%@, %@",sosZoneStr,(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_city") as! String)
        
        let stateStr:String = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "avalibality_status") as! String
        if stateStr == "1" {
            cell.runningStusImage.image = #imageLiteral(resourceName: "Assignd_state")
        }
        else{
            cell.runningStusImage.image = #imageLiteral(resourceName: "WhiteImg")
        }

        let runningStateStr:String = self.runningStatusAry.object(at: indexPath.row) as! String
        if runningStateStr == "0"
        {
            cell.runningStusImage.image = #imageLiteral(resourceName: "Green_marker")
        }
//       else{
//            cell.runningStusImage.image = #imageLiteral(resourceName: "WhiteImg")
//        }
        
        return cell
    }
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var zoneID:String = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_zones") as! String
        if zoneID == "<null>"
        {
            zoneID = ""
        }
       
        if zoneID == "1"
        {
            sosZoneStr = "East Zone"
        }else if zoneID == "2"
        {
            sosZoneStr = "West Zone"
        }else if zoneID == "3"
        {
            sosZoneStr = "North Zone"
        }else if zoneID == "4"
        {
            sosZoneStr = "South Zone"
        }
        
        
        self.timeString = String(format:"%@-%@",(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Schdule_TimeFrom") as! String,(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Schdule_TimeTo") as! String)
        self.cityString = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_city") as! String
        self.zoneString = sosZoneStr
        self.bookIDString  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "randonno") as! String
        self.infoString  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_info") as! String
        self.availabilityID  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "availability_id") as! String
        self.runningStusString  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "trip_status") as! String
        self.tripID  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "trip_id") as! String
        self.tripStaredTime = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "tripadd_time") as! String
        self.scheduleNameStr  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_name") as! String
        self.scheduleID = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_id") as! String
        
      

        let rnngStsStr = self.runningStatusAry.object(at: indexPath.row) as! String
        if rnngStsStr == "0" {
            
            self.getAvailableTripsAPIMethod()
            
//            let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "AssignedScheduleDetails") as! AssignedScheduleDetails
//            self.navigationController?.pushViewController(simpliVC, animated: true)
//            
//            simpliVC.timeString = self.timeString
//            simpliVC.cityString = self.cityString
//            simpliVC.zoneString = self.sosZoneStr
//            simpliVC.bookIDString = self.bookIDString
//            simpliVC.infoString = self.infoString
//            simpliVC.availabilityID = self.availabilityID
//            simpliVC.runningStusString = self.runningStusString
//            simpliVC.tripID = self.tripID
//            simpliVC.tripStaredTime = self.tripStaredTime
//            simpliVC.scheduleNameStr  = self.scheduleNameStr
        }
        
        else if self.appDel.startTripString == "TripStarted"
        {
            //AFWrapperClass.alert(Constants.applicationName, message: "Currently your trip is running", view: self)
            
            let alertMessage = UIAlertController(title: "SOSIMPLI", message: "Currently your trip is running", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertMessage .addAction(action)
            DispatchQueue.main.async {
            self.present(alertMessage, animated: true, completion: nil)
            }
        }
        else{
            let Mydate:String = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "Day") as! String
            let curntDate = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let currentDate = formatter.string(from: curntDate as Date)
           // print(Mydate,currentDate)
            
            if String(currentDate) == Mydate {
                
//                let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "AssignedScheduleDetails") as! AssignedScheduleDetails
//                self.navigationController?.pushViewController(simpliVC, animated: true)
//                
//                simpliVC.timeString = self.timeString
//                simpliVC.cityString = self.cityString
//                simpliVC.zoneString = self.sosZoneStr
//                simpliVC.bookIDString = self.bookIDString
//                simpliVC.infoString = self.infoString
//                simpliVC.availabilityID = self.availabilityID
//                simpliVC.runningStusString = self.runningStusString
//                simpliVC.tripID = self.tripID
//                simpliVC.tripStaredTime = self.tripStaredTime
//                simpliVC.scheduleNameStr  = self.scheduleNameStr
//                simpliVC.scheduleID  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "schdule_id") as! String
                self.getAvailableTripsAPIMethod()
                
            }else{
                AFWrapperClass.alert("SORRY!!", message: "You can't start the future trip" , view: self)
            }
        }
    }
    
    
    func getAvailableTripsAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@avail_list",Constants.mainURL)
        let params = "driver_id=\(driverID)&schedule_id=\(scheduleID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "AssignedScheduleDetails") as! AssignedScheduleDetails
                    self.navigationController?.pushViewController(simpliVC, animated: true)
                    
                    simpliVC.timeString = self.timeString
                    simpliVC.cityString = self.cityString
                    simpliVC.zoneString = self.sosZoneStr
                    simpliVC.bookIDString = self.bookIDString
                    simpliVC.infoString = self.infoString
                    simpliVC.availabilityID = self.availabilityID
                    simpliVC.runningStusString = self.runningStusString
                    simpliVC.tripID = self.tripID
                    simpliVC.tripStaredTime = self.tripStaredTime
                    simpliVC.scheduleNameStr  = self.scheduleNameStr
                    simpliVC.scheduleID  = self.scheduleID
                    simpliVC.dataArry = responceDic.object(forKey: "data") as! NSArray
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

    
    
    
    //MARK: Notification Count:
    func badgeCountAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@sos_count",Constants.mainURL)
        let params = "driver_id=\(driverID)"
      //  AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
            //    AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                   // print(responceDic)
                    let countStr:String = (responceDic.object(forKey:"data") as! NSDictionary).object(forKey:"count") as! String
                    if countStr == "0"
                    {
                        self.tabBarController?.tabBar.items?[2].badgeValue = nil
                    }else{
                        self.tabBarController?.tabBar.items?[2].badgeValue = countStr
                    }
                }
                else
                {
                AFWrapperClass.svprogressHudDismiss(view: self)
                // AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
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

extension ScheduleVC: SWRevealViewControllerDelegate
{
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionLeft {
            //  self.view.addSubview(frontView)
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
        else {
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=false
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
    }
    func revealController(_ revealController: SWRevealViewController, didMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionLeft {
            //  self.view.addSubview(frontView)
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
        else {
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=false
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }
    }
}
