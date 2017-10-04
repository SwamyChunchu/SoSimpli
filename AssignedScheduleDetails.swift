//
//  AssignedScheduleDetails.swift
//  SOSIMPLE
//
//  Created by think360 on 17/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class AvailableTrisCell: UITableViewCell {
    
    @IBOutlet weak var runningImage: UIImageView!
    @IBOutlet weak var timeLabrl: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
}


class AssignedScheduleDetails: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var rnngLblhightCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var dateLblHightCnstrnt: NSLayoutConstraint!
    
    @IBOutlet weak var tripRunLbl: UILabel!
    @IBOutlet weak var timerCheckLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var zoneCityLbl: UILabel!
    @IBOutlet weak var bookingIdLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var scheduleNameLbl: UILabel!
    @IBOutlet weak var requestForChngBtn: UIButton!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var emergencyCaseLbl: UILabel!
    
    var timeString = String()
    var cityString = String()
    var zoneString = String()
    var bookIDString = String()
    var infoString = String()
    var phoneString = String()
    var runningStusString = String()
    var tripStaredTime = String()
    var scheduleNameStr = String()
    var scheduleID = String()
    
    var  driverID = String()
    var startTime = String()
    var endTime = String()
    var availabilityID = String()
    
    var startTimeUnix = String()
    var endTimeUnix = String()
    
    var tripID = String()
    var appDel = AppDelegate()
    var timer = Timer()
    var count = 0
    var runningTripStr = String()
    
    @IBOutlet weak var assignDetailTV: UITableView!
    @IBOutlet weak var tableViewHightConstarnt: NSLayoutConstraint!
    var dataArry = NSArray()
    var runningStatusAry = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel = UIApplication.shared.delegate as! AppDelegate
        self.tabBarController?.tabBar.isHidden = true

       if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }
        
        timeLabel.text! = timeString
        cityLbl.text!  = cityString
        zoneCityLbl.text! = String(format:"%@, %@",zoneString,cityString)
        bookingIdLbl.text = String(format:"Booking ID: %@",bookIDString)
        infoLbl.text = infoString
        scheduleNameLbl.text! = scheduleNameStr
        if UserDefaults.standard.value(forKey: "OperatorPhnNum") != nil
        {
           phoneNumLbl.text = UserDefaults.standard.value(forKey: "OperatorPhnNum") as? String
        }else{
            phoneNumLbl.text = ""
        }
        
         timerCheckLabel.text! = ""
       tripRunLbl.isHidden = true
       timerCheckLabel.isHidden = true
       rnngLblhightCnstrnt.constant = 0
       dateLblHightCnstrnt.constant = 0
        
        
        self.tableViewHightConstarnt.constant = 85 * CGFloat(self.dataArry.count)
        self.assignDetailTV.reloadData()
        
        self.runningStatusAry = self.dataArry.value(forKey: "trip_status") as! NSArray
        print(self.runningStatusAry)
        for item in 0..<self.dataArry.count
        {
        let str = self.runningStatusAry.object(at: item) as! String
           if str.contains("0")
           {
            runningTripStr = "OneTripStarted"
            print("one Trip is Running")
            
            //timerCheckLabel.text! = tripStaredTime
            
           }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
      
    }
 
    
    // MARK: TableView Delegates:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        let identifier = "AvailableTrisCell"
        var cell: AvailableTrisCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? AvailableTrisCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AvailableTrisCell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.timeLabrl.text!  = String(format:"%@-%@",(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "time_from") as! String,(self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "time_to") as! String)
        
        let runningStaus:String = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "trip_status") as! String
        if runningStaus == "0" {
            
            cell.checkInButton.isHidden = true
            cell.checkOutButton.isHidden = false
            cell.runningImage.image = #imageLiteral(resourceName: "Green_marker")
            self.timerCheckLabel.text!  = (self.dataArry.object(at: indexPath.row) as! NSDictionary).value(forKey: "start_trip") as! String
            
            self.tripRunLbl.isHidden = false
            self.timerCheckLabel.isHidden = false
            self.rnngLblhightCnstrnt.constant = 30
            self.dateLblHightCnstrnt.constant = 25
            self.requestForChngBtn.isHidden = true
            self.emergencyCaseLbl.isHidden = true
            self.phoneNumLbl.isHidden = true
        }
        else{
            cell.runningImage.image = #imageLiteral(resourceName: "WhiteImg")
            cell.checkOutButton.isHidden = true
        }
        
        if runningTripStr == "OneTripStarted" {
            if runningStaus == "0" {
                
            }
            else{
                cell.checkInButton.backgroundColor = UIColor.lightGray
                cell.checkInButton.isEnabled = false
            }
        }
        
        cell.checkInButton.tag = indexPath.row
        cell.checkInButton.addTarget(self, action: #selector(AssignedScheduleDetails.tableViewCheckInButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        cell.checkOutButton.tag = indexPath.row
        cell.checkOutButton.addTarget(self, action: #selector(AssignedScheduleDetails.tableViewCHECKOUTButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
    }
    
    
// MARK: CheckInTableView Button Action:
    func tableViewCheckInButtonAction(_ sender: UIButton!) {
        
        //print(sender.tag)
        if runningTripStr == "OneTripStarted" {
           AFWrapperClass.alert("SORRY!!", message: "Currently your trip is running. Please finish the trip" , view: self)
        }else{
            
            let startDate = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            startTime = formatter.string(from: startDate as Date)
            
            let formatterStart = DateFormatter()
            formatterStart.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            let dateUnix: Date? = formatterStart.date(from: startTime)
            let since1970: TimeInterval? = dateUnix?.timeIntervalSince1970
            startTimeUnix = String(Int(since1970!))
            
            availabilityID = (self.dataArry.object(at: sender.tag) as! NSDictionary).value(forKey: "Avaibility_id") as! String
            
            self.startTripAPIMethod()
        }
    }
    
    func startTripAPIMethod() -> Void
    {
        let baseURL  = String(format: "%@driver_trip",Constants.mainURL)
        let params = "driver_id=\(driverID)&start_trip=\(startTimeUnix)&avail_id=\(availabilityID)"
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    
                    self.requestForChngBtn.isHidden = true
                    self.emergencyCaseLbl.isHidden = true
                    self.phoneNumLbl.isHidden = true
                    
//                    let tripNum:NSNumber = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "tripid") as! NSNumber
//                    self.tripID = String(describing: tripNum)
//                   self.timerCheckLabel.text! = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "start_trip") as! String
                    
                    self.tripRunLbl.isHidden = false
                    self.timerCheckLabel.isHidden = false
                    self.rnngLblhightCnstrnt.constant = 30
                    self.dateLblHightCnstrnt.constant = 25
                    
                    self.getAvailableTripsAPIMethod ()

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
    
    // MARK: CheckOUT TableView Button Action:
      func tableViewCHECKOUTButtonAction(_ sender: UIButton!) {
        
        let endDate = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        endTime = formatter.string(from: endDate as Date)
        
        let formatterEnd = DateFormatter()
        formatterEnd.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let dateUnix: Date? = formatterEnd.date(from: endTime)
        let since1970: TimeInterval? = dateUnix?.timeIntervalSince1970
        endTimeUnix = String(Int(since1970!))
        
        availabilityID = (self.dataArry.object(at: sender.tag) as! NSDictionary).value(forKey: "Avaibility_id") as! String
        tripID = (self.dataArry.object(at: sender.tag) as! NSDictionary).value(forKey: "trip_id") as! String
        self.endTripAPIMethod()
 
    }
    
    func endTripAPIMethod() -> Void
    {
        let baseURL  = String(format: "%@driver_tripFinish",Constants.mainURL)
        let params = "driver_id=\(driverID)&end_trip=\(endTimeUnix)&avail_id=\(availabilityID)&tripid=\(tripID)"
        print(params)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                     print(responceDic)
//                   self.checkOUTbtn.isHidden = true
//                   self.checkINbtn.isHidden = false
//                   self.timerCheckLabel.backgroundColor = #colorLiteral(red: 0.8665933013, green: 0.8667152524, blue: 0.8665547967, alpha: 1)
//                   self.timerCheckLabel.textColor = #colorLiteral(red: 0.294089824, green: 0.2941360176, blue: 0.2940752506, alpha: 1)
                     self.appDel.startTripString = "TripClosed"
                     self.runningTripStr = "OneTripStartedClosed"
                    
               let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "FinishBookingVC") as! FinishBookingVC
               self.navigationController?.pushViewController(simpliVC, animated: true)
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
                    self.dataArry = responceDic.object(forKey: "data") as! NSArray
                    
                    self.tableViewHightConstarnt.constant = 85 * CGFloat(self.dataArry.count)
                    self.runningStatusAry = self.dataArry.value(forKey: "trip_status") as! NSArray
                    print(self.runningStatusAry)
                    for item in 0..<self.dataArry.count
                    {
                        let str = self.runningStatusAry.object(at: item) as! String
                        if str.contains("0")
                        {
                            self.runningTripStr = "OneTripStarted"
                            print("one Trip is Running")
                            //timerCheckLabel.text! = tripStaredTime
                        }
                    }
                    self.assignDetailTV.reloadData()
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
    
    @IBAction func requestChangeBtnAction(_ sender: Any)
    {
        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeAssignedSchedule") as! ChangeAssignedSchedule
        self.navigationController?.pushViewController(simpliVC, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any)
    {
         _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
