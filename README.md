TextViewHighlight
=======
An easy way to Highlight text in UITextView.

Features
----------

- [x] Simple methods with UITextView Category.
- [x] Support Color code.
- [x] Support Link URL.

Requirements
----------

- iOS 7.0+
- Xcode 7.3+ Swift 2.2

Installation
----------

#### Manually

Add the TextViewHighlight directory to your project.

Example
----------

####Please check out the Example project included.

#####Basic setting:

       let textView: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
       textView.setMutiContentView("Sample: %mark<Mark;> %mark<Color code; #ff1234> %link<Google[https://google.com.tw]>”)

 
License
----------

TextViewHighlight is available under the MIT License.

Copyright © 2016 Joe.

