/*
 * Created by Naeem Shaikh on 15/08/17.
 *
 * Copyright © 2017-present Naeem G Shaikh. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import Moya
import RealmSwift
import RxSwift
import ObjectMapper
import Moya_ObjectMapper

extension Response {
    func removeAPIWrappers() -> Response {
        guard let json = try? self.mapJSON() as? [[String: AnyObject]],
            let results = json,
            let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted) else {
                return self
        }
        
        let newResponse = Response(statusCode: self.statusCode,
                                   data: newData,
                                   response: self.response)
        return newResponse
    }
}

struct NetworkAPIManger {
    let provider: RxMoyaProvider<NetworkAPI>
    let disposeBag = DisposeBag()
    
    init() {
        provider = RxMoyaProvider<NetworkAPI>(stubClosure: RxMoyaProvider.immediatelyStub)
    }
}

extension NetworkAPIManger {
    fileprivate func requestArray<T: Mappable>(_ token: NetworkAPI, type: T.Type,
                                  completion: @escaping ([T]?) -> Void) {
        provider.request(token)
            .debug()
            .map { respose -> Response in
                return respose.removeAPIWrappers()
            }
            .mapArray(T.self)
            .subscribe { event -> Void in
                switch event {
                case .next(let parsedArray):
                    //self.saveOfflineData(parsedArray)
                    completion(parsedArray)
                case .error(let error):
                    print(error)
                    completion(nil)
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    fileprivate func saveOfflineData(_ parsedArray: Array<Any>) {
        do {
            let realm = try Realm()
            try realm.write {
                for element in parsedArray {
                    realm.add(element as! Object, update: true)
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
}

protocol NetworkAPICalls {
    func posts(completion: @escaping ([Post]?) -> Void)
}

extension NetworkAPIManger: NetworkAPICalls {
    func posts(completion: @escaping ([Post]?) -> Void) {
        requestArray(.posts(),
                     type: Post.self,
                     completion: completion)
    }
}
