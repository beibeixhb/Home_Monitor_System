//
//  AdminViewController.swift
//  monitor
//
//  Created by Xueting Yu on 11/4/16.
//  Copyright © 2016 XuetingYu. All rights reserved.
//

import UIKit


class AdminViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    var defaults = UserDefaults.standard
    
    var bed1mode = 1
    
    var detectmode = 1
    
    var resolutionindex = 0
    
    let host = "172.27.85.59"
    
    let port = 2016
    
    var timeIntervals: [Double] = []
    
    let pickerData = ["300X900","600X800","1024X1024"]
    
    @IBOutlet weak var detectSwitch: UISwitch!
    
    @IBOutlet weak var bed1Switch: UISwitch!
    
    @IBOutlet weak var resolutionPicker: UIPickerView!
    
    var myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBed1Cam()
        checkDetect()
        checkResolution()
        resolutionPicker.dataSource = self
        resolutionPicker.delegate = self
        if bed1mode == 0 {
            bed1Switch.setOn(false, animated: true)
        }
        if detectmode == 0
        {
            detectSwitch.setOn(false, animated: true)
        }
        
        // Latency Test Execution Script
        
        /*
        
        var endTime = 0.0
        let curTime = Double(DispatchTime.now().uptimeNanoseconds)
        
        threadTask(taskNum: 750, requestNum: 1)
        
        myGroup.notify(qos: DispatchQoS.background, flags: DispatchWorkItemFlags.assignCurrentContext, queue: DispatchQueue.main) {
            // This closure will be executed when all tasks are complete
            print("Finished all requests.")
            let avgTimeInterval = self.getAvg(input: self.timeIntervals)
            print("The following is avgTimeInterval!!!!!!!")
            print(avgTimeInterval)
            endTime = Double(DispatchTime.now().uptimeNanoseconds)
            let wholeTime = Double((endTime - curTime)/1000000)
            print("This is QPS val: ", wholeTime)
        }
         
        */
    }
    

    
    // Latency Test Script Start Here
    
    func getAvg(input: [Double]) -> Double {
        var sum = 0.0
        for i  in input {
            sum += i
        }
        let dCount = input.count
        
        let result = sum / (1000000 * Double(dCount))
        return result
    }
    
    var request = NSMutableURLRequest(url: NSURL(string: "http://ec2-52-33-138-36.us-west-2.compute.amazonaws.com/~beibeixhb/cse520/stream-example.html")! as URL)
    
    func httpGet(request: NSURLRequest!, callback: @escaping (String, String?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest){
            (data, response, error) -> Void in
            if let error = error {
                callback("", error.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding:
                    String.Encoding.ascii.rawValue)!
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    
    func threadTask(taskNum: Int, requestNum: Int) {
        let queue = DispatchQueue(label: "latency", qos: DispatchQoS.userInitiated, attributes:.concurrent)
        for i in 0..<taskNum {
            self.myGroup.enter()
            queue.async{
                
                for j in 0..<requestNum {
                    let start = DispatchTime.now()
                    print("this is test for ", i, "start at ", start)
                    self.httpGet(request: self.request){
                        (data, error) -> Void in
                        if error != nil {
                            print("There is error from request~~~~~~~~~~~~~~~~")
                        } else {
                            print("Get all data from request~~~~~~~~~~~~~~~~~~~~")
                        }
                        let end = DispatchTime.now()
                        
                        DispatchQueue.main.async {
                            print("this is test for ", i, " at request num ", j, " end at ", end)
                            let timeInterval = Double(end.uptimeNanoseconds - start.uptimeNanoseconds)
                            print("this is time interval for test ", i, " and request num at ", j, " and value is ", timeInterval )
                            self.timeIntervals.append(timeInterval)
                            if j == requestNum-1 {
                                self.myGroup.leave()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    // Latency Test Script End Here
    
    /*
    
    func TCPGet( callback: @escaping (String, String?) -> Void) {
        guard let client = client else {
            print("client is nil")
            return
        }
        
        switch client.connect(timeout: 10) {
        case .success:
            if let response = sendRequest(string: "aaaaaaaaaaaaa Latency!!!", using: client) {
                callback(response as String, nil)
            }
        case .failure(let error):
                callback("", error.localizedDescription)
        }
    }

    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*10) else { return nil }
        
        return String(bytes: response, encoding: .utf8)
    }
    
    */
    
    func checkBed1Cam() {
        if (defaults.object(forKey: "bed1cam") == nil) {
            defaults.set(1, forKey: "bed1cam")
        }
        bed1mode = defaults.integer(forKey: "bed1cam")
    }
    
    func checkDetect() {
        if (defaults.object(forKey: "detection") == nil) {
            defaults.set(1, forKey: "detection")
        }
        detectmode = defaults.integer(forKey: "detection")
    }
    
    func checkResolution() {
        if (defaults.object(forKey: "resolution") == nil) {
            defaults.set(0, forKey: "resolution")
        }
        resolutionindex = defaults.integer(forKey: "resolution")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attributedData = NSAttributedString(string: pickerData[row], attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!,NSForegroundColorAttributeName:UIColor.white])
        
        return attributedData
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        resolutionindex = row
        defaults.set(pickerData[resolutionindex], forKey: "resolution")
    }
    
    @IBAction func detectSwitch(_ sender: UISwitch) {
        if sender.isOn {
            detectmode = 1
            defaults.set(detectmode, forKey: "detection")
            print("detect switch to 1!!!!!!!!!!!!!!!!!")
        } else {
            detectmode = 0
            defaults.set(detectmode, forKey: "detection")
            print("detect switch to 0~~~~~~~~~~~~~~~~~~~")
        }
    }
    
    @IBAction func bed1Switch(_ sender: UISwitch) {
        if sender.isOn {
            bed1mode = 1
            defaults.set(bed1mode, forKey: "bed1cam")
            print("switch to 1!!!!!!!!!!!!!!!!!")
        } else {
            bed1mode = 0
            defaults.set(bed1mode, forKey: "bed1cam")
            print("switch to 0~~~~~~~~~~~~~~~~~~~")
        }
    }
    
    func setWeather() {
        print("haha")
    }
    
    
    func updateResolution(resoValue: String) {
        /*
        
        let resolutionValueArray = resoValue.components(separatedBy: "X")
        
        let first = resolutionValueArray[0]
        let second = resolutionValueArray[1]
        
        //declare parameter as a dictionary which contains string as key and value combination.
        var parameters = ["updateValue": "resolution", "first": first, "second": second] as Dictionary<String, String>
        
        //create the url with NSURL
        let url = NSURL(string: "http://myServerName.com/api")
        
        //create the session object
        var session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        */
        
    }
    
    
}
