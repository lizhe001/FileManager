//
//  LLFileManager.swift
//  FileManagerDemo
//
//  Created by 李哲 on 2021/4/15.
//

import UIKit

class LLFileManager: NSObject {
    
    static let shared = LLFileManager()
    private let fileManeger = FileManager.default
    private let mainPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last ?? ""
    
    private override init() {}
    
    //MARK:查看文件列表
    func loadFileList(with path:String) -> [String]?{
        let folderPath = mainPath + path
        if fileManeger.fileExists(atPath: folderPath){
            //subpathsOfDirectory(atPath: ) 可以查看完整详细的子路径 如：["test", "test/The only .txt"]
           return fileManeger.subpaths(atPath: folderPath)
        }else{
           return nil
        }
    }
    
    //MARK:加载文件内容
    func loadFileData(with path:String) ->Data?{
        let filePath = mainPath + path
        if fileManeger.fileExists(atPath: filePath){
            do {
               let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
                return fileData
            } catch  {
                print("加载失败")
                return nil
            }
        }
        print("路径不存在")
        return nil
    }
    
    //MARK: 新建文件夹
    func createFolder(with folderName:String) -> Bool{
        
        let folderPath = mainPath + folderName
        if !fileManeger.fileExists(atPath: folderPath){
            do {
                //attributes：用来设置文件夹的一些属性(只读，读写等)
                try fileManeger.createDirectory(at: URL(fileURLWithPath: folderPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("创建失败！")
                return false
            }
        }else{
            print("已存在")
        }
        return true
    }
    //MARK: 新建文件
    func createNewFile(with filePath:String ,txt:String) -> Bool{
        let txtfilePath = mainPath + filePath
        //这里以txt文本为例，也可写入其他类型文件
        let fileData = txt.data(using: String.Encoding.utf8)
    
        if !fileManeger.fileExists(atPath: txtfilePath){
            return self.writeDataToFilePath(with: txtfilePath, fileData: fileData)
        }else{
            print("已存在")
            return false
        }
    }
    
    func recoveryFile(with filePath:String ,txt:String) -> Bool{
        let txtfilePath = mainPath + filePath
        //这里以txt文本为例，也可写入其他类型文件
        let fileData = txt.data(using: String.Encoding.utf8)
    
        if fileManeger.fileExists(atPath: txtfilePath){
            return self.writeDataToFilePath(with: txtfilePath, fileData: fileData)
        }else{
            print("文件路径不存在")
            return false
        }
    }
    
    func writeDataToFilePath(with filePath:String ,fileData:Data?) -> Bool{
        //写入数据也可以使用：fileData?.write(to: <#T##URL#>)，attributes：用来设置文件的一些属性(只读，读写等)
        return fileManeger.createFile(atPath: filePath, contents: fileData, attributes: nil)
    }

    //MARK: 删除文件夹
    func removeFolder(with folderName:String) -> Bool{
        
        let folderPath = mainPath + folderName
        if fileManeger.fileExists(atPath: folderPath){
            do {
                try fileManeger.removeItem(atPath: folderPath)
            } catch {
                print("删除失败！")
                return false
            }
        }else{
            print("路径不存在")
            return false
        }
        return true
    }
    //MARK: 删除文件
    func removeFile(with filePath:String) -> Bool{
        let txtfilePath = mainPath + filePath

        if fileManeger.fileExists(atPath: txtfilePath){
            do {
                try fileManeger.removeItem(atPath: txtfilePath)
            } catch {
                print("删除失败！")
                return false
            }
        }else{
            print("路径不存在")
            return false
        }
        return true
    }
    
    //复制和移动，是基于两个文件路径来操作的，所以两个文件都需要存在。
    //MARK: 复制文件
    func copyFile(from oldPath:String,to newPath:String){
        let oldFilePath = mainPath + oldPath
        let newFilePath = mainPath + newPath
        
        if fileManeger.fileExists(atPath: oldFilePath) && fileManeger.fileExists(atPath: newFilePath){
            do {
                try fileManeger.copyItem(atPath: oldFilePath, toPath: newFilePath)
            } catch {
                print("文件复制失败！")
            }
        }else{
            print("文件路径不存在")
        }
        
    }
    //MARK: 移动文件
    func moveFile(from oldPath:String,to newPath:String){
        let oldFilePath = mainPath + oldPath
        let newFilePath = mainPath + newPath
        
        if fileManeger.fileExists(atPath: oldFilePath) && fileManeger.fileExists(atPath: newFilePath){
            do {
                try fileManeger.moveItem(atPath: oldFilePath, toPath: newFilePath)
            } catch {
                print("文件移动失败！")
            }
        }else{
            print("文件路径不存在")
        }
    }
}

extension LLFileManager:NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        return LLFileManager.shared
    }
}
