//
//  ViewController.swift
//  Moments
//
//  Created by HooJackie on 4/5/15.
//  Copyright (c) 2015 jackie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var dailyQuestion: UITextField!

    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var infoViewButton: UIButton!
    
    var placeholderArray:NSMutableArray!
    var moments:NSMutableArray!
    
    var moment:Moment!
    
    @IBOutlet weak var infoViewButtonBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoViewBottomSpaceConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: "showTabBar")
        tap.delegate = self
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
        let backView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 49))
        backView.backgroundColor = UIColorFromHex(0x9178E2)
        backView.alpha = 0.5
        self.tabBarController?.tabBar.insertSubview(backView, atIndex: 0)
        //self.tabBarController?.tabBar.translucent = true
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.hidden = false
        
    }
    func showTabBar(){
        let tabBar = self.tabBarController!.tabBar
        if tabBar.hidden {
            UIView.animateWithDuration(1, delay: 0, options: [], animations: {
                tabBar.hidden = false
                tabBar.frame = CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y-49, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
                
                }, completion: {
                    finished in

                    
            })
        }else {
            UIView.animateWithDuration(1, delay: 0, options: [], animations: {
                
                tabBar.frame = CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y + 49, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
                
                }, completion: {
                    finished in
                    tabBar.hidden = true
            })
        }

    }
    override func viewDidAppear(animated: Bool) {
        //sleep(2)
        //showTabBar()
    }

    
    override func viewWillAppear(animated: Bool) {
        self.placeholderArray = NSMutableArray()
        self.placeholderArray.addObject("What made you smile today?")
        self.placeholderArray.addObject("Little things count too!")
        self.placeholderArray.addObject("What made you happy today?")
        let index = Int(arc4random_uniform(UInt32(self.placeholderArray.count)))
        let placehloderText = self.placeholderArray.objectAtIndex(index) as! String
        self.dailyQuestion.placeholder = placehloderText
        self.dailyQuestion.delegate = self
        
        self.moments = NSMutableArray()
        
        self.submitButton.layer.cornerRadius = 10
        self.submitButton.titleLabel?.font = UIFont(name: "Avenir", size: 17.0)
        self.submitButton.backgroundColor = UIColor(red: 0.627, green: 0.569, blue: 0.929, alpha: 1)
        
        self.infoViewButton.layer.cornerRadius = 10
        self.infoView.layer.cornerRadius = 10
        
        let screenBounds = UIScreen.mainScreen().bounds
        if(screenBounds.size.height <= 480){
             NSLog("Running on iphone 4 or 4s")
            self.infoViewBottomSpaceConstraint.constant = 50.0
            self.infoViewButtonBottomSpaceConstraint.constant = 15.0
            
        }else if(screenBounds.size.height <= 568) {
            NSLog("Running on iphone 5 or 5s")
            self.infoViewBottomSpaceConstraint.constant = 100.0
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Navigation
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if(segue.identifier == "showMoments"){
        NSLog("Peform showMoments segue")
        let defaults = NSUserDefaults.standardUserDefaults()
        let mvc = segue.destinationViewController as! MomentsCollectionViewController
        mvc.savedMoments = defaults.objectForKey("moments") as! [Moment]
        
    }else if(segue.identifier == "showFilters"){
        NSLog("Performing showFilters segue")
        let navigationController = segue.destinationViewController as! UINavigationController
        let fvc = navigationController.topViewController  as! FilterImageViewController
        fvc.moment = self.moment
    }
        
    }
    
    //MARK - Saving Moments
    func resetNSUserDefaults() {
        let defaultsDictionary = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        
       // defaultsDictionary.
//        let keys = defaultsDictionary.keys as [String]
//        for(key:NSString in (defaultsDictionary.keys as [NSString])){
//            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
//
//        }
        for (key,value) in defaultsDictionary {
            print(key)
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key as String)
            
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK - Target Action
    
    @IBAction func presentInfo(sender:UIButton){
        print("Button pressed target action: present info")
        if(self.infoView.hidden){
            self.infoView.alpha = 0
            self.infoView.hidden = false
            UIView.animateWithDuration(0.5, animations: {
                self.infoView.alpha = 1.0
            },completion:nil)
        }
    }
    //Upon info view button click, dismiss the info view.
    @IBAction func dismissInfo(sender:UIButton){
        
        print("Button pressed target action: dismiss info")
        UIView .animateWithDuration(0.5, animations: {
            self.infoView.alpha = 0
            
            },completion:{
                finised in
                self.infoView.hidden = true
        })
        
    }
    @IBAction func loadImagePicker(sender:UIButton){
        print("Button pressed target action:load image picker")
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .CurrentContext
        picker.delegate = self
        picker.allowsEditing = true
        if(UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum)){
            picker.sourceType = .SavedPhotosAlbum
            print("show image picker:photo gallery available")
            
        }
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    //Once user has chosen an image, crop the image to a square if they have not done so already.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Did finish picking image")
        
        let chosenImage = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage) as! UIImage
        if(chosenImage.size.height != chosenImage.size.width){
            let imageSize = chosenImage.size
            let width = imageSize.width
            let height = imageSize.height
            if(width != height){
                let newDimension = min(width, height)
                let widthOffset = (width - newDimension)/2
                let heightOffset = (height - newDimension)/2
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), false, 0.0)
                chosenImage.drawAtPoint(CGPointMake(-widthOffset, -heightOffset))
                UIGraphicsEndImageContext()
            }
        }
        picker.dismissViewControllerAnimated(true, completion: {
            let todayMoment:Moment = Moment()
            todayMoment.text = self.dailyQuestion.text!
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "yyyy-mm-dd"
            dateformatter.dateStyle = .ShortStyle
            let todayDate = dateformatter.stringFromDate(NSDate())
            todayMoment.date = todayDate
            todayMoment.image = chosenImage
            self.moment = todayMoment
            print(self.moment.text)
            self.performSegueWithIdentifier("showFilters", sender: self)
        })
        print("Dismissed image picker")
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK - UITextField Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dailyQuestion.resignFirstResponder()

    }


}

