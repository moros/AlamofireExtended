//
//  File.swift
//  
//  Created by dmason on 2/11/20.
//

import Foundation
import Alamofire

public protocol DataRequestProtocol
{
    // Response Handler - Unserialized Response
    @discardableResult
    func response(queue: DispatchQueue?,
                  completionHandler: @escaping (DefaultDataResponse) -> Void) -> Self
    
    // Response Data Handler - Serialized into Data
    @discardableResult
    func responseData(queue: DispatchQueue?,
                      completionHandler: @escaping (DataResponse<Data>) -> Void) -> Self
    
    // Response String Handler - Serialized into String
    @discardableResult
    func responseString(queue: DispatchQueue?,
                        encoding: String.Encoding?,
                        completionHandler: @escaping (DataResponse<String>) -> Void) -> Self
    
    // Response JSON Handler - Serialized into Any
    @discardableResult
    func responseJSON(queue: DispatchQueue?,
                      options: JSONSerialization.ReadingOptions,
                      completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self
    
    // Response PropertyList (plist) Handler - Serialized into Any
    @discardableResult
    func responsePropertyList(queue: DispatchQueue?,
                              options: PropertyListSerialization.ReadOptions,
                              completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self
    
    func cancel()
    
    @discardableResult
    func downloadProgress(queue: DispatchQueue,
                          closure: @escaping Request.ProgressHandler) -> Self
}

public protocol DownloadRequestProtocol: DataRequestProtocol
{
    @discardableResult
    func response(queue: DispatchQueue?, completionHandler: @escaping (DefaultDownloadResponse) -> Void) -> Self
    
    @discardableResult
    func responseData(queue: DispatchQueue?,
                      completionHandler: @escaping (DownloadResponse<Data>) -> Void) -> Self
    
    @discardableResult
    func responseString(queue: DispatchQueue?,
                        encoding: String.Encoding?,
                        completionHandler: @escaping (DownloadResponse<String>) -> Void) -> Self
    
    @discardableResult
    func responseJSON(queue: DispatchQueue?,
                      options: JSONSerialization.ReadingOptions,
                      completionHandler: @escaping (DownloadResponse<Any>) -> Void) -> Self
    
    @discardableResult
    func responsePropertyList(queue: DispatchQueue?,
                              options: PropertyListSerialization.ReadOptions,
                              completionHandler: @escaping (DownloadResponse<Any>) -> Void) -> Self
}

public protocol UploadRequestProtocol: DataRequestProtocol
{
    @discardableResult
    func uploadProgress(queue: DispatchQueue, closure: @escaping Request.ProgressHandler) -> Self
}

public extension DataRequestProtocol
{
    @discardableResult
    func response(queue: DispatchQueue? = nil,
                  completionHandler: @escaping (DefaultDataResponse) -> Void) -> Self
    {
        return response(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseData(queue: DispatchQueue? = nil,
                      completionHandler: @escaping (DataResponse<Data>) -> Void) -> Self
    {
        return responseData(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseString(queue: DispatchQueue? = nil,
                        encoding: String.Encoding? = nil,
                        completionHandler: @escaping (DataResponse<String>) -> Void) -> Self
    {
        return responseString(queue: queue, encoding: encoding, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseJSON(queue: DispatchQueue? = nil,
                      options: JSONSerialization.ReadingOptions = .allowFragments,
                      completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self
    {
        return responseJSON(queue: queue, options: options, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responsePropertyList(queue: DispatchQueue? = nil,
                              options: PropertyListSerialization.ReadOptions = [],
                              completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self
    {
        return responsePropertyList(queue: queue, options: options, completionHandler: completionHandler)
    }
    
    @discardableResult
    func downloadProgress(queue: DispatchQueue = DispatchQueue.main,
                          closure: @escaping Request.ProgressHandler) -> Self
    {
        return downloadProgress(queue: queue, closure: closure)
    }
}

public extension DownloadRequestProtocol
{
    @discardableResult
    func response(queue: DispatchQueue? = nil, completionHandler: @escaping (DefaultDownloadResponse) -> Void) -> Self
    {
        return response(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseData(queue: DispatchQueue? = nil,
                      completionHandler: @escaping (DownloadResponse<Data>) -> Void) -> Self
    {
        return responseData(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseString(queue: DispatchQueue? = nil,
                        encoding: String.Encoding? = nil,
                        completionHandler: @escaping (DownloadResponse<String>) -> Void) -> Self
    {
        return responseString(queue: queue, encoding: encoding, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseJSON(queue: DispatchQueue? = nil,
                      options: JSONSerialization.ReadingOptions = .allowFragments,
                      completionHandler: @escaping (DownloadResponse<Any>) -> Void) -> Self
    {
        return responseJSON(queue: queue, options: options, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responsePropertyList(queue: DispatchQueue? = nil,
                              options: PropertyListSerialization.ReadOptions = [],
                              completionHandler: @escaping (DownloadResponse<Any>) -> Void) -> Self
    {
        return responsePropertyList(queue: queue, options: options, completionHandler: completionHandler)
    }
}

public extension UploadRequestProtocol
{
    @discardableResult
    func uploadProgress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping Request.ProgressHandler) -> Self
    {
        return uploadProgress(queue: queue, closure: closure)
    }
}

extension DataRequest: DataRequestProtocol
{
}

extension DownloadRequest: DownloadRequestProtocol
{
}

extension UploadRequest: UploadRequestProtocol
{
}
