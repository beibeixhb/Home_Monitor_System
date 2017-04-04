//
//  MonitorViewController.swift
//  monitor
//
//  Created by Xueting Yu on 11/4/16.
//  Copyright © 2016 XuetingYu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MonitorDetailViewController: UIViewController, UIImagePickerControllerDelegate {
    
    var numberToDisplay = 0
    
    @IBOutlet weak var videoView: UIWebView!

    @IBOutlet weak var getPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Monitor"
        setPhotoButton()
        
        let myUrl:URL = URL(string: "http://ec2-52-33-138-36.us-west-2.compute.amazonaws.com/~beibeixhb/cse520/stream-example.html")!
        
        let req = NSURLRequest.init(url: myUrl)
        videoView.loadRequest(req as URLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func getPhtotoClick(_ sender: UIButton) {
        
        let image: UIImage = getSnapshotImage(videoView)
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    
    func setPhotoButton() {
        getPhotoButton.layer.cornerRadius = 0.5 * getPhotoButton.bounds.size.width
        getPhotoButton.clipsToBounds = true
        getPhotoButton.layer.borderWidth = 6
        getPhotoButton.layer.borderColor = UIColor.white.cgColor
    }

    
    func getSnapshotImage(_ myView: UIView ) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(myView.bounds.size, myView.isOpaque, 0)
        myView.drawHierarchy(in: myView.bounds, afterScreenUpdates: false)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
}

