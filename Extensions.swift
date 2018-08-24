//
//  Extensions.swift
//  CommonModules
//
//  Created by Kitasenri on 2018/01/01.
//  Copyright © 2018年 Kitasenri. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge( dict: Dictionary ) {
        for (key, value) in dict {
            self.updateValue(value, forKey: key);
        }
    }
}

/*
extension Array {

    func toDictionary( dictKey: String, recursiveKey: String, dst: [String : Dictable]? = nil ) -> [String : Dictable] {
        var dictionary: [String : Dictable] = dst != nil ? dst! : [:];
        for key in self {
            let dictable = key as! Dictable;
            dictionary[ dictable.keycode ] = dictable;
        }        
        return dictionary;
    }
    
}
*/
