//
//  EidtViewController.swift
//  FileManagerDemo
//
//  Created by 李哲 on 2021/4/15.
//

import UIKit

class EidtViewController: UITableViewController {

    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action: #selector(EidtViewController.didFinishEdit))
        
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.cornerRadius = 5
        
        //简单处理
        if isEditable(){
            if let fileData = LLFileManager.shared.loadFileData(with: "/test/" + self.title!){
                self.contentTextView.text = String(data: fileData, encoding: String.Encoding.utf8)
            }
        }
    }
    
    @objc func didFinishEdit(){
        let contentTxt = self.contentTextView.text
        if contentTxt!.replacingOccurrences(of: " ", with: "").count == 0{
            self.contentTextView.text = ""
            print("请输入内容")
            return
        }
        if contentTxt!.count > 0{
            var fileName = contentTxt!.count > 10 ? contentTxt?.substring(to: String.Index(encodedOffset: 9)) : contentTxt
            //简单去空，没加复杂逻辑处理
            fileName = fileName?.replacingOccurrences(of: " ", with: "")
            if self.saveContext(to: String(format: "/test/%@.%@", fileName!,"txt"), txt: contentTxt!){
                print("存储成功")
                NotificationCenter.default.post(name: FolderUpdateNotificationName, object: nil)
                self.navigationController?.popViewController(animated: true)
            }else{
                print("存储失败")
            }
        }else{
            print("请输入内容")
        }
    }
    
    func saveContext(to filePath:String, txt:String) -> Bool {
        if isEditable(){
            return LLFileManager.shared.recoveryFile(with: filePath, txt: txt)
        }else{
            return LLFileManager.shared.createNewFile(with: filePath, txt: txt)
        }
    }
    
    func isEditable() -> Bool{
        return self.title != "editVC" && self.title != nil
    }
}
