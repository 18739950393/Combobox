//
//  Combobox.swift
//
//
//  Created by 王浩 on 16/12/22.
//  Copyright © 2016年 uniproud. All rights reserved.
//

import UIKit

///下拉框样式
public enum ComboboxStyle {
    ///普通样式
    case Plain
    ///圆角样式
    case RoundCorner
    ///圆头样式
    case RoundHead
}

///下拉框代理
public protocol ComboboxDelegate:NSObjectProtocol {
    
    ///下拉列表单项被选择
    /// - parameter combobox: 当前下拉框
    /// - parameter index: 当前选项下标索引
    /// - parameter Void
    func selectComboboxListItem(combobox:Combobox,index:Int)
    
    ///点击了下拉框 可选方法，用于处理界面其他需要还原的控件
    /// - parameter combobox: 当前下拉框
    /// - parameter dropDowm: true代表处于下拉，false代表没有下拉
    /// - parameter Void
    func clickCombobox(combobox:Combobox,dropDowm:Bool)
}

public extension ComboboxDelegate {
    
    ///在此做一个空实现，为了实现协议方法的可选
    func clickCombobox(combobox:Combobox,dropDowm:Bool) {}
}

///下拉框
public class Combobox: UIControl {

    //MARK:-外部主要属性
    ///代理
    weak public var delegate: ComboboxDelegate?
    ///列表数据
    public var listArray = [String]()
    
    
    //MARK:-外部可选属性
    ///下拉框样式
    public var comboboxStyle: ComboboxStyle = .Plain
    ///倒角半径 (倒角情况下的半径)
    public var cornerRadius: CGFloat = 5
    
    ///占位符
    public var placeholder: String?
    ///当前值
    public var text: String? {
        willSet {
            textField.text = newValue
        }
    }
    ///当前值字体 (默认14)
    public var textFont: UIFont = UIFont.systemFontOfSize(14)
    ///当前值颜色 (默认黑)
    public var textColor: UIColor = UIColor.blackColor()
    ///当前值对其方式 (默认左对齐)
    public var textAlignment: NSTextAlignment = .Left
    
    ///边框线宽 (默认1)
    public var borderWidth: CGFloat = 0.7
    ///边框颜色 (默认灰色)
    public var borderColor: UIColor = UIColor.grayColor()
    
    ///列表最大显示数 (默认6，多余下拉)
    public var listItemMaxNumber: Int = 6
    ///列表项字体颜色
    public var listItemTextColor: UIColor = UIColor.blackColor()
    ///列表容器背景色 (默认白色)
    public var listContainerBackground: UIColor = UIColor.whiteColor()
    

    //MARK:-私有属性
    ///文本域
    private let textField = UITextField()
    ///触发按钮
    private var triggerButton = UIButton()
    ///列表容器
    private var listContainer: UIScrollView?
    ///根视图
    private var rootView: UIView?
    ///下拉指示器图片
    private var downIndicatorImage: UIImage? {
        return UIImage(named: "down_arrow")
    }
    ///下拉指示器右边距 (默认10)
    private var downIndicatorRightMargin: CGFloat = 10
    ///列表容器在外面的Frame
    private var listContainerOutFrame: CGRect = CGRectZero
    ///列表容器在内部的Frame
    private var listContainerInFrame: CGRect = CGRectZero
    ///列表容器动画时长
    private var listContainerAnimateDuration: Double {
        return 0.2
    }
    ///列表容器动画延迟
    private var listContainerAnimateDelay: Double {
        return 0
    }
    ///列表容器动画选项
    private var listContainerAnimateOption: UIViewAnimationOptions {
        return .CurveEaseInOut
    }
    ///列表单项高比例(相对于下拉框)
    private var listItemHeightRatio:CGFloat {
        return 1.2
    }
    ///列表容器和文本框间隔
    private var listContainerTopSpace: CGFloat = -1
    ///文本域X
    private var textFieldX: CGFloat{
        return 5
    }
    ///下拉指示器大小
    private var downIndicatorSize: CGSize {
        return CGSize(width: 15, height: 15)
    }
    ///默认背景色
    private let defaultBackgroundColor = UIColor.whiteColor()
    
    
    //MARK:-init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = self.defaultBackgroundColor
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:-绘制
    override public func drawRect(rect: CGRect) {
        
        //绘制边框
        switch self.comboboxStyle {
        case .Plain:
            self.setBorder(self.borderWidth, borderColor: self.borderColor)
        case .RoundCorner:
            self.setCorner(self.cornerRadius, borderWidth: self.borderWidth, borderColor: self.borderColor)
            self.listContainerTopSpace = 2
        case .RoundHead:
            self.setCorner((min(rect.width, rect.height))/2, borderWidth: self.borderWidth, borderColor: self.borderColor)
            self.listContainerTopSpace = 2
        }
        
        //添加文本域
        self.setTextField()
        
        //添加下拉指示器
        self.setDownIndicator()
        
        //添加触发按钮
        self.setTriggerButton()
        
    }
    
    //MARK:-外部接口
    ///复位下拉状态
    public func resetDropDown() {
        triggerButton.selected = false
        UIView.animateWithDuration(self.listContainerAnimateDuration, delay: self.listContainerAnimateDelay, options: self.listContainerAnimateOption, animations: {
            self.listContainer?.frame = self.listContainerInFrame
            }, completion: { (completion) in
                self.listContainer?.removeFromSuperview()
        })
    }
    
    ///复位下拉框
    public func resetCombobox() {
        self.text = nil
        triggerButton.selected = false
         UIView.animateWithDuration(self.listContainerAnimateDuration, delay: self.listContainerAnimateDelay, options: self.listContainerAnimateOption, animations: {
            self.listContainer?.frame = self.listContainerInFrame
            }, completion: { (completion) in
                self.listContainer?.removeFromSuperview()
                self.listContainer = nil
        })
    }

    //MARK:-私有方法 初始化
    ///放置文本域
    private func setTextField() {
        self.textField.frame = CGRect(x: self.textFieldX, y: 0, width: self.bounds.size.width-self.downIndicatorSize.width-self.textFieldX-self.downIndicatorRightMargin, height: self.bounds.size.height)
        self.textField.borderStyle = .None
        self.textField.placeholder = self.placeholder
        self.textField.text = self.text
        self.textField.enabled = false
        self.textField.backgroundColor = UIColor.clearColor()
        self.textField.font = self.textFont
        self.textField.textColor = self.textColor
        self.textField.textAlignment = self.textAlignment
        self.addSubview(self.textField)
    }
    ///放置下拉指示器
    private func setDownIndicator() {
        let downIndicator = UIImageView(frame: CGRect(x: self.bounds.size.width-downIndicatorSize.width-self.downIndicatorRightMargin, y: (self.bounds.size.height-downIndicatorSize.height)/2, width: downIndicatorSize.width, height: downIndicatorSize.height))
        downIndicator.image = downIndicatorImage
        self.addSubview(downIndicator)
    }
    ///放置触发按钮
    private func setTriggerButton() {
        self.triggerButton.frame = self.bounds
        self.triggerButton.backgroundColor = UIColor.clearColor()
        self.triggerButton.addTarget(self, action: #selector(Combobox.triggerButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(self.triggerButton)
    }
    
    ///初始化列表容器
    private func setListContainer() {
        ///列表单项高
        let itemHeight = self.bounds.size.height*self.listItemHeightRatio
        //列表容器高
        let listContainerHeight = CGFloat(min(self.listItemMaxNumber, self.listArray.count))*itemHeight
        
        //列表容器起点
        var containerOrigin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y+self.bounds.height+self.listContainerTopSpace)
        self.rootView = self //先将自身给根视图
        //必须将容器添加在根视图中，找到根视图，并拿到起点
        while let overView = self.rootView?.superview {
            containerOrigin.x += overView.frame.origin.x
            containerOrigin.y += overView.frame.origin.y
            self.rootView = overView
        }
        //列表容器收回的Frame和弹出的Frame
        self.listContainerInFrame = CGRect(origin: containerOrigin, size: CGSize(width: self.bounds.size.width, height: 0))
        self.listContainerOutFrame = CGRect(origin: containerOrigin, size: CGSize(width: self.bounds.size.width, height: listContainerHeight))
        
        self.listContainer = UIScrollView(frame: self.listContainerInFrame)
        self.listContainer?.contentSize = CGSize(width: self.frame.size.width, height: CGFloat(self.listArray.count)*itemHeight)
        self.listContainer?.backgroundColor = self.listContainerBackground
        
        //绘制边框
        switch self.comboboxStyle {
        case .Plain:
            self.listContainer?.setBorder(self.borderWidth, borderColor: self.borderColor)
        case .RoundCorner:
            self.listContainer?.setCorner(self.cornerRadius, borderWidth: self.borderWidth, borderColor: self.borderColor)
        case .RoundHead:
            self.listContainer?.setCorner((min(self.bounds.width, self.bounds.height))/2, borderWidth: self.borderWidth, borderColor: self.borderColor)
        }
        
        //添加列表项
        for i in 0..<self.listArray.count {
            let item = self.listArray[i]
            
            //响应按钮
            let listItemButton = UIButton(frame: CGRect(x: 0, y: CGFloat(i)*itemHeight, width: self.frame.size.width, height: itemHeight))
            listItemButton.setBackgroundImage(UIImage.imageWithColor(self.backgroundColor ?? self.defaultBackgroundColor), forState: .Highlighted)
            listItemButton.setBackgroundImage(UIImage.imageWithColor(self.backgroundColor ?? self.defaultBackgroundColor), forState: .Selected)
            listItemButton.tag = i
            listItemButton.addTarget(self, action: #selector(Combobox.listItemButtonClick(_:)), forControlEvents: .TouchUpInside)
            self.listContainer?.addSubview(listItemButton)
            
            //标签
            let listItemLabel = UILabel(frame: CGRect(x: self.textFieldX, y: CGFloat(i)*itemHeight, width: self.bounds.size.width-self.downIndicatorSize.width-self.textFieldX-self.downIndicatorRightMargin, height: itemHeight))
            listItemLabel.text = item
            listItemLabel.textColor = self.listItemTextColor
            listItemLabel.textAlignment = self.textAlignment
            listItemLabel.font = self.textFont
            self.listContainer?.addSubview(listItemLabel)
        }
    }

    //MARK:-私有方法 响应事件
    ///触发按钮
    @objc private func triggerButtonClick(sender:UIButton) {
        
        sender.selected = !sender.selected
        //如果是被选择
        if sender.selected {
            //列表容器如果没有创建
            if self.listContainer == nil {
                //初始化列表容器
                self.setListContainer()
                //弹出下拉容器
                self.popListContainer()
                
            //列表容器如果已经创建
            } else {
                
                //弹出下拉容器
                self.popListContainer()
            }
            
            //调用代理方法
            self.delegate?.clickCombobox(self, dropDowm: true)
            
        //如果取消选择，将列表容器从父视图中移除
        } else {
            //复位下拉状态
            self.resetDropDown()
            
            //调用代理方法
            self.delegate?.clickCombobox(self, dropDowm: false)
        }
        
    }
    
    ///列表单项按钮
    @objc private func listItemButtonClick(sender:UIButton) {
        sender.selected = true
        
        //复位下拉状态
        triggerButton.selected = false
        UIView.animateWithDuration(self.listContainerAnimateDuration, delay: self.listContainerAnimateDelay, options: self.listContainerAnimateOption, animations: {
            self.listContainer?.frame = self.listContainerInFrame
            }, completion: { (completion) in
                sender.selected = false
                self.listContainer?.removeFromSuperview()
        })
        
        if self.listArray.count > sender.tag {
            self.text = self.listArray[sender.tag]
        }
        self.delegate?.selectComboboxListItem(self, index: sender.tag)
    }
    
    //MARK:-私有方法 自定义
    ///弹出下拉容器
    private func popListContainer() {
        
        //列表容器添加到根视图中
        self.rootView?.addSubview(self.listContainer!)
        //避免被其他视图遮盖，放到父视图前面
        self.rootView?.bringSubviewToFront(self.listContainer!)
        
        UIView.animateWithDuration(self.listContainerAnimateDuration, delay: self.listContainerAnimateDelay, options: self.listContainerAnimateOption, animations: {
            self.listContainer?.frame = self.listContainerOutFrame
            }, completion: { (completion) in
                
        })
    }
    
    
}











