//
//  FloorPlanController.swift
//  monitor
//
//  Created by Xueting Yu on 11/4/16.
//  Copyright © 2016 XuetingYu. All rights reserved.
//

import UIKit
import NMSSH

class FloorPlanController: UIViewController {
    
    internal var counter = 0
    @IBOutlet weak var imgView: UIImageView!
    
    var SegueIdentifier = "ShowMonitorDetailSegue"
    
    @IBOutlet weak var bed1: UIButton!
    
    @IBOutlet weak var bed2: UIButton!
    
    @IBOutlet weak var living: UIButton!
    
    @IBOutlet weak var kitchen: UIButton!
    
    var bed1Cam = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton(but: bed1)
        setButton(but: bed2)
        setButton(but: living)
        setButton(but: kitchen)
        
        /*
        let session = NMSSHSession(host: "11.111.11.11", andUsername: "inc")
        session?.connect()
        if session?.isConnected == true{
            session?.authenticate(byPassword: "1234")
            if session?.isAuthorized == true {
                print("works")
            }
        }
         */
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("floorplan view will appear")
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        bed1Cam = defaults.integer(forKey: "bed1cam")
    }
    
    func setButton(but: UIButton) {
        but.layer.cornerRadius = 0.5 * but.bounds.size.width
    }
    
    @IBAction func touchBed1(_ sender: UIButton) {
        if bed1Cam == 1 {
            print("bed1cam values is 1~~~~~~~~~~~~~~~~~")
            counter = 10
            performSegue(withIdentifier: SegueIdentifier, sender: self)
        } else {
            print("bed1cam value is not 1 !!!!!!!!!!!!!!")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = (touches.first)!.location(in: self.view) as CGPoint
        print ("the location is \(touchPoint)")
        if (touchPoint.x < 168 && touchPoint.x > 22 && touchPoint.y < 524 && touchPoint.y > 320 && bed1Cam == 1) {
            counter = 10
            performSegue(withIdentifier: SegueIdentifier, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier
        {
            if let destinationVC = segue.destination as? MonitorDetailViewController {
                destinationVC.numberToDisplay = counter
            }
        }
    }
    
}

