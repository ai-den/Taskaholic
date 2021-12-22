//
//  Extensions.swift
//  TaskManager
//
//  Created by Aiden on 09/12/2021.
//

import Foundation
import UIKit

extension UIColor {
    class func color(withData data: Data) -> UIColor {
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! UIColor
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

extension Date {
    func getDateString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current)!
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat)
        return dateFormatter.string(from: self)
    }
}

@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if newValue == 0 {
                self.layer.cornerRadius = self.frame.height/2
            } else {
                self.layer.cornerRadius = newValue
            }
            self.clipsToBounds = true
        }
    }
    
    private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
    }
    
    func roundBottomCorners(radius: CGFloat = 10) {
        
           self.clipsToBounds = true
           self.layer.cornerRadius = radius
           if #available(iOS 11.0, *) {
               self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
           } else {
               self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: radius)
           }
    }
}

extension UITextView :UITextViewDelegate
{
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = UIFont.systemFont(ofSize: self.font!.pointSize, weight: .regular)
        placeholderLabel.textColor = UIColor.placeholderText
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}
