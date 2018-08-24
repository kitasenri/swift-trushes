//
//  CommonUtils.swift
//  CommonModules
//
//  Created by Kitasenri on 2018/01/01.
//  Copyright © 2018年 Kitasenri. All rights reserved.
//

import UIKit

class CommonUtils {

    private static var _DATE_FORMATTER: DateFormatter? = nil;

    /**
     * Get DateFormatter
     */
    static func getDateFormatter() -> DateFormatter {
        
        if let formatter = _DATE_FORMATTER {
            return formatter;
        }
        
        _DATE_FORMATTER = DateFormatter();
        _DATE_FORMATTER?.dateFormat = "YYYY/MM/dd";
        return _DATE_FORMATTER!;
    }

    static func getWhiteHalfOpacity() -> UIColor {
        return UIColor(
            red: 0xFF / 0xFF,
            green: 0xFF / 0xFF,
            blue: 0xFF / 0xFF,
            alpha: 0.75
        );
    }

    /**
     * Get secure url.
     * If argument is not secure, protocol is changed.
     */
    static func getSecureURL( srcURL: String? ) -> String? {
        
        guard let url = srcURL else {
            return nil;
        }

        if url.hasPrefix("https") {
            return url;
        } else if url.hasPrefix("http") {
            return url.replacingOccurrences(of:"http", with:"https");
        } else {
            return url;
        }
        
    }
    
    /**
     * Create UserAgent
     */
    static func createUserAgent() -> String {
        
        let version = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString") as! String;
        let build = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleVersion") as! String;
        
        let appKey = "app-name";
        let appVersion = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString") as! String;
        
        let userAgent = "App=\(appKey)&AppVersion=\(appVersion)&iOS=\(version)(\(build))";

        return userAgent;
    }
    
    /**
     * Get root view
     *
     * @return root view.
     */
    static func getRootView() -> UIView {
        return (UIApplication.shared.keyWindow?.rootViewController?.view)!;
    }
    
}
