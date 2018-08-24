//
//  CustomTabBarController.swift
//  CommonModules
//
//  Created by Kitasenri on 2018/01/01.
//  Copyright © 2018年 Kitasenri. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    //------------------------------------------------
    // Consts
    //------------------------------------------------

    static let HOME_BUTTON_PRESSED = "HomeButtonPressed";
    
    enum TABINDEX: Int {
        
        case HOME = 1;
        case MYPAGE = 3;
        
        // カスタムスキームで特定のページに飛びたい場合
        var schemeValue: String! {
            switch self {
            case TABINDEX.HOME:
                return "home";
            case TABINDEX.MYPAGE:
                return "mypage";
            }
        }
        
        // タブバーのタブ名
        var titleValue: String? {
            switch self {
            case TABINDEX.HOME:
                return nil;
            case TABINDEX.MYPAGE:
                return nil;
            }
        }
        
        var storyBoardValue: String! {
            switch self {
            case TABINDEX.HOME:
                return "HomeView";
            case TABINDEX.MYPAGE:
                return "MyPageView";
            }
        }
        
    };

    //------------------------------------------------
    // Properties
    //------------------------------------------------
    var lastSelectedIndex: Int = -1;

    var logoImageView: UIImageView!;
    
    //------------------------------------------------
    // Lifecycle Method
    //------------------------------------------------
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad();
        self.createTabBarItems();
        self.createSplashAnimation();
    }
    
    /**
     * View did appear
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        self.startSplashAnimation();
    }

    //------------------------------------------------
    // Method
    //------------------------------------------------

    /**
     * Show walk through
     */
    func showWalkThroughView() {
        
        let walkThroughStoryBoard = UIStoryboard(
            name: "WalkThroughView",
            bundle: nil
        )
        
        let walkThroughViewController =
            walkThroughStoryBoard.instantiateInitialViewController() as! WalkThroughViewController;
        self.present( walkThroughViewController, animated: false, completion: nil );
    }

    /**
     * Create splash animation
     */
    private func createSplashAnimation() {
        self.logoImageView = UIImageView( image: UIImage(named: "Logo") );
        self.logoImageView.center = self.view.center;
        self.view.addSubview(self.logoImageView);
    }

    /**
     * Start splash animation
     */
    private func startSplashAnimation() {

        UIView.animate(
            withDuration: 0.3,
            delay: 1.0,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: { () in
                self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
            }, completion: { (Bool) in
    
            }
        )
    
        UIView.animate(
            withDuration: 0.2,
            delay: 1.3,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: { () in
                self.logoImageView.alpha = 0;
                self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
            }, completion: { (Bool) in
    
                self.logoImageView.removeFromSuperview();
    
                // Initial Process
                let userDefaults = UserDefaults.standard;
                if ( !userDefaults.bool(forKey: "alreadLaunched") ) {
                    self.showWalkThroughView();
                    userDefaults.set( true, forKey: "alreadLaunched" );
                }
    
            }
        );

    }

    /**
     * Create tabBarItems
     */
    func createTabBarItems() {
        
        // (1) home
        let homeInfo = TABINDEX.HOME;
        let homeStoryboard = UIStoryboard(name: homeInfo.storyBoardValue, bundle: nil);
        let homeViewController = homeStoryboard.instantiateInitialViewController() as! UINavigationController;
        homeViewController.tabBarItem = UITabBarItem(
            title: homeInfo.titleValue,
            image: UIImage(named: "Home"),
            tag: homeInfo.rawValue
        );
        homeViewController.tabBarItem.title = homeInfo.titleValue;
        homeViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0);
        
        // (5) my page
        let myPageInfo = TABINDEX.MYPAGE;
        let myPageStoryboard = UIStoryboard(name: myPageInfo.storyBoardValue, bundle: nil)
        let myPageViewController = myPageStoryboard.instantiateInitialViewController() as! UINavigationController;
        myPageViewController.tabBarItem = UITabBarItem(
            title: myPageInfo.titleValue,
            image: UIImage(named: "profile"),
            tag: myPageInfo.rawValue
        );
        myPageViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0);

        // set tab
        var viewControllers: [UIViewController] = [];
        viewControllers.append(homeViewController);
        viewControllers.append(myPageViewController);
        
        // create tab
        self.delegate = self;
        self.setViewControllers(viewControllers, animated: false);
    }

}

/**
 * UITabBarControllerDelegate
 */
extension CustomTabBarController: UITabBarControllerDelegate {
    
    /**
     * Tab index changed handler
     */
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let newTabBarIndex = tabBarController.selectedIndex;
        let oldTabBarIndex = self.lastSelectedIndex;
        
        self.lastSelectedIndex = tabBarController.selectedIndex;
        if ( newTabBarIndex == oldTabBarIndex && newTabBarIndex == (TABINDEX.HOME.rawValue - 1) ) {
            
            let nc = NotificationCenter.default;
            nc.post(
                name: Notification.Name(rawValue: CustomTabBarController.HOME_BUTTON_PRESSED),
                object: nil
            );
            
        }
        
    }

    /**
     * Tab bar select
     */
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }

}
