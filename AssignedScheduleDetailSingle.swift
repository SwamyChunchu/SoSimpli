//
//  AssignedScheduleDetailSingle.swift
//  SOSIMPLE
//
//  Created by think360 on 08/09/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class AssignedScheduleDetailSingle: UIViewController {

    
    
    @IBOutlet weak var dateLblHightCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var rnngLblhightCnstrnt: NSLayoutConstraint!
    
    @IBOutlet weak var tripRunLbl: UILabel!
    @IBOutlet weak var checkINbtn: UIButton!
    @IBOutlet weak var checkOUTbtn: UIButton!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }
        
        self.tabBarController?.tabBar.isHidden = true
        checkOUTbtn.isHidden = true
        
        
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
                if runningStusString == "0"
                {
                    self.checkOUTbtn.isHidden = false
                    self.checkINbtn.isHidden = true
                    timerCheckLabel.text! = tripStaredTime
                    tripRunLbl.isHidden = false
                    timerCheckLabel.isHidden = false
                    rnngLblhightCnstrnt.constant = 30
                    dateLblHightCnstrnt.constant = 25
                    requestForChngBtn.isHidden = true
                    emergencyCaseLbl.isHidden = true
                    phoneNumLbl.isHidden = true
        
                }else{
        
                    timerCheckLabel.text! = ""
                    tripRunLbl.isHidden = true
                    timerCheckLabel.isHidden = true
                    rnngLblhightCnstrnt.constant = 0
                    dateLblHightCnstrnt.constant = 0
                }
    }

    
    
    
    
    
// MARK: CheckIn Button Action:
    
    @IBAction func checkInbuttonAction(_ sender: Any) {
        let startDate = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        startTime = formatter.string(from: startDate as Date)
        
        let formatterStart = DateFormatter()
        formatterStart.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let dateUnix: Date? = formatterStart.date(from: startTime)
        let since1970: TimeInterval? = dateUnix?.timeIntervalSince1970
        startTimeUnix = String(Int(since1970!))
        
        self.startTripAPIMethod()
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
                    
                    self.checkOUTbtn.isHidden = false
                    self.checkINbtn.isHidden = true
                    self.requestForChngBtn.isHidden = true
                    self.emergencyCaseLbl.isHidden = true
                    self.phoneNumLbl.isHidden = true
                    
                    let tripNum:NSNumber = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "tripid") as! NSNumber
                    self.tripID = String(describing: tripNum)
                    
                    self.timerCheckLabel.text! = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "start_trip") as! String
                    self.tripRunLbl.isHidden = false
                    self.timerCheckLabel.isHidden = false
                    self.rnngLblhightCnstrnt.constant = 30
                    self.dateLblHightCnstrnt.constant = 25
                    
                    // self.timerCheckLabel.backgroundColor = #colorLiteral(red: 0.1651478112, green: 0.8324636817, blue: 0, alpha: 1)
                    // self.timerCheckLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    // self.count = 0
                    // self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
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

    
    // MARK: CheckOut Button Action:
    @IBAction func checkOUTbuttonAction(_ sender: Any) {
        
        let endDate = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        endTime = formatter.string(from: endDate as Date)
        
        let formatterEnd = DateFormatter()
        formatterEnd.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let dateUnix: Date? = formatterEnd.date(from: endTime)
        let since1970: TimeInterval? = dateUnix?.timeIntervalSince1970
        endTimeUnix = String(Int(since1970!))
        
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
                    //  self.checkOUTbtn.isHidden = true
                    //  self.checkINbtn.isHidden = false
                    //  self.timerCheckLabel.backgroundColor = #colorLiteral(red: 0.8665933013, green: 0.8667152524, blue: 0.8665547967, alpha: 1)
                    //  self.timerCheckLabel.textColor = #colorLiteral(red: 0.294089824, green: 0.2941360176, blue: 0.2940752506, alpha: 1)
                    self.appDel.startTripString = "TripClosed"
                    
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
    
    @IBAction func requestChangeBtnAction(_ sender: Any) {
        
        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeAssignedSchedule") as! ChangeAssignedSchedule
        self.navigationController?.pushViewController(simpliVC, animated: true)
    }

    @IBAction func backButtonAction(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
