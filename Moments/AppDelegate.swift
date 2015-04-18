//
//  AppDelegate.swift
//  Moments
//
//  Created by HooJackie on 4/5/15.
//  Copyright (c) 2015 jackie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if WXApi.registerApp("wx98ca11ad382ab0dc"){
            println("注册成功")
        }

       let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("Jackie Hoo", forKey: "Developer")
        defaults.setValue("1.0", forKey: "Version")
        defaults.setValue(NSDate(), forKey: "Initial Launch")
        if let launchNumber = defaults.objectForKey("LaunchNumber") as? Int {
            defaults.setValue(launchNumber + 1, forKey: "LaunchNumber")
            println(launchNumber)
        }else{
            defaults.setValue(1, forKey: "LaunchNumber")
            
        }
        defaults.synchronize()

        let launchNumberNow = defaults.objectForKey("LaunchNumber") as Int
        if launchNumberNow == 5 {
            let alert = UIAlertView(title: "Like us?", message: "Please Rate us in the app store!", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }
        if let lastIntro: AnyObject = defaults.objectForKey(AppDefaultKeys.IntroVersionSeen.rawValue) {
            setupAppViewController(false)
        } else {
            self.window!.rootViewController = createIntroViewController()
            self.window!.makeKeyAndVisible()
        }
        
//        let tbc = self.window!.rootViewController as UITabBarController
//        let Mcvc = tbc.viewControllers![1] as MomentsCollectionViewController
//        if  let defaultMoment = defaults.objectForKey("moments") as? NSArray{
//            Mcvc.tabBarItem.badgeValue = "\(defaultMoment.count)"
//        }
        
        setUserSettingsDefaults()
        
        return true
    }
    func setUserSettingsDefaults() {
        if NSUserDefaults.standardUserDefaults().objectForKey(AppDefaultKeys.ShakeGesture.rawValue) == nil {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: AppDefaultKeys.ShakeGesture.rawValue)
        }
        if NSUserDefaults.standardUserDefaults().objectForKey(AppDefaultKeys.PanFromBottomGesture.rawValue) == nil {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: AppDefaultKeys.PanFromBottomGesture.rawValue)
        }
        if NSUserDefaults.standardUserDefaults().objectForKey(AppDefaultKeys.TripleTapGesture.rawValue) == nil {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: AppDefaultKeys.TripleTapGesture.rawValue)
        }
        if NSUserDefaults.standardUserDefaults().objectForKey(AppDefaultKeys.ForwardBackGesture.rawValue) == nil {
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: AppDefaultKeys.ForwardBackGesture.rawValue)
        }
    }
    func createIntroViewController() -> OnboardingViewController {
        let page01: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: NSLocalizedString("Moments is an APP ,let you remember every day's grateful moments", comment: "开发iMoments（爱满）这个app，可以帮助大家记录每天美好的事情"), image: nil, buttonText: nil) {
        }
        
        page01.iconWidth = 158
        page01.iconHeight = 258.5
        
        let page02: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: NSLocalizedString("Wherever happy moments happened,take a note of it", comment: "回忆一天当中美好的事情，然后记下来"), image: nil, buttonText: nil) {
        }
        
        page02.iconWidth = 158
        page02.iconHeight = 258.5
        
        let page03: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: NSLocalizedString("Add a beautiful photo you take for the moment,and the app will combine the photo and your note together!", comment: "然后添加一张你拍摄的照片，app会把你的记录添加到图片上"), image: nil, buttonText: nil) {
            self.introCompletion()
        }
        
        page03.iconWidth = 158
        page03.iconHeight = 258.5
        
        let page04: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: NSLocalizedString("you can review your beautiful moments wherever,whenever you are", comment: "随时随地查看你的美好时光，让美好永远存在"), image: nil, buttonText: NSLocalizedString("LET'S GO!", comment: "点击这里开始体验吧!")) {
            self.introCompletion()
        }
        
        page04.iconWidth = 158
        page04.iconHeight = 258.5
        
        let bgImage = UIImage.withColor(UIColorFromHex(0x9178E2))
        let onboardingViewController = PortraitOnboardingViewController(
            backgroundImage: bgImage,
            contents: [page01, page02, page03, page04])
        onboardingViewController.fontName = "ClearSans"
        onboardingViewController.bodyFontSize = 16
        onboardingViewController.titleFontName = "ClearSans-Bold"
        onboardingViewController.titleFontSize = 22
        onboardingViewController.buttonFontName = "ClearSans-Bold"
        onboardingViewController.buttonFontSize = 20
        onboardingViewController.topPadding = 60+(self.window!.frame.height/12)
        onboardingViewController.underTitlePadding = 8
        
        onboardingViewController.shouldMaskBackground = false
        
        return onboardingViewController
    }
    func introCompletion() {
        NSUserDefaults.standardUserDefaults().setValue(1, forKey: AppDefaultKeys.IntroVersionSeen.rawValue)
        setupAppViewController(true)
    }
    func setupAppViewController(animated : Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appViewController = storyboard.instantiateViewControllerWithIdentifier("mainViewController") as UITabBarController
        //appViewController.tabBar.backgroundColor = UIColor.blackColor()
        if  let defaultMoment = NSUserDefaults.standardUserDefaults().objectForKey("moments") as? NSArray{
                    let mcvc = appViewController.viewControllers![1] as MomentsCollectionViewController
                    mcvc.tabBarItem.badgeValue = "\(defaultMoment.count)"
                }
                if animated {
            UIView.transitionWithView(self.window!, duration: 0.5, options:UIViewAnimationOptions.TransitionFlipFromBottom, animations: { () -> Void in
                self.window!.rootViewController = appViewController
                }, completion:nil)
        }
        else {
            self.window?.rootViewController = appViewController
        }
        self.window!.makeKeyAndVisible()
    }
    
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func onReq(req: BaseReq!) {
        
    }
    
    func onResp(resp: BaseResp!) {
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    



}

