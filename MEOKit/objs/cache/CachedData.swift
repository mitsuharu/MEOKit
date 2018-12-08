//
//  CachedData.swift
//  MEOKit
//
//  Created by Mitsuhau Emoto on 2018/12/08.
//  Copyright © 2018 Mitsuharu Emoto. All rights reserved.
//

import UIKit

public enum CachedValidity: Int{
    case oneweek
    case oneday
}

public enum CachedImageFormat: Int{
    case jpg
    case png
}

// キャッシュデータ
public class CachedData: NSObject, NSCoding {
    
    public var data: Data!{
        didSet{
            self.updatedAt = Date()
        }
    }
    var uuid: String = NSUUID().uuidString
    public var imageFormat: CachedImageFormat = .jpg
    public var validity: CachedValidity = .oneweek
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var expiredAt: Date{
        get{
            return self.calcExpiredAt()
        }
    }
    var filePath: String? = nil
    
    public override init() {
        super.init()
    }
    
    public convenience init(data: Data, validity: CachedValidity = .oneweek){
        self.init()
        self.validity = validity
        self.data = data
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.data, forKey: "data")
        aCoder.encode(self.uuid, forKey: "uuid")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
        aCoder.encode(self.validity, forKey: "validity")
        aCoder.encode(self.imageFormat, forKey: "imageFormat")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.data = (aDecoder.decodeObject(forKey: "data") as! Data)
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as! String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as! Date
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as! Date
        self.validity = aDecoder.decodeObject(forKey: "validity") as! CachedValidity
        self.imageFormat = aDecoder.decodeObject(forKey: "imageFormat") as! CachedImageFormat
    }
    
    // 画像入出力
    public var image: UIImage?{
        get{
            guard let temp = self.data else {
                return nil
            }
            return UIImage(data: temp)
        }
        set(input){
            if let p:UIImage = input{
                var temp: Data? = nil
                switch self.imageFormat{
                case .jpg:
                    temp = p.jpegData(compressionQuality: 1.0)
                case .png:
                    temp = p.pngData()
                }
                if let d = temp{
                    self.data = d
                }
            }
        }
    }
    
    // 文字入出力
    public var string: String?{
        get{
            guard let temp = self.data else {
                return nil
            }
            return String(data: temp,
                          encoding: String.Encoding.unicode)
        }
        set(input){
            if let p:String = input,
                let d = p.data(using: String.Encoding.unicode){
                self.data = d
            }
        }
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let temp:CachedData = object as? CachedData  else {
            return false
        }
        return (self.uuid == temp.uuid)
    }
    
    // 有効期限の更新
    func calcExpiredAt() -> Date{
        var timeInterval: TimeInterval = 0.0
        let oneDaySec: TimeInterval = 86400.0
        switch self.validity {
        case .oneweek:
            timeInterval = oneDaySec*7.0
        case .oneday:
            timeInterval = oneDaySec
        }
        return Date(timeInterval: timeInterval, since: self.updatedAt)
    }
}


public extension CachedData{
    
    @discardableResult func write(path: String) -> Bool{
        if #available(iOS 12, *){
            if let archive = try? NSKeyedArchiver.archivedData(withRootObject: self,
                                                               requiringSecureCoding: false){
                do{
                    try archive.write(to: URL(string: path)!)
                    return true
                }catch {
                    return false
                }
            }else{
                return false
            }
        }else{
            return NSKeyedArchiver.archiveRootObject(self,
                                                     toFile: path)
        }
    }
    
    static func load(path: String) -> CachedData?{
        
        var obj: Any? = nil
        if #available(iOS 12, *){
            if let nsData = NSData(contentsOfFile: path) {
                let data = Data(referencing:nsData)
                do{
                    obj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                }catch{
                    return nil
                }
            }
        }else{
            obj = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        }
        
        var cache: CachedData? = nil
        if obj is CachedData{
            cache = (obj as! CachedData)
            cache?.filePath = path
            if let expiredAt = cache?.expiredAt{
                if expiredAt > Date(){
                    cache = nil
                    obj = nil
                    CachedData.delete(path: path)
                }
            }
        }
        return cache
    }
    
    @discardableResult static func delete(path: String) -> Bool{
        do {
            try FileManager.default.removeItem(at: URL(string: path)!)
            return true
        } catch {
            return false
        }
    }
}
