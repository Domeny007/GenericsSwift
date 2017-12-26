import Foundation

protocol WorkWithDataProtocol {
    
    func syncSaveObject<T : CanSaveProtocol>(with object: T)
    func asyncSaveObject<T : CanSaveProtocol>(with: T, completionBlock: @escaping (Bool) -> ())
    func syncGetAllObjects<T: CanSaveProtocol>() -> [T]?
    func asyncGetAllObjects<T:CanSaveProtocol>(completionBlock: @escaping ([T]?) -> ())
    func syncSearchObject<T:CanSaveProtocol>(id: Int, type: T.Type) -> T?
    func asyncSearchObject<T:CanSaveProtocol>(id: Int,type: T.Type, completionBlock: @escaping (T?) -> ())
}
