//
//  ViewController.swift
//  Slidebar
//
//  Created by Archita Bansal on 27/11/15.
//  Copyright © 2015 Archita Bansal. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SideBarDelegate {
    
    var sidebarShouldOpen : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftNavbarButton()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipe:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        
        
    }
    
   
    func addLeftNavbarButton(){
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "sidebarIcon.png"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: Selector("onSlideMenuButtonPressed:"), forControlEvents: .TouchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    
    func handleSwipe(sender:UISwipeGestureRecognizer){
        
        if(sender.direction == .Left){
            
            if self.sidebarShouldOpen == false{
                self.closeSlidebar()
            }
            
        }else{
            if(self.sidebarShouldOpen == true){
                 self.openSlidebar()
            }
        }
    }
    
    
    func sidebarDidSelectRow(indexPath: Int) {
       print("selected item is : \(indexPath)")
    }
    
    func closeSlidebar(){
        
        self.sidebarDidSelectRow(-1)
        
        let viewMenuBack : UIView = view.subviews.last!
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
            viewMenuBack.frame = frameMenu
            viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clearColor()
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                self.sidebarShouldOpen = true
        })
    }
    
    func openSlidebar(){
        let menuVC : SideViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SlidebarMenuViewController") as! SideViewController
        menuVC.delegate = self
        menuVC.view.backgroundColor = UIColor.clearColor()
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = menuVC.view.bounds
        menuVC.view.addSubview(blurView)
        
        
        
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRectMake(0 - UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            menuVC.view.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - (UIScreen.mainScreen().bounds.size.width/2), UIScreen.mainScreen().bounds.size.height);
            blurView.frame = menuVC.view.bounds
           // sender.enabled = true
            self.sidebarShouldOpen = false
            }, completion:nil)
    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if (self.sidebarShouldOpen == false)
        {
            // To Hide Menu If it already there
            self.closeSlidebar()
            return
        }
        else if(self.sidebarShouldOpen == true){
            //sender.enabled = false
            self.openSlidebar()
        }
       
       
    }
    

   
}

