//
//  ViewController.swift
//  SoundCloudHLSStreamer
//
//  Created by Levi Bostian on 11/19/15.
//  Copyright © 2015 Levi Bostian. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var streamUrlTextField: UITextField!
    @IBOutlet weak var streamItButton: UIButton!
    @IBOutlet weak var jumpAheadButton: UIButton!
    
    var avPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func streamItButtonPressed(sender: UIButton) {
        self.streamUrlTextField.resignFirstResponder()
        
        let streamUrl = NSURL(string: streamUrlTextField.text!)!
        
        self.avPlayer = AVPlayer(URL: streamUrl)
        self.avPlayer?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        self.avPlayer?.rate = 1.0;
        self.avPlayer?.play()
        self.avPlayer?.volume = 1.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer?.currentItem)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        NSLog("reached end")
    }

    @IBAction func jumpAheadButtonPressed(sender: AnyObject) {
        // Goes to the 5 second mark in the song. 
        // great info about how this works https://stackoverflow.com/questions/22666190/using-seconds-in-avplayer-seektotime
        self.avPlayer?.currentItem?.seekToTime(CMTimeMakeWithSeconds(5, 60000))
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (object != nil && object as? AVPlayer == self.avPlayer! && keyPath != nil && keyPath! == "status") {
            if (self.avPlayer?.status == AVPlayerStatus.Failed) {
                NSLog("failed.")
            } else if (self.avPlayer?.status == AVPlayerStatus.ReadyToPlay) {
                NSLog("ready to play")
            } else if (self.avPlayer?.status == AVPlayerStatus.Unknown) {
                NSLog("unknown")
            }
        }
    }

}

