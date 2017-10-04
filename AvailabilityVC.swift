//
//  AvailabilityVC.swift
//  SOSIMPLE
//
//  Created by think360 on 11/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit


class AvailabilityVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var availCell: AvailableCell!
    @IBOutlet weak var backViewTable: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var availableTableVW: UITableView!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var nonApproveBtn: UIButton!
    
    var dataArray = NSArray()
    
    var sectionAry = NSArray()
    var startTimeAry = NSArray()
    var endTimeAry = NSArray()
    var cityZoneAry =  NSArray()
    var cityNameAry =  NSArray()
    var statusAry =  NSArray()
    var bookingIDAry =  NSArray()
    var infoAry =  NSArray()
    var runningStatusAry = NSArray()
    var tripIDAry = NSArray()
    var tripStartedDate = NSArray()
    var scheduleStrtTM = NSArray()
    var scheduleEndTM = NSArray()
    var scheduleCity = NSArray()
    var scheduleZoneAry = NSArray()
    var scheduleNameAry = NSArray()
    var scheduleIDAry = NSArray()
    
    var availabilityIDAry =  NSArray()
    var  driverID = String()
    var selectedID = String()
    var appDel = AppDelegate()
    
    var timeString = String()
    var cityString = String()
    var scheduleZoneStr = String()
    var bookIDString = String()
    var infoString = String()
    var availabilityID = String()
    var runningStusString = String()
    var tripID = String()
    var tripStaredTime = String()
    var scheduleNameStr = String()
    var scheduleID = String()
    
    var frontView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        appDel = UIApplication.shared.delegate as! AppDelegate
        //UIApplication.shared.applicationIconBadgeNumber = 0
        self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.8797463775, green: 0.1150355414, blue: 0.1554988027, alpha: 1)
        
       
       //self.perform(#selector(AvailabilityVC.showTableView), with: nil, afterDelay: 0.02)

    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
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
        
        self.tabBarController?.tabBar.isHidden = false
        self.getAvailableAPIMethod()
        self.badgeCountAPIMethod()
    }
    
//    func showTableView()
//    {
//    }
    
    func getAvailableAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@getavalibility",Constants.mainURL)
        let params = "driver_id=\(driverID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
               
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    
                AFWrapperClass.svprogressHudDismiss(view: self)
                self.availableTableVW.isHidden = false
                print(responceDic)
                  
                self.dataArray = responceDic.object(forKey: "data") as! NSArray
                  
                self.sectionAry = (responceDic.object(forKey: "data") as! NSArray).value(forKey: "start_date") as! NSArray
                    
                self.startTimeAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "from_time") as! NSArray
                self.endTimeAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "to_time") as! NSArray
                self.cityZoneAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "availabiliy_zones") as! NSArray
                self.cityNameAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "availability_city") as! NSArray
                self.statusAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "avalibality_status") as! NSArray
                self.availabilityIDAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "avalability_id") as! NSArray
                 self.bookingIDAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "randonno") as! NSArray
                self.infoAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "schdule_info") as! NSArray
                self.tripIDAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "tripid") as! NSArray
                self.tripStartedDate = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "trip_start") as! NSArray
                self.scheduleStrtTM = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "Schdule_TimeFrom") as! NSArray
                self.scheduleEndTM = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "Schdule_TimeTo") as! NSArray
                self.scheduleCity = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "schdule_city") as! NSArray
                self.scheduleZoneAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "schdule_zones") as! NSArray
                self.scheduleNameAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "schdule_name") as! NSArray
                self.scheduleIDAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "schdule_id") as! NSArray
                    
                self.runningStatusAry = ((responceDic.object(forKey: "data") as! NSArray).value(forKey: "time") as! NSArray).value(forKey: "trip_status") as! NSArray
                //    print(self.runningStatusAry)
                    for item in 0..<self.runningStatusAry.count
                    {
                        let str = self.runningStatusAry.object(at: item) as! NSArray
                        if str.contains("0")
                        {
                            self.appDel.startTripString = "TripStarted"
                            print("one Trip is Running")
                        }
                    }
                
                self.availableTableVW.reloadData()
               }
                else
                {
                    self.availableTableVW.isHidden = true
                   // AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                     AFWrapperClass.svprogressHudDismiss(view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    //MARK: TableView Delegates and Datasource:
    func numberOfSections(in tableView: UITableView) -> Int {
      return self.sectionAry.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 45
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//     return  self.sectionAry[section] as? String
//    }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor     = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        sectionView.layer.shadowColor   = UIColor.black.cgColor
        sectionView.layer.shadowOpacity = 0.3
        sectionView.layer.shadowOffset  = CGSize.zero
        sectionView.layer.shadowRadius  = 4
        sectionView.layer.shadowOffset  = CGSize(width: -1, height: 1)
        
        let  imageview = UIImageView()
        imageview.frame = CGRect(x: 12, y: 9 ,width:28 ,height: 28)
        imageview.image = #imageLiteral(resourceName: "Calendar")
        sectionView.addSubview(imageview)
        
        let dateLbl = UILabel()
        dateLbl.frame = CGRect(x: 50, y: 9 ,width:self.view.frame.size.width-60 ,height: 28)
       // dateLbl.text = self.sectionAry[section] as? String
        dateLbl.textColor = #colorLiteral(red: 0.02187439241, green: 0.1667111814, blue: 0.2265078723, alpha: 1)
        sectionView.addSubview(dateLbl)
        
        let Mydate = self.sectionAry[section] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: Mydate!)
        dateFormatter.dateFormat = "EEEE / dd MMMM yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let finalDate = dateFormatter.string(from: date!)
        dateLbl.text = finalDate
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
          return  (startTimeAry[section]  as! NSArray).count
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
       tableView.separatorStyle = .none
       tableView.separatorColor = UIColor.clear
        let identifier = "AvailableCell"
        availCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AvailableCell
        if availCell == nil
        {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            availCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AvailableCell
        }
    availCell.selectionStyle = UITableViewCellSelectionStyle.none
        
    //  let arr : NSArray = items[indexPath.section] as! NSArray
    //    availCell.timelabel?.text! = (startTimeAry[indexPath.section] as! NSArray)[indexPath.row] as! String
    
    availCell.timelabel?.text! = String(format:"%@ - %@",(startTimeAry[indexPath.section] as! NSArray)[indexPath.row] as! String ,(endTimeAry[indexPath.section] as! NSArray)[indexPath.row] as! String)
    
    availCell.locationName?.text! = String(format:"%@, %@",
    (cityZoneAry[indexPath.section] as! NSArray)[indexPath.row] as! String ,(cityNameAry[indexPath.section] as! NSArray)[indexPath.row] as! String)
    
    let stateStr:String = (statusAry[indexPath.section] as! NSArray)[indexPath.row] as! String
    if stateStr == "1" {
        availCell.assignedStateImg.image = #imageLiteral(resourceName: "Assignd_state")
        availCell.bookingIDLbl.isHidden = false
        availCell.bookingIDLbl?.text! = (bookingIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
            
        }
        else{
            availCell.assignedStateImg.image = #imageLiteral(resourceName: "WhiteImg")
             availCell.bookingIDLbl.isHidden = true
            availCell.bookingIDLbl?.text! = ""
        }
    let runningStateStr:String = (runningStatusAry[indexPath.section] as! NSArray)[indexPath.row] as! String
        
    if runningStateStr == "0"
    {
        availCell.assignedStateImg.image = #imageLiteral(resourceName: "Green_marker")
    }
    
    availCell.lastLineLbl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    if indexPath.row ==  (startTimeAry[indexPath.section]  as! NSArray).count-1
    {
        availCell.lastLineLbl.backgroundColor = UIColor.clear
    }
    
    return availCell
    
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let runningSts:String = (runningStatusAry[indexPath.section] as! NSArray)[indexPath.row] as! String
        let stateStr:String = (statusAry[indexPath.section] as! NSArray)[indexPath.row] as! String
        let zoneID:String = (scheduleZoneAry[indexPath.section] as! NSArray)[indexPath.row] as! String
        
        if zoneID == "1"
        {
            scheduleZoneStr = "East zone"
        }else if zoneID == "2"
        {
            scheduleZoneStr = "West zone"
        }else if zoneID == "3"
        {
            scheduleZoneStr = "North zone"
        }else if zoneID == "4"
        {
            scheduleZoneStr = "South zone"
        }
        
            self.timeString =  String(format:"%@ - %@",(scheduleStrtTM[indexPath.section] as! NSArray)[indexPath.row] as! String ,(scheduleEndTM[indexPath.section] as! NSArray)[indexPath.row] as! String)
            self.cityString =  (scheduleCity[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.bookIDString  = (bookingIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.infoString  = (infoAry[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.availabilityID  =  (availabilityIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.runningStusString  = (runningStatusAry[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.tripID  = (tripIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.tripStaredTime =  (tripStartedDate[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.scheduleNameStr  = (scheduleNameAry[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.scheduleID =  (scheduleIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
        
        
        
        
        if stateStr == "1" {
            if runningSts == "0"
            {
                
                let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "AssignedScheduleDetailSingle") as! AssignedScheduleDetailSingle
                self.navigationController?.pushViewController(simpliVC, animated: true)
                simpliVC.timeString = self.timeString
                simpliVC.cityString = self.cityString
                simpliVC.zoneString = self.scheduleZoneStr
                simpliVC.bookIDString = self.bookIDString
                simpliVC.infoString = self.infoString
                simpliVC.availabilityID = self.availabilityID
                simpliVC.runningStusString = self.runningStusString
                simpliVC.tripID = self.tripID
                simpliVC.tripStaredTime = self.tripStaredTime
                simpliVC.scheduleNameStr  = self.scheduleNameStr
//
//                simpliVC.timeString =  String(format:"%@ - %@",(scheduleStrtTM[indexPath.section] as! NSArray)[indexPath.row] as! String ,(scheduleEndTM[indexPath.section] as! NSArray)[indexPath.row] as! String)
//                simpliVC.cityString = (scheduleCity[indexPath.section] as! NSArray)[indexPath.row] as! String
//                simpliVC.zoneString = scheduleZoneStr
//                simpliVC.bookIDString = (bookingIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                simpliVC.infoString = (infoAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                simpliVC.availabilityID = (availabilityIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                simpliVC.runningStusString = (runningStatusAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                simpliVC.tripID = (tripIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                simpliVC.tripStaredTime = (tripStartedDate[indexPath.section] as! NSArray)[indexPath.row] as! String
//                simpliVC.scheduleNameStr = (scheduleNameAry[indexPath.section] as! NSArray)[indexPath.row] as! String
                
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
            else if stateStr == "1"
            {
                let Mydate:String = self.sectionAry[indexPath.section] as! String
                
                let curntDate = NSDate()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                let currentDate = formatter.string(from: curntDate as Date)
                if String(currentDate) == Mydate {
                    
                    
                    let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "AssignedScheduleDetailSingle") as! AssignedScheduleDetailSingle
                    self.navigationController?.pushViewController(simpliVC, animated: true)
                    
                    simpliVC.timeString = self.timeString
                    simpliVC.cityString = self.cityString
                    simpliVC.zoneString = self.scheduleZoneStr
                    simpliVC.bookIDString = self.bookIDString
                    simpliVC.infoString = self.infoString
                    simpliVC.availabilityID = self.availabilityID
                    simpliVC.runningStusString = self.runningStusString
                    simpliVC.tripID = self.tripID
                    simpliVC.tripStaredTime = self.tripStaredTime
                    simpliVC.scheduleNameStr  = self.scheduleNameStr

//                    simpliVC.timeString =  String(format:"%@ - %@",(scheduleStrtTM[indexPath.section] as! NSArray)[indexPath.row] as! String ,(scheduleEndTM[indexPath.section] as! NSArray)[indexPath.row] as! String)
//                    simpliVC.cityString = (scheduleCity[indexPath.section] as! NSArray)[indexPath.row] as! String
//                    simpliVC.zoneString = scheduleZoneStr
//                    simpliVC.bookIDString = (bookingIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                    simpliVC.infoString = (infoAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                    simpliVC.availabilityID = (availabilityIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                    simpliVC.runningStusString = (runningStatusAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                    simpliVC.tripID = (tripIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
//                    simpliVC.tripStaredTime = (tripStartedDate[indexPath.section] as! NSArray)[indexPath.row] as! String
//                    simpliVC.scheduleNameStr = (scheduleNameAry[indexPath.section] as! NSArray)[indexPath.row] as! String
                }else{
                  AFWrapperClass.alert("SORRY!!", message: "You can't start the future trip" , view: self)
                }
            }
        }
        else{
            self.selectedID = (availabilityIDAry[indexPath.section] as! NSArray)[indexPath.row] as! String
            self.getDetailsAvailableAPIMethod()
        }
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
            // print(responceDic)
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
    
    
    
    

    @IBAction func addAvailibilityBtnAction(_ sender: Any)
    {
        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "AddAvailibilityVC") as! AddAvailibilityVC
        self.navigationController?.pushViewController(simpliVC, animated: true)
    }
    
    @IBAction func approvedBtnAction(_ sender: Any)
    {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func nonApprovedBtnAction(_ sender: Any) {
        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "NonApprovedShiftVC") as! NonApprovedShiftVC
        self.navigationController?.pushViewController(simpliVC, animated: true)
    
    }
    
 //MARK: Notification Count:
    func badgeCountAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@sos_count",Constants.mainURL)
        let params = "driver_id=\(driverID)"
       // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
            //    AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
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

extension AvailabilityVC: SWRevealViewControllerDelegate
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

