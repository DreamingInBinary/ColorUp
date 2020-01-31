import Foundation
import UIKit

extension UIColor : CodedColors {    
    func cu_MainTheme() -> UIColor {
        return UIColor(named: "MainTheme")
    }
    
    func cu_SecondaryTheme() -> UIColor {
        return UIColor(named: "SecondaryTheme")
    }
}