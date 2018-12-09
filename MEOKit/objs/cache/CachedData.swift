//
//  CachedData.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/09.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

/// データをキャッシュする
public class CachedData: NSObject {

    private static var shared: CachedData = CachedData()
    private var cache: NSCache<AnyObject, AnyObject>!
    private var pathCacheDir : String!
    private let dirName:String = "CachesByCachedData"
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didReceiveMemoryWarningNotification,
                                                  object: nil)
    }
    
    @objc func didReceiveMemoryWarning(notification: Notification){
        self.clearCachesOnMemory()
    }
    
    private func clearCachesOnMemory(){
        self.cache.removeAllObjects()
    }
    
    private func pathForUrl(urlString: String) -> URL{
        let md5 = urlString.md5()
        let path = URL(string: self.pathCacheDir)!.appendingPathComponent(md5)
        return path
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
    }
    
    private func cachedEntity(key: String) -> CachedEntity?{
        var data = self.cache.object(forKey: key.md5() as AnyObject)
        if data == nil{
            data = CachedEntity.load(path: self.pathForUrl(urlString: key))
        }
        return (data as? CachedEntity)
    }
    
    private func setCachedEntity(cachedEntity: CachedEntity, key:String){
        cachedEntity.write(path: self.pathForUrl(urlString: key))
        self.cache.setObject(cachedEntity, forKey: key.md5() as AnyObject)
    }
}

// 公開メソッド
public extension CachedData{
    
    public static func data(key: String) -> Data?{
        let cachedData = CachedData.shared
        guard let cachedEntity = cachedData.cachedEntity(key: key) else {
            return nil
        }
        return cachedEntity.data
    }
    
    public static func string(key: String) -> String?{
        let cachedData = CachedData.shared
        guard let cachedEntity = cachedData.cachedEntity(key: key) else {
            return nil
        }
        return cachedEntity.string
    }
    
    public static func image(key: String) -> UIImage?{
        let cachedData = CachedData.shared
        guard let cachedEntity = cachedData.cachedEntity(key: key) else {
            return nil
        }
        return cachedEntity.image
    }
    
    public static func setData(_ data: Data, key:String, validity:CachedValidity = .oneweek){
        let cachedData = CachedData.shared
        let cachedEntity:CachedEntity = CachedEntity(data: data, validity: validity)
        cachedData.setCachedEntity(cachedEntity: cachedEntity, key: key)
    }
    
    public static func setString(_ string: String, key:String, validity:CachedValidity = .oneweek) {
        let cachedData = CachedData.shared
        let cachedEntity:CachedEntity = CachedEntity(string: string, validity: validity)
        cachedData.setCachedEntity(cachedEntity: cachedEntity, key: key)
    }
    
    public static func setImage(_ image: UIImage, key:String, validity:CachedValidity = .oneweek) {
        var imageFormat:CachedImageFormat = .jpg
        if key.hasSuffix(".jpg") || key.hasSuffix(".jpeg"){
            imageFormat = .jpg
        }else if key.hasSuffix(".png"){
            imageFormat = .png
        }
        let cachedData = CachedData.shared
        let cachedEntity:CachedEntity = CachedEntity(image: image,
                                               imageFormat: imageFormat,
                                               validity: validity)
        cachedData.setCachedEntity(cachedEntity: cachedEntity, key: key)
    }
    
    public static func delete(key: String){
        let cachedData = CachedData.shared
        cachedData.cache.removeObject(forKey: key.md5() as AnyObject)
        CachedEntity.delete(path: cachedData.pathForUrl(urlString: key))
    }
    
    public static func deleteCaches(){
        let cachedData = CachedData.shared
        cachedData.clearCachesOnMemory()
        if FileManager.default.fileExists(atPath: cachedData.pathCacheDir){
            do{
                try FileManager.default.removeItem(atPath: cachedData.pathCacheDir)
                cachedData.makeTempDirs()
            }catch{
            }
        }
    }

}

