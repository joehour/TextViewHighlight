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
    
    
    public func setMutiContentView(_ string: String, linkColor: UIColor = UIColor.blue){
        
        let searchString = "%mark<(.+?)>"
        let linksearchString = "%link<(.+?)>"
        
        
        let baseString = string
        let attributed = NSMutableAttributedString(string: baseString)
        let regex = try! NSRegularExpression(pattern: searchString,
                                             options: [.caseInsensitive])
        
        do {
            let linkRegex = try! NSRegularExpression(pattern: linksearchString,
                                                      options: [.caseInsensitive])
            attributed.beginEditing()
            
            var i = 0
            for match in linkRegex.matches(in: baseString, options:[], range: NSRange(location: 0, length: baseString.characters.count)) as [NSTextCheckingResult] {
                
                let range = (baseString.characters.index(baseString.startIndex, offsetBy: match.range.location) ..< baseString.characters.index(baseString.startIndex, offsetBy: match.range.location + match.range.length))
                
                let subString = baseString.substring(with: range)
                
                let httpString: String = get_http_string(subString)

                attributed.addAttribute(NSLinkAttributeName, value: httpString, range: NSRange(location: match.range.location+(1-i), length: match.range.length-2))
                
                attributed.addAttribute(NSUnderlineStyleAttributeName,
                                        value: NSUnderlineStyle.styleSingle.rawValue , range: NSRange(location: match.range.location+(1-i), length: match.range.length-2))
                
                attributed.deleteCharacters(in: NSRange(location: match.range.location-i, length: 6))
                i+=6
                attributed.deleteCharacters(in: NSRange(location: match.range.location+match.range.length-(1+i)-httpString.characters.count-2, length: 1+httpString.characters.count+2))
                i+=1+httpString.characters.count+2
            }
            
            
            var j = 0
            for match in regex.matches(in: attributed.string, options:[], range: NSRange(location: 0, length: attributed.string.characters.count)) as [NSTextCheckingResult] {
                
                let range = (baseString.characters.index(baseString.startIndex, offsetBy: match.range.location) ..< baseString.characters.index(baseString.startIndex, offsetBy: match.range.location + match.range.length))
                let subString = baseString.substring(with: range)
                
                var uiColor: UIColor = UIColor(hexString: "#99FF00")
                
                let colorString:String = subString.substring(with: (subString.characters.index(subString.endIndex, offsetBy: -9) ..< subString.characters.index(subString.endIndex, offsetBy: -1)))
                    
                    let pattern = "( #[0-9a-f]{6})"
                    let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                    let nsString = colorString as NSString
                    let matches = regex.matches(in: colorString, options: [], range: NSMakeRange(0, nsString.length))
                
                    var colorMatch :Bool = false
                
                    if matches.count > 0 {
                        uiColor = UIColor(hexString: nsString.substring(from: 1))
                        colorMatch = true
                        
                    }

                attributed.addAttribute(NSForegroundColorAttributeName, value: uiColor, range: NSRange(location: match.range.location+(1-j), length: match.range.length-2))
                attributed.deleteCharacters(in: NSRange(location: match.range.location-j, length: 6))
                j+=6
                if !colorMatch {
                    attributed.deleteCharacters(in: NSRange(location: match.range.location+match.range.length-(1+j), length: 1))
                    j+=1
                }
                else{
                    attributed.deleteCharacters(in: NSRange(location: match.range.location+match.range.length-(9+j), length: 9))
                    j+=9
                }
                
            }
            attributed.endEditing()
            
            self.attributedText = attributed
            
            self.linkTextAttributes = [NSForegroundColorAttributeName : linkColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
            
            
            self.dataDetectorTypes = UIDataDetectorTypes.link
            self.isEditable = false
            
        } catch {
            print("wrong format")
        }
        
        
    }
    
    
    
}

 private func get_http_string(_ string: String) -> String{
   
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

func UIColorFromHex(_ Hex: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((Hex & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((Hex & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(Hex & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UIColor {
    convenience init(hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            self.init(hexString: "#99FF00")
        } else {

            let rString: String = cString.substring(with: (cString.startIndex ..< cString.characters.index(cString.startIndex, offsetBy: 2)))
            let gString: String = cString.substring(with: (cString.characters.index(cString.startIndex, offsetBy: 2) ..< cString.characters.index(cString.startIndex, offsetBy: 4)))
            let bString: String = cString.substring(with: (cString.characters.index(cString.startIndex, offsetBy: 4) ..< cString.endIndex))
            
            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            
            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
        
        
    }
}

