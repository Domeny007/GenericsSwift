import Foundation

class WorkWithData: WorkWithDataProtocol {
    
    
    func syncSaveObject<T>(with object: T) where T : CanSaveProtocol {
        object.mainID = Int(arc4random())
        let objectName = NSStringFromClass(T.self)
        if var objects:[T] = getData(key: objectName){
        objects.append(object)
        saveData(array: objects, key: objectName)
        } else {
            saveData(array: [object], key: objectName)
        }
    }
    
    func asyncSaveObject<T>(with object: T, completionBlock: @escaping (Bool) -> ()) where T : CanSaveProtocol {
            let queue = OperationQueue()
        queue.addOperation { [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.syncSaveObject(with: object)
            completionBlock(true)
           }
    }
    
    func syncGetAllObjects<T>() -> [T]? where T : CanSaveProtocol {
        let objectKey = NSStringFromClass(T.self)
        return getData(key: objectKey)
    }
    
    func asyncGetAllObjects<T>(completionBlock: @escaping ([T]?) -> ()) where T : CanSaveProtocol {
        let operationQueue = OperationQueue()
        operationQueue.addOperation { [weak self] in
            guard let strongSelf = self else{ return }
            completionBlock(strongSelf.syncGetAllObjects())
        }

    }
    
    func syncSearchObject<T>(id: Int, type: T.Type) -> T? where T : CanSaveProtocol {
        let objectKey = NSStringFromClass(type)
        let objects = getData(key: objectKey) ?? [T]()
        if objects.isEmpty {
            return nil
        }
        return objects.first(where: {$0.mainID == id})
    }
    
    func asyncSearchObject<T>(id: Int,type: T.Type, completionBlock: @escaping (T?) -> ()) where T : CanSaveProtocol {
        let operationQueue = OperationQueue()
        operationQueue.addOperation { [weak self] in
            guard let strongSelf = self else {return}
            completionBlock(strongSelf.syncSearchObject(id: id, type : type))
        }

    }
    
    func getData<T>(key: String) -> [T]? where T: CanSaveProtocol {
        if let data = UserDefaults.standard.data(forKey: key) {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [T]
        }
        return nil
    }
    func saveData<T: CanSaveProtocol> (array:[T], key: String ) {
        let data = NSKeyedArchiver.archivedData(withRootObject: array)
        UserDefaults.standard.set(data, forKey: key)
    }
}
