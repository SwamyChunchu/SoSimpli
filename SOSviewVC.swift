//
//  SOSviewVC.swift
//  SOSIMPLE
//
//  Created by think360 on 11/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class SOSTableCell: UITableViewCell
{
    @IBOutlet weak var zoneTypeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
}


class SOSviewVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var sosTblView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var noDataFndLbl: UILabel!
    
    var driverID = String()
    var dataArray = NSArray()
    var sosID = String()
    var frontView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noDataFndLbl.isHidden = true
        self.sosTblView.isHidden = true
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.sosNotificationAPIMethod()
        self.readNotificationAPIMethod()
        
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
        

    }
    
    func sosNotificationAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@get_sosall",Constants.mainURL)
        let params = ""
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                   // print(responceDic)
                    self.noDataFndLbl.isHidden = true
                    self.sosTblView.isHidden = false
                    self.dataArray = responceDic.value(forKey: "data") as! NSArray
                    self.sosTblView.reloadData()
                    AFWrapperClass.svprogressHudDismiss(view: self)
                }
                else
                {
                    self.sosTblView.isHidden = true
                    self.noDataFndLbl.isHidden = false
                    AFWrapperClass.svprogressHudDismiss(view: self)
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
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        
        let identifier = "SOSTableCell"
        var cell: SOSTableCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SOSTableCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SOSTableCell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        let zoneID:String = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "zones") as! String
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
       cell.dateLbl.text! = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "sos_time") as! String
       cell.timeLbl.text! = String(format: "%@ - %@",(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "TimeFrom") as! String,(self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "TimeTo") as! String)
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        sosID  = (self.dataArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "sos_id") as! String
        self.sosNotDetailsAPImethod()
    }
    
    func sosNotDetailsAPImethod () -> Void
    {
        let baseURL  = String(format: "%@sos_details",Constants.mainURL)
        let params = "sos_id=\(sosID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    
               // print(responceDic)
                let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "SOSdetailsVC") as! SOSdetailsVC
                self.navigationController?.pushViewController(simpliVC, animated: true)
                    
                simpliVC.dataDic = responceDic.value(forKey: "data") as! NSDictionary
                simpliVC.sosID = self.sosID
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
    
    func readNotificationAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@readsoscount",Constants.mainURL)
        let params = "driver_id=\(driverID)"
       // AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                //AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
               // print(responceDic)
                self.tabBarController?.tabBar.items?[2].badgeValue = nil
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

extension SOSviewVC: SWRevealViewControllerDelegate
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
