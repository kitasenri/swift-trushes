//
//  RequestUtils.swift
//  CommonModules
//
//  Created by Kitasenri on 2018/01/01.
//  Copyright © 2018年 Kitasenri. All rights reserved.
//

import Foundation

class JsonUtils {

    /**
     * Create URLRequest
     *
     * @param serviceURL String
     * @return URLRequest
     */
    static func createJsonRequest( serviceURL: String, param: Data? ) -> URLRequest {

        var request = URLRequest(url: URL(string: serviceURL)!);
        request.httpMethod = "POST";
        request.httpBody = param;
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        
        return request;
    }
    
    /**
     * Parse Json
     *
     * @return Json
     */
    static func toJson(dict: Dictionary<String, String>) -> String {
        let data = try! JSONSerialization.data(withJSONObject: dict, options: []);
        return String( data: data, encoding: .utf8 )!
    }
    
    /**
     * Get URL Queries
     */
    static func getQueries( url:String ) -> Dictionary<String, String> {
        
        let urlComponent: NSURLComponents? = NSURLComponents(string: url);
        var urlQueries: Dictionary<String, String> = Dictionary<String, String>();
        
        if let count: Int = urlComponent?.queryItems?.count {
            Array( 0..<count ).forEach { ii in
                let query = urlComponent?.queryItems![ii];
                urlQueries[(query?.name)!] = query?.value;
            }
        }
        
        return urlQueries;
    }

}
