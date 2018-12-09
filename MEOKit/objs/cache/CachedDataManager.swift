//
//  CachedDataManager.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/09.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public class CachedDataManager: NSObject {

    public static var shared: CachedDataManager = CachedDataManager()

    private var cache: NSCache<AnyObject, AnyObject>!
    private var pathCacheDir : String!
    private let dirName:String = "CachesByCachedDataManager"
    
    private override init() {
        super.init()
        self.cache = NSCache()
        self.cache.countLimit = 20
        
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory,
                                                        .userDomainMask,
                                                        true)
        let url = URL(string: paths[0])!
        self.pathCacheDir = url.appendingPathComponent(dirName).absoluteString
        self.makeTempDirs()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveMemoryWarning(notification:)),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }
    
    @objc func didReceiveMemoryWarning(notification: Notification){
        self.clearCachesOnMemory()
    }
    
    private func clearCachesOnMemory(){
        self.cache.removeAllObjects()
    }
    
    public func deleteCaches(){
        self.clearCachesOnMemory()
        if FileManager.default.fileExists(atPath: self.pathCacheDir){
            do{
                try FileManager.default.removeItem(atPath: self.pathCacheDir)
                self.makeTempDirs()
            }catch{
            }
        }
    }
    
    private func pathForUrl(urlString: String) -> URL{
        let md5 = urlString.md5()
        let path = URL(string: self.pathCacheDir)!.appendingPathComponent(String(md5.prefix(2)))
        let path2 = path.appendingPathComponent(md5)
        
        
        print(path2.absoluteString)
        return path2
    }
    
    private func makeTempDirs(){
        
        var isDir: ObjCBool = ObjCBool(false)
        let exists: Bool = FileManager.default.fileExists(atPath: self.pathCacheDir,
                                                          isDirectory: &isDir)
        if exists == false || isDir.boolValue == false{
            do{
                try FileManager.default.createDirectory(atPath: self.pathCacheDir,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            }catch{
            }
        }
        
        for i in 0..<16{
            for j in 0..<16{
                let subdir = self.pathCacheDir + String(format: "/%x%x", i, j)
                var isSubdir: ObjCBool = ObjCBool(false)
                let existsSubdir: Bool = FileManager.default.fileExists(atPath: subdir,
                                                                        isDirectory: &isSubdir)
                if existsSubdir == false || isSubdir.boolValue == false{
                    do{
                        try FileManager.default.createDirectory(atPath: subdir,
                                                                withIntermediateDirectories: true,
                                                                attributes: nil)
                    }catch{
                    }
                }
            }
        }
    }
}

public extension CachedDataManager{

    private func cachedDataForKey(key: String) -> CachedData?{
        var data = self.cache.object(forKey: key.md5() as AnyObject)
        if data == nil{
            data = CachedData.load(path: self.pathForUrl(urlString: key))
        }
        return (data as? CachedData)
    }
    
    public func dataForKey(key: String) -> Data?{
        guard let cachedData = self.cachedDataForKey(key: key) else {
            return nil
        }
        return cachedData.data
    }
    
    public func stringForKey(key: String) -> String?{
        guard let cachedData = self.cachedDataForKey(key: key) else {
            return nil
        }
        return cachedData.string
    }
    
    public func imageForKey(key: String) -> UIImage?{
        guard let cachedData = self.cachedDataForKey(key: key) else {
            return nil
        }
        return cachedData.image
    }
    
    private func setCachedData(cachedData: CachedData, key:String){
        cachedData.write(path: self.pathForUrl(urlString: key))
        self.cache.setObject(cachedData, forKey: key.md5() as AnyObject)
    }
    
    public func setData(_ data: Data, key:String, validity:CachedValidity = .oneweek){
        let cachedData:CachedData = CachedData(data: data, validity: validity)
        self.setCachedData(cachedData: cachedData, key: key)
    }
    
    public func setString(_ string: String, key:String, validity:CachedValidity = .oneweek) {
        let cachedData:CachedData = CachedData(string: string, validity: validity)
        self.setCachedData(cachedData: cachedData, key: key)
    }
    
    public func setImage(_ image: UIImage, key:String, validity:CachedValidity = .oneweek) {
        var imageFormat:CachedImageFormat = .jpg
        if key.hasSuffix(".jpg") || key.hasSuffix(".jpeg"){
            imageFormat = .jpg
        }else if key.hasSuffix(".png"){
            imageFormat = .png
        }
        let cachedData:CachedData = CachedData(image: image,
                                               imageFormat: imageFormat,
                                               validity: validity)
        self.setCachedData(cachedData: cachedData, key: key)
    }
    
    public func deleteForKey(key: String){
        self.cache.removeObject(forKey: key.md5() as AnyObject)
        CachedData.delete(path: self.pathForUrl(urlString: key))
    }

}

