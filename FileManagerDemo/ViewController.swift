//
//  ViewController.swift
//  FileManagerDemo
//
//  Created by 李哲 on 2021/4/14.
//

import UIKit

let FolderUpdateNotificationName = NSNotification.Name(rawValue: "FileCreateSucc")

class ViewController: UITableViewController {
    
    var dataArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "文件管理"
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadData), name: FolderUpdateNotificationName, object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(ViewController.pushToEditVC))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
//        self.tableView.refreshControl?.beginRefreshing()
        
        
        LLFileManager.shared.createFolder(with: "/test")
        LLFileManager.shared.createNewFile(with: "/test/test.txt", txt: "这是一个测试")
        loadData()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.dataArr[indexPath.row]
//        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let txtFile = self.dataArr[indexPath.row]
            if LLFileManager.shared.removeFile(with: String(format: "/test/%@", txtFile)){
                //也可以直接reloadData一下
                self.dataArr.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let filePath = self.dataArr[indexPath.row]
        pushToDetailVC(fileName: filePath)
    }
    
    //createNewFile
    @objc func pushToEditVC(){
        pushToDetailVC(fileName: "")
    }
    @objc func pushToDetailVC(fileName : String){
        let eidtVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "EidtViewController")
        eidtVC.title = fileName.count > 0 ? fileName : "editVC"
        self.navigationController?.pushViewController(eidtVC, animated: true)
    }
    
    
    func loadData(){
        if let subPathArr = LLFileManager.shared.loadFileList(with: "/test") {
            print(subPathArr)
            self.dataArr = subPathArr
            self.tableView.reloadData()
            if subPathArr.count > 0{
                if let fileData = LLFileManager.shared.loadFileData(with: "/test/" + subPathArr.first!){
                    print(String(data: fileData, encoding: String.Encoding.utf8))
                }
            }
        }
    }
    
    @objc func reloadData(){
        self.dataArr.removeAll()
        loadData()
    }
    
}

