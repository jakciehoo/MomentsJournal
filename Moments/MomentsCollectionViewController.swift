//
//  MomentsCollectionViewController.swift
//  Moments
//
//  Created by HooJackie on 4/6/15.
//  Copyright (c) 2015 jackie. All rights reserved.
//

import UIKit
import Social
import Foundation



class MomentsCollectionViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var savedMoments:NSArray = NSArray()
    var moment:Moment!
    var zoomFrame:CGRect!
    var zoomImage:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        if  let defaultMoment = defaults.objectForKey("moments") as? NSArray{
        self.savedMoments = defaultMoment
        }

        
        //if we arrived at this view controller form the submitMoment segue, add the new moment to saved moments
        if(self.moment != nil){
            println("Adding submitted moment to user defaults")
            self.navigationItem.hidesBackButton = true
            self.navigationItem.title = "Moments"
            self.addMomentToDefaults();
            addButtomBar()

        }

        
        //refresh control
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.tag = 303
        refreshcontrol.tintColor = UIColor.grayColor()
        refreshcontrol.addTarget(self, action: "refreshCollection", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(refreshcontrol)
        self.collectionView?.alwaysBounceVertical = true
        
    }
    func loadingSavedMoments(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let dataMoments = defaults.objectForKey("moments") as? NSData {
            self.savedMoments = NSKeyedUnarchiver.unarchiveObjectWithData(dataMoments) as [Moment]
        }
    }
    //MARK: - NSUserDefaults
    //add new submitted moment to user defaults and update savedMoments
    func addMomentToDefaults(){
        if(self.moment != nil){
            self.presentComeBackTomorrow()
            var tempMoments = NSMutableArray()
            let defaults = NSUserDefaults.standardUserDefaults()
            let momentData = NSKeyedArchiver.archivedDataWithRootObject(self.moment)
            //let mutableArray = NSMutableArray()
            if  let defaultMoment = defaults.objectForKey("moments") as? NSArray{
                //self.savedMoments = defaultMoment
                tempMoments = defaultMoment.mutableCopy() as NSMutableArray
            }
            //let defaultsArray = defaults.objectForKey("moments") as NSArray
            tempMoments.insertObject(momentData, atIndex: 0)
            self.savedMoments =  tempMoments as NSArray
            defaults.setObject(self.savedMoments, forKey: "moments")
            defaults.synchronize()
            self.collectionView?.reloadData()
            self.moment = nil
            println("Finished adding new moment to defaults")
        }
    }
    //refresh the data
    func refreshCollection(){
        
        println("Pull to refresh")
        let defaults = NSUserDefaults.standardUserDefaults();
        if  let defaultMoment = defaults.objectForKey("moments") as? NSArray{
            self.savedMoments = defaultMoment
        }
        let refreshControl = view.viewWithTag(303) as UIRefreshControl
        refreshControl.endRefreshing()
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Present Come Back Tomorrow view after user finished submitting daily moment
    func presentComeBackTomorrow(){
        println("presenting Come Back Tomorrow View")
        let comeBackView = UIView(frame: CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 100, 200, 150))
        comeBackView.backgroundColor = UIColor(red: 0.627, green: 0.569, blue: 0.929, alpha: 1)
        comeBackView.alpha = 0
        comeBackView.layer.cornerRadius = 10
        
        let mainLable = UILabel(frame: CGRectMake(0, 40, comeBackView.frame.size.width, 30))
        mainLable.font = UIFont(name: "Avenir-Heavy", size: 25.0)
        mainLable.textColor = UIColor.whiteColor()
        mainLable.textAlignment = .Center
        mainLable.text = "Greate Job!!"
        
        let subLable = UILabel(frame: CGRectMake(10, 70, comeBackView.frame.size.width - 15, 60))
        subLable.numberOfLines = 2
        subLable.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        subLable.textColor = UIColor.whiteColor()
        subLable.textAlignment = .Center
        subLable.text = "Come back tomorrow to record another moment!"
        
        comeBackView.addSubview(mainLable)
        comeBackView.addSubview(subLable)
        self.view.addSubview(comeBackView)
        
        //fade in the view
        UIView.animateWithDuration(2.0, animations: {
            comeBackView.alpha = 0.9
            }, completion: {
                finished in
                UIView.animateWithDuration(1.0, animations: {
                    sleep(1)
                    comeBackView.alpha = 0
                    }, completion:{
                        finished in
                        comeBackView.removeFromSuperview()
                    }
                )
        })

    }


  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    //MARK: - UICollectionViewDelegateFlowlayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        var edgeInsets:UIEdgeInsets!
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            println("Current device is an ipad")
            edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
            
        }else{
            println("Current device is an iphone")
            let screenBounds = UIScreen.mainScreen().bounds
            if(screenBounds.size.height <= 568){
                println("This is an iphone4/5/5s")
                edgeInsets = UIEdgeInsetsMake(30, 15, 30, 15)
            }else if(screenBounds.size.height <= 736){
                println("This is an iphone6/6 plus")

                edgeInsets = UIEdgeInsetsMake(50, 30, 50, 30)
                
            }else{
                edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
            }
        }
        
        return edgeInsets
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        println("Set the cell size (140,140) ")
        return CGSizeMake(140, 140)
        
    }



    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.savedMoments.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("momentsCell", forIndexPath: indexPath) as MomentsCollectionViewCell
        println("Populating collection view cells")
        let currentMoment = self.savedMoments[indexPath.row] as NSData
        let currentMomentDecoded = NSKeyedUnarchiver.unarchiveObjectWithData(currentMoment) as Moment
        println("Decoded moment \(currentMomentDecoded.text)")
        cell.cellImageView.contentMode = .ScaleAspectFit
        cell.cellImageView.clipsToBounds = true
        cell.backgroundColor = UIColor.whiteColor()
        cell.cellImageView.image = currentMomentDecoded.image
        //cell.imageView.superview?.bringSubviewToFront(cell.imageView)
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        zoomToSelectedImage(indexPath)
    }
    func addButtomBar() {
        var items = [UIBarButtonItem]()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
  
        items.append(flexibleSpace)
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showHomeView"))
        items.append(flexibleSpace)
        
        
        self.setToolbarItems(items, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    func showHomeView(){
        let tabbar = storyboard?.instantiateViewControllerWithIdentifier("mainViewController") as UITabBarController
        tabbar.modalPresentationStyle = .OverCurrentContext
        tabbar.modalTransitionStyle = .CoverVertical
        presentViewController(tabbar, animated: true, completion: nil)

    }
    

    
    func zoomToSelectedImage(indexPath:NSIndexPath){
        println("Zooming to cell image")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        self.savedMoments = defaults.objectForKey("moments") as NSArray
        let selectedMomentData = self.savedMoments.objectAtIndex(indexPath.row) as NSData
        let selectedMoment = NSKeyedUnarchiver.unarchiveObjectWithData(selectedMomentData) as Moment
        //let selectedMoment = savedMoments[indexPath.row]
        let zoomImageView = UIImageView(image: selectedMoment.image)
        zoomImageView.tag = 302
        zoomImageView.contentMode = .ScaleAspectFit
        self.zoomImage = zoomImageView.image
        
        //Define the end frame fo the zoom
        let zoomFrameTo = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        let cv = self.view.viewWithTag(301) as UICollectionView
        cv.hidden = true
        
        let cellToZoom = cv.cellForItemAtIndexPath(indexPath)!
        let zoomFrameFrom = cellToZoom.frame
        self.view.addSubview(zoomImageView)
        zoomImageView.frame = zoomFrameFrom
        zoomImageView.alpha = 0.2
        
        //Create backButton to return to grid view
        let backButton = UIButton(frame: CGRectMake(10, 20, 60, 25))
        backButton.tag = 304
        backButton.setTitle("Back", forState: .Normal)
        backButton.layer.cornerRadius = 10
        backButton.clipsToBounds = true
        backButton.contentVerticalAlignment = .Bottom
        backButton.contentHorizontalAlignment = .Center
        backButton.layer.borderWidth = 1.0
        backButton.layer.borderColor = UIColor.whiteColor().CGColor
        backButton.titleLabel?.font = UIFont(name: "Avenir", size: 17.0)
        backButton.backgroundColor = UIColor(red: 0.627, green: 0.569, blue: 0.929, alpha: 1)
        backButton.titleLabel?.textColor = UIColor.whiteColor()
        backButton.addTarget(self, action: "dismissCell:", forControlEvents: .TouchUpInside)
        backButton.alpha = 0
        self.view.addSubview(backButton)
        
        //Create share button to allow user to post selected image to Facebook or weibo,twitter
        let shareButton = UIButton(frame: CGRectMake(self.view.frame.size.width-70, 20, 60, 25))
        shareButton.tag = 305
        shareButton.setTitle("Share", forState: .Normal)
        shareButton.layer.cornerRadius = 10
        shareButton.clipsToBounds = true
        shareButton.contentVerticalAlignment = .Bottom
        shareButton.contentHorizontalAlignment = .Center
        shareButton.layer.borderWidth = 1.0
        shareButton.layer.borderColor = UIColor.whiteColor().CGColor
        shareButton.titleLabel?.font = UIFont(name: "Avenir", size: 17.0)
        shareButton.backgroundColor = UIColor(red: 0.627, green: 0.569, blue: 0.929, alpha: 1)
        shareButton.titleLabel?.textColor = UIColor.whiteColor()
        shareButton.addTarget(self, action: "configureSocial:", forControlEvents: .TouchUpInside)
        shareButton.alpha = 0
        self.view.addSubview(shareButton)
        
        UIView.animateWithDuration(0.3, animations: {
            zoomImageView.frame = zoomFrameTo
            zoomImageView.alpha = 1
            backButton.alpha = 1
            shareButton.alpha = 1
        })
        
        self.zoomFrame = zoomFrameFrom
    }
    func dismissCell(sender:UIButton){
        println("Button pressed target action: dismiss selected cell")
        self.zoomFromSelectedImage(self.zoomFrame)
        
    }
    func zoomFromSelectedImage(zoomFrame:CGRect){
        let zoomImage = self.view.viewWithTag(302)
        UIView.animateWithDuration(0.2, animations: {
            zoomImage?.frame = zoomFrame
            zoomImage?.alpha = 1
            
            }, completion: {
                finished in
                zoomImage?.removeFromSuperview()
                let cv = self.view.viewWithTag(301) as UICollectionView
                cv.hidden = false
                let backButton = self.view.viewWithTag(304)
                backButton?.removeFromSuperview()
                let shareButton = self.view.viewWithTag(305)
                shareButton?.removeFromSuperview()
                self.zoomImage = nil
        })
    }
    func configureSocial(sender:UIButton){
        let socialController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        
        socialController.setInitialText("Check out my daily moment!")
        socialController.addImage(self.zoomImage)
        self.presentViewController(socialController, animated: true, completion: nil)
        
        
    }
}

