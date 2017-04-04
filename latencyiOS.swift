class AdminViewController {

    override func viewDidLoad() {
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
    }

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
}
