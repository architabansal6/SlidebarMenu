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
    var animator : UIDynamicAnimator!
    var menuVC : SideViewController!
    var barWidth : CGFloat!

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
        
        
        
        barWidth = UIScreen.mainScreen().bounds.size.width - (UIScreen.mainScreen().bounds.size.width/2)
        
        
        menuVC = self.storyboard!.instantiateViewControllerWithIdentifier("SlidebarMenuViewController") as! SideViewController
        menuVC.delegate = self
        menuVC.view.backgroundColor = UIColor.clearColor()
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = menuVC.view.bounds
        menuVC.view.addSubview(blurView)
        
        
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        //menuVC.view.layoutIfNeeded()
        
        
        //        menuVC.view.frame=CGRectMake(0 - UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        
        
        menuVC.view.frame=CGRectMake(-barWidth, (self.navigationController?.navigationBar.frame.height)! + 20, barWidth, UIScreen.mainScreen().bounds.size.height);
        
         blurView.frame = menuVC.view.bounds
        

        
        
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
                self.openSlidebar(false)
            }
            
        }else{
            
            self.openSlidebar(true)
            if(self.sidebarShouldOpen == true){
                 self.openSlidebar(true)
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
           // viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clearColor()
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
              //  self.sidebarShouldOpen = true
        })
    }
    
    func openSlidebar(sidebarShouldOpen : Bool){
        
              // sender.enabled = true
        

        
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            menuVC.view.frame=CGRectMake(0, 0, barWidth, UIScreen.mainScreen().bounds.size.height);
//            blurView.frame = menuVC.view.bounds
//           // sender.enabled = true
//            self.sidebarShouldOpen = false
//            }, completion:nil)
//
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.animator.removeAllBehaviors()
        
        self.sidebarShouldOpen = (sidebarShouldOpen) ? false : true
        
        let gravityX : CGFloat = (sidebarShouldOpen) ? 1.0 : -1.0
        let boundaryX : CGFloat = (sidebarShouldOpen) ? barWidth : -barWidth
        let magnitude : CGFloat = (sidebarShouldOpen) ? 20 : -20
        
        let gravityBehaviour:UIGravityBehavior = UIGravityBehavior(items: [menuVC.view])
        gravityBehaviour.gravityDirection = CGVectorMake(gravityX, 0.0)
        self.animator.addBehavior(gravityBehaviour)
        
        let collisionBehaviour:UICollisionBehavior = UICollisionBehavior(items: [menuVC.view])
        collisionBehaviour.addBoundaryWithIdentifier("Sidebar Boundary", fromPoint: CGPointMake(boundaryX,20.0), toPoint: CGPointMake(boundaryX, self.view.frame.size.height))
        self.animator.addBehavior(collisionBehaviour)
        
        
        let pushBehaviour:UIPushBehavior = UIPushBehavior(items: [menuVC.view], mode: UIPushBehaviorMode.Instantaneous)
        pushBehaviour.magnitude = magnitude
        self.animator.addBehavior(pushBehaviour)
        
        
        let sidebarBehaviour:UIDynamicItemBehavior = UIDynamicItemBehavior(items: [menuVC.view])
        sidebarBehaviour.elasticity = 0.4
        self.animator.addBehavior(sidebarBehaviour)
        
       
      //  self.sidebarShouldOpen = false
        

    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if (self.sidebarShouldOpen == false)
        {
            // To Hide Menu If it already there
            self.openSlidebar(false)
            return
        }
        else if(self.sidebarShouldOpen == true){
           // sender.enabled = false
            self.openSlidebar(true)
        }
       
       
    }
    

   
}

