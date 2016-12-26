//
//  ViewController.swift
//  Combobox-Demo
//
//  Created by 王浩 on 16/12/23.
//  Copyright © 2016年 uniproud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var combobox1: Combobox?
    var combobox2: Combobox?
    var combobox3: Combobox?
    
    var comboboxSize: CGSize {
        return CGSize(width: 250, height: 40)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.combobox1 = Combobox(frame: CGRect(x: (self.view.bounds.width-comboboxSize.width)/2, y: 50, width: comboboxSize.width, height: comboboxSize.height))
        self.combobox1?.delegate = self
        self.combobox1?.listArray = ["选项1","选项2","选项3","选项4","选项5","选项6","选项7","选项8"]
        self.combobox1?.placeholder = "请选择"
        self.combobox1?.backgroundColor = UIColor(red: 247/255.0, green: 255/255.0, blue: 119/255.0, alpha: 1)
       self.view.addSubview(self.combobox1!)
        
        self.combobox2 = Combobox(frame: CGRect(x: (self.view.bounds.width-comboboxSize.width)/2, y: 120, width: comboboxSize.width, height: comboboxSize.height))
        self.combobox2?.delegate = self
        self.combobox2?.listArray = ["选项1","选项2","选项3","选项4","选项5","选项6","选项7","选项8"]
        self.combobox2?.placeholder = "请选择"
        self.combobox2?.comboboxStyle = ComboboxStyle.RoundCorner
        self.combobox2?.backgroundColor = UIColor.greenColor()
        self.view.addSubview(self.combobox2!)
        
       self.combobox3 = Combobox(frame: CGRect(x: (self.view.bounds.width-comboboxSize.width)/2, y: 190, width: comboboxSize.width, height: comboboxSize.height))
        self.combobox3?.delegate = self
        self.combobox3?.listArray = ["选项1","选项2","选项3","选项4","选项5","选项6","选项7","选项8"]
        self.combobox3?.placeholder = "请选择"
        self.combobox3?.comboboxStyle = ComboboxStyle.RoundHead
        self.combobox3?.textAlignment = .Center
        self.view.addSubview(self.combobox3!)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController:ComboboxDelegate {
    
    func clickCombobox(combobox: Combobox, dropDowm: Bool) {
        if dropDowm {
            if combobox === self.combobox1 {
                self.combobox2?.resetDropDown()
                self.combobox3?.resetDropDown()
            } else if combobox === self.combobox2 {
                self.combobox1?.resetDropDown()
                self.combobox3?.resetDropDown()
            } else if combobox == self.combobox3 {
                self.combobox1?.resetDropDown()
                self.combobox2?.resetDropDown()
            }
        }
    }
    
    func selectComboboxListItem(combobox: Combobox, index: Int) {
        print(combobox.text)
        print(index)
    }
}




















