//
//  AbstractWebViewController.swift
//  CommonModules
//
//  Created by Kitasenri on 2018/01/01.
//  Copyright © 2018年 Kitasenri. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    //------------------------------------------------
    // Const
    //------------------------------------------------
    let TABBAR_HEIGHT: CGFloat = 44;
    let NAVBAR_HEIGHT: CGFloat = 64;

    //------------------------------------------------
    // Property
    //------------------------------------------------
    // WebView
    public var webView: WKWebView!;

    // init url
    public var initURL: String?;
    public var hasHeader: Bool = true;
    public var hasFooter: Bool = false;
    
    //------------------------------------------------
    // Lifecycle method
    //------------------------------------------------
    /**
     * deinit
     */
    deinit {

        if ( self.webView != nil ) {
            self.removePropertyListener();
            self.webView = nil;
        }

    }

    /**
     * load view
     */
    override func loadView() {
        super.loadView()
        self.createWebKit();
    }
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad();

        self.addPropertyListener();
        self.setURL( url: self.initURL! );
    }

    //------------------------------------------------
    // Process method
    //------------------------------------------------
    
    /**
     * Add property observer
     */
    internal func addPropertyListener() {
        self.webView.addObserver( self, forKeyPath: "loading", options: .new, context: nil);
    }

    /**
     * Remove property observer
     */
    internal func removePropertyListener() {
        self.webView.removeObserver(self, forKeyPath: "loading");
    }

    /**
     * Observe value for key path
     */
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        
        if ( keyPath == "loading" ) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.webView.isLoading;
        }
        
    }

    /**
     *　Set URL
     */
    public func setURL( url:String ) {
        let url = URL(string: url);
        let request = URLRequest(url: url!);
        self.webView.load(request);
    }
    
    /**
     * Create web view.
     */
    internal func createWebKit() {
        
        // webConfig & userController : For handling from javascript
        let userController:WKUserContentController = WKUserContentController();
        userController.add(
            self,
            name: "callbackHandler"
        );

        let webConfig:WKWebViewConfiguration = WKWebViewConfiguration()
        webConfig.userContentController = userController;
        
        // Create web view.
        let rr = CGRect( x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height);
        self.webView = WKWebView(
            frame: rr,
            configuration: webConfig
        );
        
        // set property
        self.webView.uiDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.allowsBackForwardNavigationGestures = true;
        self.webView.translatesAutoresizingMaskIntoConstraints = false;
        
        // set constraint
        let attributes: [NSLayoutAttribute] = [.top, .left, .right, .bottom];
        let constraints = attributes.map {
            (attribute) -> NSLayoutConstraint in
            
            var constant:CGFloat;
            if ( attribute == .top ) {

                // adjust nav bar
                if ( self.hasHeader ) {
                    constant = NAVBAR_HEIGHT + 1;
                } else {
                    constant = 0;
                }

            } else if ( attribute == .bottom ) {

                // adjust tab bar
                if ( self.hasFooter ) {
                    constant = -TABBAR_HEIGHT;
                } else {
                    constant = 0;
                }

            } else {
                // left & right
                constant = 0;
            }
            
            return NSLayoutConstraint(
                item: self.webView,
                attribute: attribute,
                relatedBy: .equal,
                toItem: self.view,
                attribute: attribute,
                multiplier: 1.0,
                constant: constant
            )
        };
        
        // set web view to view.
        self.view.addSubview(self.webView);
        self.view.addConstraints(constraints);
        
        // add refresh controll
        let refreshControl = UIRefreshControl();
        refreshControl.attributedTitle = NSAttributedString(string: "Loading");
        
        refreshControl.addTarget(
            self,
            action: #selector(self.refreshWebView(sender:)),
            for: .valueChanged
        )
        self.webView.scrollView.addSubview(refreshControl);
    }

    /**
     * Refresh WebView
     */
    @objc
    func refreshWebView(sender: UIRefreshControl) {
        self.webView.reload();
        sender.endRefreshing()
    }
    
    /**
     * For override.
     */
    func jsCallbackHandler( body: Any ) {
        
    }

}

/**
 * WebView Event
 * 
 */
extension WebViewController : WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    /**
     * Handling js callback
     */
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        
        if ( message.name == "callbackHandler" ) {
            let body = message.body;
            self.jsCallbackHandler( body: body );
        }
        
    }

    /**
     * web view delegater
     * for target = "_blank"
     */
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        
        // If link is target="_blank", safari will be open.
        if ( navigationAction.targetFrame == nil ) {
            UIApplication.shared.openURL(navigationAction.request.url!);
        }
        
        return nil;
    }

}
