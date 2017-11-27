//
//  URLSessionFacade.swift
//  NumberPlace
//
//  Created by Hirono Momotaro on 2017/11/23.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import Foundation
import Unbox

public class URLSessionFacade
{
    static func post(url urlString: String, parameters: [String: Any]) {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let parametersString: String = parameters.enumerated().reduce("") { (input, tuple) -> String in
            switch tuple.element.value {
            case let int as Int: return input + tuple.element.key + "=" + String(int) + (parameters.count - 1 > tuple.offset ? "&" : "")
            case let string as String: return input + tuple.element.key + "=" + string + (parameters.count - 1 > tuple.offset ? "&" : "")
            default: return input
            }
        }
        
        request.httpBody = parametersString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response {
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                } catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }
        task.resume()
    }
    
    static func get(url urlString: String, queryItems: [URLQueryItem]? = nil){
        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        let url = compnents?.url
        let task = URLSession.shared.dataTask(with: url!){ data, response, error in
            if let data = data, let response = response {
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                } catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }
        
        task.resume()
    }
    
    private let session: URLSession
    
    public init(config: URLSessionConfiguration? = nil) {
        self.session = config.map { URLSession(configuration: $0) } ?? URLSession.shared
    }
    
    public func execute(request: URLRequest) -> (NSData?, URLResponse?, NSError?) {
        var d: NSData? = nil
        var r: URLResponse? = nil
        var e: NSError? = nil
        let semaphore = DispatchSemaphore(value: 0)
        session.dataTask(with: request) { (data, response, error) -> Void in
                d = data as NSData?
                r = response
                e = error as NSError?
                semaphore.signal()
            }
            .resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return (d, r, e)
    }
}

class HttpRequestController {
    let condition = NSCondition()
    
    /**
     GETリクエストを非同期で送信
     - Parameter urlString: String型のURL
     - Parameter funcs: 非同期で処置が完了した後に実行される関数
     */
    func sendGetRequestAsynchronous(urlString: String, funcs: @escaping ([String : Any]) -> Void){
        var parsedData: [String : Any] = [:]
        var encURL: NSURL = NSURL()
        encURL = NSURL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        var r: URLRequest = URLRequest(url: encURL as URL)
        r.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error == nil {
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
                } catch let error as NSError {
                    print(error)
                }
                
                funcs(parsedData)
            }
        }
        task.resume()
    }
    
    /**
     GETリクエストを同期で送信
     - Parameter urlString: String型のURL
     
     - Returns: String型のキーと、Any型の値を持ったDictionary型
     */
    func sendGetRequestSynchronous(urlString: String) -> [String : Any]{
        var parsedData: [String : Any] = [:]
        var encURL: NSURL = NSURL()
        encURL = NSURL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        var r = URLRequest(url: encURL as URL)
        r.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error == nil {
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
                } catch let error as NSError {
                    print(error)
                }
            }
            
            self.condition.signal()
            self.condition.unlock()
        }
        self.condition.lock()
        task.resume()
        self.condition.wait()
        self.condition.unlock()
        
        return parsedData
    }
    
    /**
     POSTリクエストを非同期で送信
     - Parameter urlString: String型のURL
     - Parameter post: String型のpost情報(key=value&key2=value2のように指定する)
     - Parameter funcs: 非同期で処置が完了した後に実行される関数
     */
    func sendPostRequestAsynchronous(urlString: String, post: String, funcs: @escaping ([String : Any]) -> Void){
        var parsedData: [String : Any] = [:]
        var encURL: NSURL = NSURL()
        encURL = NSURL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        var r = URLRequest(url: encURL as URL)
        r.httpMethod = "POST"
        r.httpBody = post.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error == nil {
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
                } catch let error as NSError {
                    print(error)
                }
            }
            funcs(parsedData)
        }
        task.resume()
    }
    
    /**
     POSTリクエストを同期で送信
     - Parameter urlString: String型のURL
     - Parameter post: String型のpost情報(key=value&key2=value2のように指定する)
     
     - Returns: String型のキーと、Any型の値を持ったDictionary型
     */
    func sendPostRequestSynchronous(urlString: String, post: String) -> [String : Any]{
        var parsedData: [String : Any] = [:]
        var encURL: NSURL = NSURL()
        encURL = NSURL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        var r = URLRequest(url: encURL as URL)
        r.httpMethod = "POST"
        r.httpBody = post.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: r) { (data, response, error) in
            
            if error == nil {
                do {
                    parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
                } catch let error as NSError {
                    print(error)
                }
            }
            
            self.condition.signal()
            self.condition.unlock()
        }
        self.condition.lock()
        task.resume()
        self.condition.wait()
        self.condition.unlock()
        
        return parsedData
    }
    
    /**
     画像読み込みを非同期で送信
     - Parameter urlString: String型のURL
     - Parameter funcs: 非同期で処置が完了した後に実行される関数
     */
    func sendImageRequestAsynchronous(urlString: String, funcs: @escaping (UIImage) -> Void){
        var encURL: NSURL = NSURL()
        encURL = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        let r = URLRequest(url: encURL as URL)
        NSURLConnection.sendAsynchronousRequest(r, queue:OperationQueue.main){(res, data, err) in
            let httpResponse = res as? HTTPURLResponse
            var image: UIImage = UIImage()
            if data != nil && httpResponse!.statusCode != 404 {
                image = UIImage(data: data!)!
            }
            //関数実行
            funcs(image)
        }
    }
    
    
}
