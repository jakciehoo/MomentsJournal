//
//  TextEffectsViewController.swift
//  Moments
//
//  Created by HooJackie on 4/6/15.
//  Copyright (c) 2015 jackie. All rights reserved.
//

import UIKit

class TextEffectsViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var momentTextLabel: UILabel!
    
    @IBOutlet weak var momentDateLabel: UILabel!
    
    @IBOutlet weak var fontScrollView: UIScrollView!
    @IBOutlet weak var colorScrollView: UIScrollView!
    
    var moment:Moment!
    let fonts = ["Avenir", "American Typewriter", "Avenir-HeavyOblique", "Noteworthy-Bold", "BradleyHandITCTT-Bold", "Didot-Italic","Arial-BoldMT","BradleyHandITCTT-Bold"]
    var colors = [UIColor.redColor(),UIColor.purpleColor(),UIColor.orangeColor(),UIColor.yellowColor(),UIColor.blackColor(),UIColor.darkGrayColor(),UIColor.cyanColor(),UIColor.blueColor(),UIColor.brownColor(),UIColor.greenColor(),UIColor.grayColor(),UIColor.lightGrayColor(),UIColor.magentaColor(),UIColor.whiteColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(self.moment != nil){
            self.imageVIew.image = self.moment.image
            
        }else{
            self.imageVIew.image = UIImage(named: "sample")
        }
        self.momentTextLabel.text = self.moment.text
        self.momentDateLabel.text = self.moment.date
        self.momentTextLabel.sizeToFit()
        self.imageVIew.backgroundColor = UIColor.whiteColor()
        
        //set Default font
        self.momentTextLabel.font = UIFont(name: self.fonts[0], size: 27.0)
        self.momentDateLabel.font = UIFont(name: self.fonts[0], size: 17.0)
        self.momentDateLabel.textColor = UIColor.whiteColor()
        self.momentDateLabel.backgroundColor = UIColor.blackColor()
        self.momentTextLabel.textColor = UIColor.whiteColor()
        
        self.fontScrollView.contentSize = CGSizeMake(250, 50)
        self.colorScrollView.contentSize = CGSizeMake(750, 50)
        self.fontScrollView.backgroundColor = UIColorFromHex(0x9178E2)
        initScrollView()
        self.addGestureRecognizersToPiece(self.momentTextLabel)

    }
    //Create fontscrollview and color with button
    func initScrollView(){
        for i in 0..<self.fonts.count{
            let fontButton = UIButton(frame: CGRect(x: 50*i + 4*i,y: 0, width: 50, height: 50))
            fontButton.tag = i + 100
            fontButton.setTitle("Aa", forState: .Normal)
            fontButton.layer.cornerRadius = 10
            fontButton.clipsToBounds = true
            fontButton.contentVerticalAlignment = .Bottom
            fontButton.contentHorizontalAlignment = .Center
            fontButton.layer.borderWidth = 1.0
            fontButton.layer.borderColor = UIColor.whiteColor().CGColor
            fontButton.titleLabel?.font = UIFont(name: self.fonts[i], size: 25.0)
            fontButton.addTarget(self, action: "chooseFont:", forControlEvents: .TouchUpInside)
            self.fontScrollView.addSubview(fontButton)
            println("Create and add \(fonts[i]) button success")
        }
        for i in 0..<self.colors.count{
            let colorButton = UIButton(frame: CGRect(x: 50*i + 4*i,y: 0, width: 50, height: 50))
            colorButton.tag = i + 200
            colorButton.layer.cornerRadius = 10
            colorButton.clipsToBounds = true
            //colorButton.layer.borderColor = UIColor.whiteColor().CGColor
            colorButton.backgroundColor = self.colors[i]
            colorButton.addTarget(self, action: "chooseColor:", forControlEvents: .TouchUpInside)
            self.colorScrollView.addSubview(colorButton)
            println("Create and add color button success")
        }
    }
    //MARK: - Button Target Actions
    func chooseFont(sender:UIButton){
        println("Button pressed target action: chose font")
        let chosenFontIndex = sender.tag - 100
        self.momentTextLabel.font = UIFont(name: self.fonts[chosenFontIndex], size: 27.0)
        self.momentTextLabel.sizeToFit()
    }
    func chooseColor(sender:UIButton){
        println("Button pressed target action chose color")
        let chosenColorIndex = sender.tag - 200
        self.momentTextLabel.textColor = self.colors[chosenColorIndex]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Screenshot
    func takeScreenshot(view:UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    // MARK: - Navigation

   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "submitMoment"){
            println("Performing submitMoment segue")
            let imagewithText = self.takeScreenshot(self.ContainerView)
            self.moment.image = imagewithText
            let mvc = segue.destinationViewController as MomentsCollectionViewController
            //mvc.moment = self.moment
            //let mvc = segue.destinationViewController as MomentsTableViewController
            mvc.moment = self.moment
        }
    }
    
    //MARK - Gesture Recognize Delegate
    //add rotation ,pan ,pinch gesture to moment text
    func addGestureRecognizersToPiece(piece:UIView){
        println("Adding rotation gesture recognizers to moment text")
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: "rotatePiece:")
        rotationGesture.delegate = self
        piece.superview!.addGestureRecognizer(rotationGesture)
        
        println("Adding pan gesture recognizers to moment text")
        let panGesture = UIPanGestureRecognizer(target: self, action: "panPiece:")
        panGesture.maximumNumberOfTouches = 2
        panGesture.delegate = self
        piece.addGestureRecognizer(panGesture)
        
        println("Adding pinch gesture recognizers to view")
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchPiece:")
        pinchGesture.delegate = self
        piece.superview!.addGestureRecognizer(pinchGesture)
        
    }
    
    //use UIPanGestureRecognizer to shift the piece view center by the pan amount,and reset recognizer's translation to CGPointZero after applying so the next t
    func panPiece(recognizer:UIPanGestureRecognizer){
        let piece = recognizer.view!
        piece.superview?.bringSubviewToFront(piece)
        self.adjustAnchorPointForGestureRecognizer(recognizer)
        if(recognizer.state == .Began || recognizer.state == .Changed){
            let translation = recognizer.translationInView(piece.superview!)
            if(CGRectContainsPoint(self.imageVIew.frame, CGPointMake(piece.center.x + translation.x, piece.center.y + translation.y))){
                piece.center = CGPointMake(piece.center.x + translation.x, piece.center.y + translation.y)
                recognizer.setTranslation(CGPointZero, inView: piece.superview!)
            }
//            if recognizer.state == UIGestureRecognizerState.Ended {
//                let velocity = recognizer.velocityInView(piece.superview!)
//                let magnitude = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
//                let slideMutliplier = magnitude / 200
//                println("magnitude: \(magnitude), slideMultiplier:\(slideMutliplier)")
//                
//                let slideFactor = 0.1 * slideMutliplier
//                var finalPoint = CGPoint(x: recognizer.view!.center.x + velocity.x * slideFactor, y: recognizer.view!.center.y + velocity.y * slideFactor)
//                finalPoint.x = min(max(finalPoint.x, 0),self.view.bounds.size.width)
//                finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
//                UIView.animateWithDuration(Double(slideFactor * 2), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {recognizer.view!.center = finalPoint}, completion: nil)
//            }

            
        }

    }
    //rotate the piece by the current rotation
    func rotatePiece(recognizer:UIRotationGestureRecognizer){
        self.adjustAnchorPointForGestureRecognizer(recognizer)
        if(recognizer.state == .Began || recognizer.state == .Changed){
            momentTextLabel.transform = CGAffineTransformRotate(momentTextLabel.transform, recognizer.rotation)
            recognizer.rotation = 0.0
 
        }
    }
    
    //scale the piece by the current scale
    func pinchPiece(recognizer:UIPinchGestureRecognizer){
        self.adjustAnchorPointForGestureRecognizer(recognizer)
        if(recognizer.state == .Began || recognizer.state == .Changed){
           momentTextLabel.transform = CGAffineTransformScale(momentTextLabel.transform, recognizer.scale, recognizer.scale)
            recognizer.scale = 1.0
            
        }
    }
    func adjustAnchorPointForGestureRecognizer(recognizer:UIGestureRecognizer){
        if(recognizer.state == UIGestureRecognizerState.Began){
            let piece = recognizer.view!
            let locationInView = recognizer.locationInView(piece)
            let locationInSuperView = recognizer.locationInView(piece.superview)
            piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height)
            piece.center = locationInSuperView
        }
        
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    


}
