//
//  TodayViewController.swift
//  SimpleTimerTodayExtenstion
//
//  Created by john on 16/5/18.
//  Copyright © 2016年 OneV's Den. All rights reserved.
//

import UIKit
import NotificationCenter
import SimpleTimerKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lblTImer: UILabel!
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let pasteBoard = UIPasteboard.init(name: "myPasteBoard", create: true)
        
        let dataArray:[String] = pasteBoard!.string!.componentsSeparatedByString(":")
        //退出时余下的时间
        let leftTimeWhenQuit = Int(dataArray[0])
        //退出时和1970年的时间的间隔
        let intervalBy1970 = Int(dataArray[1])
        
        //从退出到现在又过去的时间
        let passedTimeFromQuit = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: NSTimeInterval(intervalBy1970!)))
        
        let leftTime = leftTimeWhenQuit! - Int(passedTimeFromQuit)
        
        lblTImer.text = NSTimeInterval(leftTime).toString()
        
        if (leftTime > 0) {
           timer = Timer(timeInteral: NSTimeInterval(leftTime))
           timer!.start({
                leftTick in self.updateLabel()
            }, stopHandler:{
                finished in self.showOpenAppButton()
            })
        } else {
            showOpenAppButton()
        }
        
    }
    
    private func updateLabel() {
        lblTImer.text = timer!.leftTimeString
    }

    
    private func showOpenAppButton() {
        lblTImer.text = "Finished"
        preferredContentSize = CGSizeMake(0, 100)
        
        let button = UIButton(frame: CGRectMake(0, 50, 100, 20))
        button.setTitle("Open", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    @objc private func buttonPressed(sender: AnyObject!) {
        extensionContext!.openURL(NSURL(string: "simpleTimer://finished")!, completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
