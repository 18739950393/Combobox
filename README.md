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

   ///创建
   self.combobox1 = Combobox(frame: self.comboboxFrame)
   
   ///添加列表数据
   self.combobox1?.listArray = ["选项1","选项2","选项3","选项4","选项5"]
   
   ///添加下拉框占位符
   self.combobox1?.placeholder = "请选择"
   
   ///添加下拉框背景色（选择背景色）
   self.combobox1?.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
   
   ///添加下拉框代理
   self.combobox1?.delegate = self
   
   ///将下拉框添加到view
   self.view.addSubview(combobox1!)  
