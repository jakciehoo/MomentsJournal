//
//  FilterImageViewController.swift
//  Moments
//
//  Created by HooJackie on 4/5/15.
//  Copyright (c) 2015 jackie. All rights reserved.
//

import UIKit

class FilterImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var filterScrollView: UIScrollView!
    var moment:Moment!
    var imageFullSize:UIImage!
    var imageThumbnail:UIImage!
    let filters = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectNoir", "CIPhotoEffectMono", "CIPhotoEffectProcess", "CIPhotoEffectTransfer", "CIVignetteEffect"]
    let filterLables = ["Chrome", "Fade", "Instant", "Noir", "Mono", "Process", "Transfer", "Vignette"]
    var prevChosenFilterIndex:Int = -1
    var doubleTapped:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    override func viewWillAppear(animated: Bool) {
        //Navigation bar should not cover top of view
        self.navigationController?.navigationBar.translucent = false
        //resize the image that was passed from the segue to the bounds of the imageView
        self.imageFullSize = self.imageWithImage(self.moment.image, newSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height))
        //
        self.imageThumbnail = self.imageWithImage(self.imageFullSize, newSize: CGSizeMake(100, 100))
        
        self.filterScrollView.contentSize = CGSizeMake(832, 120)
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.backgroundColor = UIColor.whiteColor()
        
        self.imageView.image = self.imageFullSize
        
        for i in 0..<self.filters.count{
            print("Creating thumnail for \(self.filters[i]) filter")
            //create raw CIImage
            let rawThumbnailData = CIImage(image: self.imageThumbnail)
            let filter = CIFilter(name: self.filters[i])
            filter!.setDefaults()
            //set raw CIImage as input image
            filter!.setValue(rawThumbnailData, forKey: "inputImage")
            let filterThumbnailData = filter!.valueForKey("outputImage") as! CIImage
            let filterThumbnail = UIImage(CIImage: filterThumbnailData)
            let filterButton = UIButton(frame: CGRect(x: 100*i + 4*i, y: 0, width: 100, height: 100))
            filterButton.tag = i+100
            filterButton.backgroundColor = UIColor.whiteColor()
            filterButton.addTarget(self, action: "chooseFilter:", forControlEvents: UIControlEvents.TouchUpInside)
            filterButton.setBackgroundImage(filterThumbnail, forState: .Normal)
            self.filterScrollView.addSubview(filterButton)
            
            let filterLabel = UILabel(frame: CGRect(x: 100*i + 4*i,y: 102,width: 100,height: 13))
            filterLabel.text = self.filterLables[i]
            filterLabel.font.fontWithSize(12)
            filterLabel.textAlignment = .Center
            filterLabel.backgroundColor = UIColor.clearColor()
            filterLabel.textColor = UIColor.lightGrayColor()
            self.filterScrollView.addSubview(filterLabel)
            print("Adding UIButton add UILabel to scroll view")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Resize an image
    func imageWithImage(image:UIImage,newSize:CGSize) -> UIImage{
        print("Resizing the image")
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
        
    }
    @IBAction func chooseFilter(sender:UIButton){
        let chosenFilterIndex = sender.tag - 100
        print("chose \(filters[chosenFilterIndex])")
        //if a user double taps a filter preview, them remove the fitler
        if(self.prevChosenFilterIndex == chosenFilterIndex && !self.doubleTapped){
            self.doubleTapped = true
            //remove the border around chosen thumnail
            sender.layer.borderWidth = 0.0
            self.imageView.image = self.imageFullSize
            
        }else{
            //filter the image
            //remove border around previously chosen thumbnail
            if(prevChosenFilterIndex != -1){
            let prevSender = self.view.viewWithTag(self.prevChosenFilterIndex + 100) as? UIButton
            prevSender?.layer.borderWidth = 0.0
            }
            
            //draw borer around chosen thumbnail
            sender.layer.borderWidth = 3.0
            sender.layer.borderColor = UIColor.blueColor().CGColor
            
            let rawImageData = CIImage(image: self.imageFullSize)
            let filter = CIFilter(name: self.filters[chosenFilterIndex])
            filter!.setDefaults()
            filter!.setValue(rawImageData, forKey: "inputImage")
            let filterImgData = filter!.valueForKey("outputImage") as! CIImage
            let filterImg = UIImage(CIImage: filterImgData)
            self.imageView.image = filterImg
            
            //reset these variables
            self.prevChosenFilterIndex = chosenFilterIndex
            self.doubleTapped = false
        }
    }
    //MARK - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "addText"){
            print("Performing addText segue")
            //replace image with filtered image in Moment object
            self.moment.image = self.imageView.image!
            
            
            //pass updated Moment object with filtered image to Text Effects View Controller
            let TextViewController = segue.destinationViewController as! TextEffectsViewController
            TextViewController.moment = self.moment
        }
        
    }
    


}
