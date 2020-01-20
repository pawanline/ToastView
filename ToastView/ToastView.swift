//
//  ToastView.swift
//  ToastView
//
//  Created by Pawan Kumar on 13/01/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import Foundation
import UIKit

class ToastView: UIView {
    
    internal var buttonAction: (()->Void)? = nil
    
    private var isSettingForDelete: Bool = false
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var viewRightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    class func instanceFromNib() -> ToastView {
        return UINib(nibName: "ToastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToastView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTextColorAndFont()
        self.addGestures()
    }
    
    func setupTextColorAndFont() {
        
        self.messageLabel.font    = UIFont.systemFont(ofSize: 14.0)
        self.messageLabel.textColor = UIColor.white
        self.viewRightButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        self.viewRightButton.titleLabel?.textColor = UIColor.clear
    }
    
    func addGestures() {
        let dismissRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewRightButtonTapped(_:)))
              addGestureRecognizer(dismissRecognizer)
        let swipeGestures = UISwipeGestureRecognizer(target: self, action: #selector(self.viewRightButtonTapped(_:)))
        swipeGestures.direction = .left
        addGestureRecognizer(swipeGestures)
    }
    
    
    @IBAction func viewRightButtonTapped(_ sender: UIButton) {
        if let handel = self.buttonAction {
            handel()
        }
    }
}

extension ToastView {
    
    func setupToastForDelete(buttonAction: (()->Void)? = nil) {
        self.isSettingForDelete = true
        self.setupToastMessage(title: "", message: "", buttonTitle: "Undo", buttonImage: nil, buttonAction: buttonAction)
        self.isSettingForDelete = false
    }
    
    func setupToastMessage(title: String = "", message: String, buttonTitle: String = "", buttonImage: UIImage? = nil, buttonAction: (()->Void)? = nil) {
        
        self.messageLabel.attributedText = self.getAttrText(title: title, message: message)
        self.buttonAction = buttonAction
        
        self.viewRightButton.setTitle(buttonTitle, for: .normal)
        self.viewRightButton.setTitle(buttonTitle, for: .selected)
        
        self.viewRightButton.setImage(buttonImage, for: .normal)
        self.viewRightButton.setImage(buttonImage, for: .selected)
        
        if buttonTitle.isEmpty, buttonImage == nil {
            //hide button
            self.viewRightButton.isHidden = true
        }
        else {
            //showButton
            self.viewRightButton.isHidden = false
        }
    }
    
    private func getAttrText(title: String, message: String) -> NSMutableAttributedString {
        if self.isSettingForDelete {
            return self.getTextWithImage(startText: "", image: #imageLiteral(resourceName: "ic_delete_toast"), endText: "Delete", font: UIFont.systemFont(ofSize: 16.0))
        }
        else {
            
            var finalText = title
            if !title.isEmpty {
                finalText += "\n"
            }
            finalText += "\(message)"
            
            let attString: NSMutableAttributedString = NSMutableAttributedString(string: finalText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
            
            attString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)], range: (finalText as NSString).range(of: title))
            
            return attString
        }
    }
    
    // Use  it for creating an image with text .It will return NSMutableattributed string.
    func getTextWithImage(startText: String, image: UIImage, endText: String, font: UIFont, isEndTextBold: Bool = false) -> NSMutableAttributedString {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: startText)
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        
        //        image1Attachment.bounds.origin = CGPoint(x: 0.0, y: 5.0)
        image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        image1Attachment.image = image
        
        // wrap the attachment in its own attributed string so we can append it
        
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        if isEndTextBold {
            let endStringAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]
            let endAttributedString = NSAttributedString(string: "   " + endText, attributes: endStringAttribute)
            fullString.append(endAttributedString)
        } else {
            fullString.append(NSAttributedString(string: endText))
        }
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        
        return fullString
    }
}
