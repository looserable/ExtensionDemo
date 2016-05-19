//
//  ViewController.swift
//  SimpleTimer
//
//  Created by 王 巍 on 14-8-1.
//  Copyright (c) 2014年 OneV's Den. All rights reserved.
//

import UIKit
import SimpleTimerKit

let defaultTimeInterval: NSTimeInterval = 5

class ViewController: UIViewController {
                            
    @IBOutlet weak var lblTimer: UILabel!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showFinish(_:)), name: taskDidFinishedInWidgetNotification, object: nil)
        
    }
    
    func showFinish(noti:NSNotification){
        let ac = UIAlertController(title: nil , message:"Finished", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {[weak ac] action in ac!.dismissViewControllerAnimated(true, completion: nil)}))
        
        presentViewController(ac, animated: true, completion: nil)

    }
    
    @objc private func applicationWillResignActive() {
        if timer == nil {
        } else {
            if timer.running {
                saveDefaults()
            } else {
                clearDefaults()
            }
        }
    }
    
    private func saveDefaults() {
        
        let pasteBoard = UIPasteboard.init(name: "myPasteBoard", create: true)
        //这里指的是定时器剩余的时间
        let leftTime = Int(timer.leftTime)
        //这里指的是此时的时间点距离1970的时间间隔
        let intervalBy1970 = Int(NSDate().timeIntervalSince1970)
        
        pasteBoard?.string = "\(leftTime):\(intervalBy1970)"
    }
    
    private func clearDefaults() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateLabel() {
        lblTimer.text = timer.leftTimeString
    }
    
    func showFinishAlert(finished finished: Bool) {
        let ac = UIAlertController(title: nil , message: finished ? "Finished" : "Stopped", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {[weak ac] action in ac!.dismissViewControllerAnimated(true, completion: nil)}))
            
        presentViewController(ac, animated: true, completion: nil)
    }

    @IBAction func btnStartPressed(sender: AnyObject) {
        if timer == nil {
            let intervarStr = lblTimer.text
            timer = Timer(timeInteral:(intervarStr?.toInterVal())!)
        }
        
        let (started, error) = timer.start({
                leftTick in self.updateLabel()
            }, stopHandler:{
                finished in
                self.showFinishAlert(finished: finished)
                self.timer = nil
            })
        
        if started {
            updateLabel()
        } else {
            if let realError = error {
                print("error: \(realError.code)")
            }
        }
    }
        
    @IBAction func btnStopPressed(sender: AnyObject) {
        if let realTimer = timer {
            let (stopped, error) = realTimer.stop()
            if !stopped {
                if let realError = error {
                    print("error: \(realError.code)")
                }
            }
        }
    }

}

