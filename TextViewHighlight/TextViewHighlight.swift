//
//  TextViewHighlight.swift
//  TextViewHighlight
//
//  Created by JoeJoe on 2016/7/19.
//  Copyright © 2016年 Joe. All rights reserved.
//

import Foundation
import UIKit


extension UITextView{
    
    
    public func setMutiContentView(string: String, linkColor linkColor: UIColor = UIColor.blueColor()){
        
        let searchString = "%mark<(.+?)>"
        let linksearchString = "%link<(.+?)>"
        
        
        let baseString = string
        let attributed = NSMutableAttributedString(string: baseString)
        let regex = try! NSRegularExpression(pattern: searchString,
                                             options: [.CaseInsensitive])
        
        do {
            let linkRegex = try! NSRegularExpression(pattern: linksearchString,
                                                      options: [.CaseInsensitive])
            attributed.beginEditing()
            
            var i = 0
            for match in linkRegex.matchesInString(baseString, options:[], range: NSRange(location: 0, length: baseString.characters.count)) as [NSTextCheckingResult] {
                
                let range = Range(start: baseString.startIndex.advancedBy(match.range.location), end: baseString.startIndex.advancedBy(match.range.location + match.range.length))
                
                let subString = baseString.substringWithRange(range)
                
                let httpString: String = get_http_string(subString)

                attributed.addAttribute(NSLinkAttributeName, value: httpString, range: NSRange(location: match.range.location+(1-i), length: match.range.length-2))
                
                attributed.addAttribute(NSUnderlineStyleAttributeName,
                                        value: NSUnderlineStyle.StyleSingle.rawValue , range: NSRange(location: match.range.location+(1-i), length: match.range.length-2))
                
                attributed.deleteCharactersInRange(NSRange(location: match.range.location-i, length: 6))
                i+=6
                attributed.deleteCharactersInRange(NSRange(location: match.range.location+match.range.length-(1+i)-httpString.characters.count-2, length: 1+httpString.characters.count+2))
                i+=1+httpString.characters.count+2
            }
            
            
            var j = 0
            for match in regex.matchesInString(attributed.string, options:[], range: NSRange(location: 0, length: attributed.string.characters.count)) as [NSTextCheckingResult] {
                
                let range = Range(start: baseString.startIndex.advancedBy(match.range.location), end: baseString.startIndex.advancedBy(match.range.location + match.range.length))
                let subString = baseString.substringWithRange(range)
                
                var uiColor: UIColor = UIColor(hexString: "#99FF00")
                
                let colorString:String = subString.substringWithRange(Range(start: subString.endIndex.advancedBy(-9), end:
                    
                    subString.endIndex.advancedBy(-1)))
                    
                    let pattern = "( #[0-9a-f]{6})"
                    let regex = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
                    let nsString = colorString as NSString
                    let matches = regex.matchesInString(colorString, options: [], range: NSMakeRange(0, nsString.length))
                
                    var colorMatch :Bool = false
                
                    if matches.count > 0 {
                        uiColor = UIColor(hexString: nsString.substringFromIndex(1))
                        colorMatch = true
                        
                    }

                attributed.addAttribute(NSForegroundColorAttributeName, value: uiColor, range: NSRange(location: match.range.location+(1-j), length: match.range.length-2))
                attributed.deleteCharactersInRange(NSRange(location: match.range.location-j, length: 6))
                j+=6
                if !colorMatch {
                    attributed.deleteCharactersInRange(NSRange(location: match.range.location+match.range.length-(1+j), length: 1))
                    j+=1
                }
                else{
                    attributed.deleteCharactersInRange(NSRange(location: match.range.location+match.range.length-(9+j), length: 9))
                    j+=9
                }
                
            }
            attributed.endEditing()
            
            self.attributedText = attributed
            
            self.linkTextAttributes = [NSForegroundColorAttributeName : linkColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleNone.rawValue]
            
            
            self.dataDetectorTypes = UIDataDetectorTypes.Link
            self.editable = false
            
        } catch {
            print("wrong format")
        }
        
        
    }
    
    
    
}

 private func get_http_string(string: String) -> String{
   
    var str: String = ""
    var isFind: Bool = false
    for item in string.characters {
        
        
        if item == "]" {
            isFind = false;
        }
        
        if isFind {
            str += String(item)
        }
        
        if item == "[" {
            isFind = true;
        }
    }
    
    return str
}

func UIColorFromHex(Hex: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((Hex & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((Hex & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(Hex & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UIColor {
    convenience init(hexString: String) {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            self.init(hexString: "#99FF00")
        } else {

            let rString: String = cString.substringWithRange(Range(start: cString.startIndex, end: cString.startIndex.advancedBy(2)))
            let gString: String = cString.substringWithRange(Range(start: cString.startIndex.advancedBy(2), end: cString.startIndex.advancedBy(4)))
            let bString: String = cString.substringWithRange(Range(start: cString.startIndex.advancedBy(4), end: cString.endIndex))
            
            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)
            
            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
        
        
    }
}

