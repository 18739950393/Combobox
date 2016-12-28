# Combobox
swift package combobox swift封装下拉框

>>>>>>> d018567bbf70228baaf7cc8e09fdf2b2f56b1db5

## 文件描述
  通过自定义view封装的下拉框控件，如果有需要使用下拉框的界面，可以直接集成使用，节约您的开发时间，支持开源。
  
  
## Usage

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add Combobox to your project.

1. Add a pod entry for Combobox to your Podfile `pod 'Combobox'`
2. Install the pod(s) by running `pod install`.
3. Include Combobox wherever you need it with `import Combobox`.


### Copy the Combobox folder to your project
  
## API指南(例如:)

   self.combobox1 = Combobox(frame: CGRect(x: (self.view.bounds.size.width-self.comboboxSize.width)/2, y: 50, width: self.comboboxSize.width, height: self.comboboxSize.height))
   self.combobox1?.listArray = ["选项1","选项2","选项3","选项4","选项5"]
   self.combobox1?.placeholder = "请选择"
   self.combobox1?.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
   self.combobox1?.delegate = self
   self.view.addSubview(combobox1!)  
