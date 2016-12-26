//
//  ExtensionTool.swift
//  Combobox-Demo
//
//  Created by 王浩 on 16/12/23.
//  Copyright © 2016年 uniproud. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    ///圆角边框
    /// - parameter cornerRadius: 圆角半径
    /// - parameter borderWidth: 边宽
    /// - parameter borderColor: 边框颜色
    /// - returns: Void
    func setCorner(cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
    ///普通边框
    /// - parameter borderWidth: 边宽
    /// - parameter borderColor: 边框颜色
    /// - returns: Void
    func setBorder(borderWidth:CGFloat,borderColor:UIColor) {
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
    
}

extension UIImage {
    
    ///通过颜色生成图片
    /// - parameter color: 图片颜色
    /// - returns: UIImage 颜色图片
    static func imageWithColor(color:UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        //开启画布和上下文
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        //填充色
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        //获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}


















