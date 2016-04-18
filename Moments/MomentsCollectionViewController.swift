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
            print("Adding submitted moment to user defaults")
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
            self.savedMoments = NSKeyedUnarchiver.unarchiveObjectWithData(dataMoments) as! [Moment]
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
                tempMoments = defaultMoment.mutableCopy() as! NSMutableArray
            }
            //let defaultsArray = defaults.objectForKey("moments") as NSArray
            tempMoments.insertObject(momentData, atIndex: 0)
            self.savedMoments =  tempMoments as NSArray
            defaults.setObject(self.savedMoments, forKey: "moments")
            defaults.synchronize()
            self.collectionView?.reloadData()
            self.moment = nil
            print("Finished adding new moment to defaults")
        }
    }
    //refresh the data
    func refreshCollection(){
        
        print("Pull to refresh")
        let defaults = NSUserDefaults.standardUserDefaults();
        if  let defaultMoment = defaults.objectForKey("moments") as? NSArray{
            self.savedMoments = defaultMoment
        }
        let refreshControl = view.viewWithTag(303) as! UIRefreshControl
        refreshControl.endRefreshing()
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Present Come Back Tomorrow view after user finished submitting daily moment
    func presentComeBackTomorrow(){
        print("presenting Come Back Tomorrow View")
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
            print("Current device is an ipad")
            edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
            
        }else{
            print("Current device is an iphone")
            let screenBounds = UIScreen.mainScreen().bounds
            if(screenBounds.size.height <= 568){
                print("This is an iphone4/5/5s")
                edgeInsets = UIEdgeInsetsMake(30, 15, 30, 15)
            }else if(screenBounds.size.height <= 736){
                print("This is an iphone6/6 plus")

                edgeInsets = UIEdgeInsetsMake(50, 30, 50, 30)
                
            }else{
                edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50)
            }
        }
        
        return edgeInsets
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        print("Set the cell size (140,140) ")
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("momentsCell", forIndexPath: indexPath) as! MomentsCollectionViewCell
        print("Populating collection view cells")
        let currentMoment = self.savedMoments[indexPath.row] as! NSData
        let currentMomentDecoded = NSKeyedUnarchiver.unarchiveObjectWithData(currentMoment) as! Moment
        print("Decoded moment \(currentMomentDecoded.text)")
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
        let tabbar = storyboard?.instantiateViewControllerWithIdentifier("mainViewController") as! UITabBarController
        tabbar.modalPresentationStyle = .OverCurrentContext
        tabbar.modalTransitionStyle = .CoverVertical
        presentViewController(tabbar, animated: true, completion: nil)

    }
    

    
    func zoomToSelectedImage(indexPath:NSIndexPath){
        print("Zooming to cell image")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        self.savedMoments = defaults.objectForKey("moments") as! NSArray
        let selectedMomentData = self.savedMoments.objectAtIndex(indexPath.row) as! NSData
        let selectedMoment = NSKeyedUnarchiver.unarchiveObjectWithData(selectedMomentData) as! Moment
        //let selectedMoment = savedMoments[indexPath.row]
        let zoomImageView = UIImageView(image: selectedMoment.image)
        zoomImageView.tag = 302
        zoomImageView.contentMode = .ScaleAspectFit
        self.zoomImage = zoomImageView.image
        
        //Define the end frame fo the zoom
        let zoomFrameTo = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        let cv = self.view.viewWithTag(301) as! UICollectionView
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
        
//        //Create share button to allow user to post selected image to Facebook or weibo,twitter
//        let shareButton = UIButton(frame: CGRectMake(self.view.frame.size.width-120, 20, 60, 25))
//        shareButton.tag = 305
//        shareButton.setTitle("Share", forState: .Normal)
//        shareButton.layer.cornerRadius = 10
//        shareButton.clipsToBounds = true
//        shareButton.contentVerticalAlignment = .Bottom
//        shareButton.contentHorizontalAlignment = .Center
//        shareButton.layer.borderWidth = 1.0
//        shareButton.layer.borderColor = UIColor.whiteColor().CGColor
//        shareButton.titleLabel?.font = UIFont(name: "Avenir", size: 17.0)
//        shareButton.backgroundColor = UIColor(red: 0.627, green: 0.569, blue: 0.929, alpha: 1)
//        shareButton.titleLabel?.textColor = UIColor.whiteColor()
//        shareButton.addTarget(self, action: "sendImage", forControlEvents: .TouchUpInside)
//        shareButton.alpha = 0
//        self.view.addSubview(shareButton)
        
        //create a down menu Button
        var homeView = self.createHomeButtonView()
        
        var downMenuButton = DWBubbleMenuButton(frame: CGRectMake(self.view.frame.size.width-50,
            20,
            homeView.frame.size.width,
            homeView.frame.size.height), expansionDirection: ExpansionDirection.DirectionDown)
        downMenuButton.homeButtonView = homeView
        //downMenuButton.addButtons(self.createDemoButtonArray())
        downMenuButton.tag = 306
        let weixinButton = createButtonWithName("weixin")
        weixinButton.addTarget(self, action: Selector("weixinButtonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
        downMenuButton.addButton(weixinButton)
        let weiboButton = createButtonWithName("sinaminiblog")
        weiboButton.addTarget(self, action: Selector("weiboButtonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
        downMenuButton.addButton(weiboButton)
        let qzoneButton = createButtonWithName("qzone")
        qzoneButton.addTarget(self, action: Selector("qzoneButtonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
        downMenuButton.addButton(qzoneButton)
        let neteaseButton = createButtonWithName("neteasemb")
        neteaseButton.addTarget(self, action: Selector("neteasembButtonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
        downMenuButton.addButton(neteaseButton)
        let photoButton = createButtonWithName("photo")
        photoButton.addTarget(self, action: Selector("photoButtonTap:"), forControlEvents: UIControlEvents.TouchUpInside)
        downMenuButton.addButton(photoButton)
        let shareButton = createButtonWithName("shareMore")
        shareButton.addTarget(self, action: "shareButtonTap:", forControlEvents: .TouchUpInside)
        downMenuButton.addButton(shareButton)

        downMenuButton.alpha = 0
        self.view.addSubview(downMenuButton)
        
        
        UIView.animateWithDuration(0.3, animations: {
            zoomImageView.frame = zoomFrameTo
            zoomImageView.alpha = 1
            backButton.alpha = 1
            //shareButton.alpha = 1
            downMenuButton.alpha = 1
        })
        
        self.zoomFrame = zoomFrameFrom
    }
    
    
    func createHomeButtonView() -> UIImageView {
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        imageView.image = UIImage(named: "share")
        return imageView
    }
    
    func createButtonWithName(imageName:NSString) -> UIButton {
        var button = UIButton()
        
        button.setImage(UIImage(named: imageName as String), forState: UIControlState.Normal)
        button.sizeToFit()
        
        
        return button
        
    }
    
    func qzoneButtonTap(sender:UIButton){
        
        let alert = UIAlertView(title: "", message: "不好意思，这个功能后期版本再添加", delegate: self, cancelButtonTitle: "ok")
        alert.show()
    }
    func photoButtonTap(sender:UIButton){
        UIImageWriteToSavedPhotosAlbum(self.zoomImage, nil, nil, nil)
        let alert = UIAlertView(title: "", message: "Saved the wonderful photo sucessfully", delegate: self, cancelButtonTitle: "ok")
        alert.show()
    }
    
    func shareButtonTap(sender:UIButton){
        let imageData = UIImagePNGRepresentation(self.zoomImage)
        let publishContent = ShareSDK.content("输入分享内容", defaultContent: "测试", image: ShareSDK.imageWithData(imageData, fileName: "test", mimeType: "png"), title: "ShareSDK", url: "http://weibo.com/hooyoo", description: "这是一条测试程序", mediaType: SSPublishContentMediaTypeImage)
        let container = ShareSDK.container()
        container.setIPadContainerWithView(sender, arrowDirect: UIPopoverArrowDirection.Left)
        ShareSDK.showShareActionSheet(container, shareList: nil, content: publishContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result: {
            (type , state , statusInfo , error , end) in
//            if (state == .Success){
//                println("分享成功")
//                
//            }else if (state == SSResponseStateFail){
//                println("分享失败")
//            }
        })
        
        
        
    }
    func neteasembButtonTap(sender:UIButton){
        let alert = UIAlertView(title: "", message: "不好意思，这个功能后期版本再添加", delegate: self, cancelButtonTitle: "ok")
        alert.show()
    }
    
    func dismissCell(sender:UIButton){
        print("Button pressed target action: dismiss selected cell")
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
                let cv = self.view.viewWithTag(301) as! UICollectionView
                cv.hidden = false
                let backButton = self.view.viewWithTag(304)
                backButton?.removeFromSuperview()
                //let shareButton = self.view.viewWithTag(305)
                //shareButton?.removeFromSuperview()
                let downMenuButton = self.view.viewWithTag(306)
                downMenuButton?.removeFromSuperview()
                self.zoomImage = nil
        })
    }
    func weiboButtonTap(sender:UIButton){
        let socialController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        
        socialController.setInitialText("Share my daily wonderful moment!")
        socialController.addImage(self.zoomImage)
        self.presentViewController(socialController, animated: true, completion: nil)
  
    }
    func weixinButtonTap(sender:UIButton){
        sendImageContext(self.zoomImage)
    }
    //发送图片信息方法实现
    func sendImageContext(image :UIImage) {
        let messgage = WXMediaMessage()
        let wxImageObject = WXImageObject()
        let thumbSize = CGSize(width: 30, height: 30)
        let thumbImage = imageByScalingAndCroppingForSize(image,targetSize: thumbSize)
        let thumbData = UIImagePNGRepresentation(thumbImage)
        messgage.setThumbImage(thumbImage)
        
        wxImageObject.imageData = UIImagePNGRepresentation(image)
        
        print(thumbData!.length/1024)
        messgage.mediaObject = wxImageObject
        messgage.mediaTagName = "test"
        messgage.messageExt = "测试"
        messgage.messageAction = "<action>totallist<action>"
        let sendMessage = SendMessageToWXReq()
        sendMessage.bText = false
        sendMessage.message = messgage
        sendMessage.scene = 1
        WXApi.sendReq(sendMessage)
        
    }
    
    //发送信息给用户
    func sendText(){
        let req = SendMessageToWXReq()
        req.text = "test to send message to a friend"
        req.scene = 1
        req.bText = true
        WXApi.sendReq(req)
    }
    // 压缩图片大小
    func scaleImageToSize(image:UIImage,size:CGSize)->UIImage {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    //裁剪图片
    func imageByScalingAndCroppingForSize(image:UIImage,targetSize:CGSize)->UIImage{
        let imageSize = image.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor:CGFloat = 0.0
        var scaleWidth = targetWidth
        var scaleHeight = targetHeight
        var thumbnailPoint = CGPointMake(0.0, 0.0)
        if (CGSizeEqualToSize(imageSize, targetSize) == false){
            
            let widthFactor = targetWidth/width
            let heightFactor = targetHeight/height
            if(widthFactor > heightFactor){
                scaleFactor = widthFactor
            }else{
                scaleFactor = heightFactor
            }
            
            scaleWidth = width * scaleFactor
            scaleHeight = heightFactor * scaleFactor
            
            //center of the image
            if(widthFactor > heightFactor){
                thumbnailPoint.y = (targetHeight - scaleHeight) * 0.5
            }else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetHeight - scaleHeight) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        image.drawInRect(CGRectMake(thumbnailPoint.x, thumbnailPoint.y, targetSize.width, targetSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        if (newImage != nil){
            UIGraphicsEndImageContext()
        }
        return newImage
        
    }

    
}

