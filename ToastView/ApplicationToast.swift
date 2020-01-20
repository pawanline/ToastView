//
//  ApplicationToast.swift
//  ToastView
//
//  Created by Pawan Kumar on 13/01/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import Foundation
import Foundation
import UIKit

struct AppToast {
    
    static var `default` = AppToast()
    private init() {}
    private var spaceFromTop: CGFloat = 0.0
    
    private var toastHeight: CGFloat = 0.0
    private var toastDidClose: (()->Void)? = nil
    
    let tagAsSubview: Int = 5932
    
    mutating func showToastMessage(message: String, title: String = "", onViewController: UIViewController? = UIApplication.topViewController(), duration: Double = 5.0, buttonTitle: String = "", buttonImage: UIImage? = nil,spaceFromTop: CGFloat = 0.0, buttonAction: (()->Void)? = nil,toastDidClose: (()->Void)? = nil) {
        
        if  !message.isEmpty {
            self.toastDidClose = toastDidClose
            
            let ob  = ToastView.instanceFromNib()
            
            ob.tag = tagAsSubview
            ob.buttonAction = buttonAction
            ob.setupToastMessage(title: title, message: message, buttonTitle: buttonTitle, buttonImage: buttonImage, buttonAction: buttonAction)
            
            let lines = self.lines(label: ob.messageLabel)
            self.toastHeight = CGFloat(lines * 20 + 20)
            self.spaceFromTop = spaceFromTop
            let maxW: CGFloat = UIScreen.main.bounds.width
            var width: CGFloat = maxW
            
            if lines <= 1 {
                let tempW = message.sizeCount(withFont: ob.messageLabel.font, bundingSize: CGSize(width: 10000.0, height: self.toastHeight)).width + 42.0
                width = max(45.0, tempW)
                self.toastHeight = 16 + ob.leftButton.frame.size.height
            }
            width = max(width, maxW)
            
            let newX: CGFloat = max(((maxW - width) / 2.0),0)
            let rect = CGRect(x: newX, y:-((UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.top ?? 0.0)) , width: width, height: self.toastHeight)
            
            self.showToast(vc: onViewController!, ob: ob, toastFrame: rect, duration: duration, spaceFromTop: spaceFromTop, toastDidClose: toastDidClose)
        }
    }
    
    private func showToast(vc: UIViewController, ob: UIView, toastFrame: CGRect, duration: Double,spaceFromTop: CGFloat,toastDidClose: (()->Void)? = nil) {
        
            ob.frame = toastFrame
            UIApplication.shared.keyWindow?.addSubview(ob)
        UIView.animate(withDuration: 0.8) {
             ob.frame.origin.y = (UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.top ?? 0.0)
        }
         

            vc.view.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hideToast(animated: true)
        }
        }
    
    // hide toast with animation .
    func hideToast(animated: Bool = true) {
        
        guard let ob = UIApplication.shared.keyWindow?.subView(withTag: self.tagAsSubview) else { return }
        if animated {
            UIView.animate(withDuration: 1, animations: {
                ob.frame.origin.y = 0
            }) { (success) in
                if let handel = self.toastDidClose {
                    handel()
                }
                ob.removeFromSuperview()
            }
        }
        else {
            ob.frame.origin.y = 0
            if let handel = self.toastDidClose {
                handel()
            }
            ob.removeFromSuperview()
        }
    }
    
    // calculate number of lines based upon text in UIlabel
  func lines(label: UILabel) -> Int {
        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(label.font.lineHeight))
        let lineCount = rHeight / charSize
        return lineCount
    }
}


extension String {
    func sizeCount(withFont font: UIFont, bundingSize size: CGSize) -> CGSize {
        let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: mutableParagraphStyle]
        let tempStr = NSString(string: self)
        
        let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceilf(Float(rect.size.height))
        let width = ceilf(Float(rect.size.width))
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
}

extension UIView {
    func subView(withTag: Int) -> UIView? {
        return self.subviews.filter { $0.tag == withTag }.first
    }
}
