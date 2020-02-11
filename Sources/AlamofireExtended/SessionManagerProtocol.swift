//
//  File.swift
//  
//  Created by dmason on 2/11/20.
//

import Foundation
import Alamofire

public protocol SessionManagerProtocol
{
    @discardableResult
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?,
                 encoding: ParameterEncoding, headers: HTTPHeaders?)  -> DataRequestProtocol
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequestProtocol
    
    @discardableResult
    func download(_ url: URLConvertible,
                    method: HTTPMethod,
                    parameters: Parameters?,
                    encoding: ParameterEncoding,
                    headers: HTTPHeaders?,
                    to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol
    
    @discardableResult
    func download(_ urlRequest: URLRequestConvertible,
                    to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol
    
    @discardableResult
    func download(resumingWith resumeData: Data,
                    to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol
    
    @discardableResult
    func upload(_ fileURL: URL, to url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders?) -> UploadRequestProtocol
    
    @discardableResult
    func upload(_ fileURL: URL, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    
    @discardableResult
    func upload(_ data: Data, to url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders?) -> UploadRequestProtocol
    
    @discardableResult
    func upload(_ data: Data, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    
    @discardableResult
    func upload(_ stream: InputStream, to url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders?) -> UploadRequestProtocol
    
    @discardableResult
    func upload(_ stream: InputStream, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    
    func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64,
        to url: URLConvertible,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        queue: DispatchQueue?,
        encodingCompletion: ((MultipartFormDataResult) -> Void)?)
    
    func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64,
        with urlRequest: URLRequestConvertible,
        queue: DispatchQueue?,
        encodingCompletion: ((MultipartFormDataResult) -> Void)?)
}

public extension SessionManagerProtocol
{
    @discardableResult
    func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil) -> DataRequestProtocol
    {
        return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    @discardableResult
    func download(_ url: URLConvertible,
                  method: HTTPMethod = .get,
                  parameters: Parameters? = nil,
                  encoding: ParameterEncoding = URLEncoding.default,
                  headers: HTTPHeaders? = nil,
                  to destination: DownloadRequest.DownloadFileDestination? = nil) -> DownloadRequestProtocol
    {
        return download(url, method: method, parameters: parameters, encoding: encoding, headers: headers, to: destination)
    }
    
    @discardableResult
    func download(_ urlRequest: URLRequestConvertible,
                  to destination: DownloadRequest.DownloadFileDestination? = nil) -> DownloadRequestProtocol
    {
        return download(urlRequest, to: destination)
    }
    
    @discardableResult
    func download(resumingWith resumeData: Data,
                  to destination: DownloadRequest.DownloadFileDestination? = nil) -> DownloadRequestProtocol
    {
        return download(resumingWith: resumeData, to: destination)
    }
    
    @discardableResult
    func upload(_ fileURL: URL, to url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders? = nil) -> UploadRequestProtocol
    {
        return upload(fileURL, to: url, method: method, headers: headers)
    }
    
    @discardableResult
    func upload(_ fileURL: URL, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    {
        return upload(fileURL, with: urlRequest)
    }
    
    @discardableResult
    func upload(_ data: Data, to url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders? = nil) -> UploadRequestProtocol
    {
        return upload(data, to: url, method: method, headers: headers)
    }
    
    @discardableResult
    func upload(_ data: Data, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    {
        return upload(data, with: urlRequest)
    }
    
    @discardableResult
    func upload(_ stream: InputStream, to url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders? = nil) -> UploadRequestProtocol
    {
        return upload(stream, to: url, method: method, headers: headers)
    }
    
    @discardableResult
    func upload(_ stream: InputStream, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    {
        return upload(stream, with: urlRequest)
    }
    
    func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil,
        queue: DispatchQueue? = nil,
        encodingCompletion: ((MultipartFormDataResult) -> Void)?)
    {
        return upload(
            multipartFormData: multipartFormData,
            usingThreshold: encodingMemoryThreshold,
            to: url,
            method: method,
            headers: headers,
            queue: queue,
            encodingCompletion: encodingCompletion
        )
    }
    
    func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
        with urlRequest: URLRequestConvertible,
        queue: DispatchQueue? = nil,
        encodingCompletion: ((MultipartFormDataResult) -> Void)?)
    {
        return upload(
            multipartFormData: multipartFormData,
            usingThreshold: encodingMemoryThreshold,
            with: urlRequest,
            queue: queue,
            encodingCompletion: encodingCompletion
        )
    }
}

extension SessionManager: SessionManagerProtocol
{
    @discardableResult
    public func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)  -> DataRequestProtocol
    {
        let dataRequest: DataRequest = request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        return dataRequest as DataRequestProtocol
    }
    
    public func request(_ urlRequest: URLRequestConvertible) -> DataRequestProtocol
    {
        let dataRequest: DataRequest = request(urlRequest)
        return dataRequest as DataRequestProtocol
    }
    
    @discardableResult
    public func download(_ url: URLConvertible,
                  method: HTTPMethod = .get,
                  parameters: Parameters? = nil,
                  encoding: ParameterEncoding = URLEncoding.default,
                  headers: HTTPHeaders? = nil,
                  to destination: DownloadRequest.DownloadFileDestination? = nil) -> DownloadRequestProtocol
    {
        let request: DownloadRequest = download(url, method: method, parameters: parameters, encoding: encoding, headers: headers, to: destination)
        return request as DownloadRequestProtocol
    }
    
    @discardableResult
    public func download(_ urlRequest: URLRequestConvertible,
                  to destination: DownloadRequest.DownloadFileDestination? = nil) -> DownloadRequestProtocol
    {
        let request: DownloadRequest = download(urlRequest, to: destination)
        return request as DownloadRequestProtocol
    }
    
    @discardableResult
    public func download(resumingWith resumeData: Data,
                  to destination: DownloadRequest.DownloadFileDestination? = nil) -> DownloadRequestProtocol
    {
        let request: DownloadRequest = download(resumingWith: resumeData, to: destination)
        return request as DownloadRequestProtocol
    }
    
    @discardableResult
    public func upload(_ fileURL: URL, to url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders? = nil) -> UploadRequestProtocol
    {
        let request: UploadRequest = upload(fileURL, to: url, method: method, headers: headers)
        return request as UploadRequestProtocol
    }
    
    @discardableResult
    public func upload(_ fileURL: URL, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    {
        let request: UploadRequest = upload(fileURL, with: urlRequest)
        return request as UploadRequestProtocol
    }
    
    @discardableResult
    public func upload(_ data: Data, to url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders? = nil) -> UploadRequestProtocol
    {
        let request: UploadRequest = upload(data, to: url, method: method, headers: headers)
        return request as UploadRequestProtocol
    }
    
    @discardableResult
    public func upload(_ data: Data, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    {
        let request: UploadRequest = upload(data, with: urlRequest)
        return request as UploadRequestProtocol
    }
    
    @discardableResult
    public func upload(_ stream: InputStream, to url: URLConvertible, method: HTTPMethod = .post, headers: HTTPHeaders? = nil) -> UploadRequestProtocol
    {
        let request: UploadRequest = upload(stream, to: url, method: method, headers: headers)
        return request as UploadRequestProtocol
    }
    
    @discardableResult
    public func upload(_ stream: InputStream, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    {
        let request: UploadRequest = upload(stream, with: urlRequest)
        return request as UploadRequestProtocol
    }
    
    public func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil,
        queue: DispatchQueue? = nil,
        encodingCompletion: ((MultipartFormDataResult) -> Void)?)
    {
        let callback: ((SessionManager.MultipartFormDataEncodingResult) -> Void) = { result in
            guard let completion = encodingCompletion else {
                return
            }
            
            let encodedResult: MultipartFormDataResult!
            switch result {
            case .success(let request, let fromDisk, let url):
                encodedResult = MultipartFormDataResult.success(
                    request: request as UploadRequestProtocol,
                    streamingFromDisk: fromDisk,
                    streamFileURL: url
                )
            case .failure(let error):
                encodedResult = MultipartFormDataResult.failure(error)
            }
            
            completion(encodedResult)
        }
        return upload(
            multipartFormData: multipartFormData,
            usingThreshold: encodingMemoryThreshold,
            to: url,
            method: method,
            headers: headers,
            queue: queue,
            encodingCompletion: callback
        )
    }
    
    public func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold,
        with urlRequest: URLRequestConvertible,
        queue: DispatchQueue? = nil,
        encodingCompletion: ((MultipartFormDataResult) -> Void)?)
    {
        let callback: ((SessionManager.MultipartFormDataEncodingResult) -> Void) = { result in
            guard let completion = encodingCompletion else {
                return
            }
            
            let encodedResult: MultipartFormDataResult!
            switch result {
            case .success(let request, let fromDisk, let url):
                encodedResult = MultipartFormDataResult.success(
                    request: request as UploadRequestProtocol,
                    streamingFromDisk: fromDisk,
                    streamFileURL: url
                )
            case .failure(let error):
                encodedResult = MultipartFormDataResult.failure(error)
            }
            
            completion(encodedResult)
        }
        return upload(
            multipartFormData: multipartFormData,
            usingThreshold: encodingMemoryThreshold,
            with: urlRequest,
            queue: queue,
            encodingCompletion: callback
        )
    }
}
