import Foundation
import UIKit

extension UIColor : CodedColors {    
    class func MainTheme() -> UIColor {
        return UIColor(named: "MainTheme")!
    }
    
    class func SecondaryTheme() -> UIColor {
        return UIColor(named: "SecondaryTheme")!
    }
}