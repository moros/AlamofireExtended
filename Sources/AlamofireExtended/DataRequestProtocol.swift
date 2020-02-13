//
//  File.swift
//  
//  Created by dmason on 2/11/20.
//

import Foundation
import Alamofire

/// Responsible for sending a request and receiving the response and associated data from the server, as well as
/// managing its underlying `URLSessionTask`.
public protocol RequestProtocol
{   
    /// The underlying task.
    var task: URLSessionTask? { get }
    
    /// The session belonging to the underlying task.
    var runningSession: URLSession? { get }
    
    /// The request sent or to be sent to the server.
    var request: URLRequest? { get }
    
    /// The response received from the server, if any.
    var response: HTTPURLResponse? { get }
    
    /// The number of times the request has been retried.
    var retryCount: UInt { get }
    
    /// The textual representation used when written to an output stream, which includes the HTTP method and URL, as
    /// well as the response status code if a response has been received.
    var description: String { get }
    
    /// The textual representation used when written to an output stream, in the form of a cURL command.
    var debugDescription: String { get }
    
    /// Associates an HTTP Basic credential with the request.
    ///
    /// - parameter user:           The user.
    /// - parameter password:       The password.
    /// - parameter persistence:    The URL credential persistence. `.ForSession` by default.
    ///
    /// - returns: The request.
    @discardableResult
    func authenticate(user: String, password: String, persistence: URLCredential.Persistence) -> Self
    
    /// Associates a specified credential with the request.
    ///
    /// - parameter credential: The credential.
    ///
    /// - returns: The request.
    @discardableResult
    func authenticate(usingCredential credential: URLCredential) -> Self
    
    /// Resumes the request
    func resume()
    
    /// Suspends the request.
    func suspend()
    
    /// Cancels the request.
    func cancel()
}

// MARK: -

public protocol DataRequestProtocol : RequestProtocol
{
    /// The progress of fetching the response data from the server for the request.
    var currentProgress: Progress? { get }
    
    /// Sets a closure to be called periodically during the lifecycle of the request as data is read from the server.
    ///
    /// This closure returns the bytes most recently received from the server, not including data from previous calls.
    /// If this closure is set, data will only be available within this closure, and will not be saved elsewhere. It is
    /// also important to note that the server data in any `Response` object will be `nil`.
    ///
    /// - parameter closure: The code to be executed periodically during the lifecycle of the request.
    ///
    /// - returns: The request.
    @discardableResult
    func stream(closure: ((Data) -> Void)?) -> Self
    
    /// Sets a closure to be called periodically during the lifecycle of the `Request` as data is read from the server.
    ///
    /// - parameter queue:   The dispatch queue to execute the closure on.
    /// - parameter closure: The code to be executed periodically as data is read from the server.
    ///
    /// - returns: The request.
    @discardableResult
    func downloadProgress(queue: DispatchQueue,
                          closure: @escaping Request.ProgressHandler) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func response(queue: DispatchQueue?,
                  completionHandler: @escaping (DefaultDataResponse) -> Void) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:              The queue on which the completion handler is dispatched.
    /// - parameter responseSerializer: The response serializer responsible for serializing the request, response,
    ///                                 and data.
    /// - parameter completionHandler:  The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func response<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue?,
        responseSerializer: T,
        completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void)
        -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func responseData(queue: DispatchQueue?,
                      completionHandler: @escaping (DataResponse<Data>) -> Void) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter encoding:          The string encoding. If `nil`, the string encoding will be determined from the
    ///                                server response, falling back to the default HTTP default character set,
    ///                                ISO-8859-1.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func responseString(queue: DispatchQueue?,
                        encoding: String.Encoding?,
                        completionHandler: @escaping (DataResponse<String>) -> Void) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func responseJSON(queue: DispatchQueue?,
                      options: JSONSerialization.ReadingOptions,
                      completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The property list reading options. Defaults to `[]`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func responsePropertyList(queue: DispatchQueue?,
                              options: PropertyListSerialization.ReadOptions,
                              completionHandler: @escaping (DataResponse<Any>) -> Void) -> Self
}

// MARK: -

public protocol DownloadRequestProtocol: RequestProtocol
{
    /// The resume data of the underlying download task if available after a failure.
    var resumeData: Data? { get }
    
    /// The progress of downloading the response data from the server for the request.
    var currentProgress: Progress? { get }
    
    /// Cancels the request.
    ///
    /// - parameter createResumeData: Determines whether resume data is created via the underlying download task or not.
    func cancel(createResumeData: Bool)
    
    /// Sets a closure to be called periodically during the lifecycle of the `Request` as data is read from the server.
    ///
    /// - parameter queue:   The dispatch queue to execute the closure on.
    /// - parameter closure: The code to be executed periodically as data is read from the server.
    ///
    /// - returns: The request.
    @discardableResult
    func downloadProgress(queue: DispatchQueue, closure: @escaping Request.ProgressHandler) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func response(queue: DispatchQueue?, completionHandler: @escaping (DefaultDownloadResponse) -> Void) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:              The queue on which the completion handler is dispatched.
    /// - parameter responseSerializer: The response serializer responsible for serializing the request, response,
    ///                                 and data contained in the destination url.
    /// - parameter completionHandler:  The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func response<T: DownloadResponseSerializerProtocol>(
        queue: DispatchQueue?,
        responseSerializer: T,
        completionHandler: @escaping (DownloadResponse<T.SerializedObject>) -> Void)
        -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func responseData(queue: DispatchQueue?,
                      completionHandler: @escaping (DownloadResponse<Data>) -> Void) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter encoding:          The string encoding. If `nil`, the string encoding will be determined from the
    ///                                server response, falling back to the default HTTP default character set,
    ///                                ISO-8859-1.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func responseString(queue: DispatchQueue?,
                        encoding: String.Encoding?,
                        completionHandler: @escaping (DownloadResponse<String>) -> Void) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func responseJSON(queue: DispatchQueue?,
                      options: JSONSerialization.ReadingOptions,
                      completionHandler: @escaping (DownloadResponse<Any>) -> Void) -> Self
    
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options:           The property list reading options. Defaults to `[]`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    func responsePropertyList(queue: DispatchQueue?,
                              options: PropertyListSerialization.ReadOptions,
                              completionHandler: @escaping (DownloadResponse<Any>) -> Void) -> Self
}

// MARK: -

public protocol UploadRequestProtocol: RequestProtocol
{
    /// Sets a closure to be called periodically during the lifecycle of the `UploadRequest` as data is sent to
    /// the server.
    ///
    /// After the data is sent to the server, the `progress(queue:closure:)` APIs can be used to monitor the progress
    /// of data being read from the server.
    ///
    /// - parameter queue:   The dispatch queue to execute the closure on.
    /// - parameter closure: The code to be executed periodically as data is sent to the server.
    ///
    /// - returns: The request.
    @discardableResult
    func uploadProgress(queue: DispatchQueue, closure: @escaping Request.ProgressHandler) -> Self
}

// MARK: -
// MARK: Extends protocols uses underlying methods from Alamofire

public extension RequestProtocol
{
    @discardableResult
    func authenticate(
        user: String,
        password: String,
        persistence: URLCredential.Persistence = .forSession)
        -> Self
    {
        return authenticate(user: user, password: password, persistence: persistence)
    }
    
    @discardableResult
    func authenticate(usingCredential credential: URLCredential) -> Self
    {
        return authenticate(usingCredential: credential)
    }
    
    func resume()
    {
        resume()
    }
    
    func suspend()
    {
        suspend()
    }
    
    func cancel()
    {
        cancel()
    }
}

public extension DataRequestProtocol
{
    @discardableResult
    func stream(closure: ((Data) -> Void)? = nil) -> Self
    {
        return stream(closure: closure)
    }
    
    @discardableResult
    func downloadProgress(queue: DispatchQueue = DispatchQueue.main,
                          closure: @escaping Request.ProgressHandler) -> Self
    {
        return downloadProgress(queue: queue, closure: closure)
    }
    
    @discardableResult
    func response(queue: DispatchQueue? = nil,
                  completionHandler: @escaping (DefaultDataResponse) -> Void) -> Self
    {
        return response(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func response<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T,
        completionHandler: @escaping (DataResponse<T.SerializedObject>) -> Void)
        -> Self
    {
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
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
}

public extension DownloadRequestProtocol
{
    func cancel(createResumeData: Bool)
    {
        cancel(createResumeData: createResumeData)
    }
    
    @discardableResult
    func downloadProgress(queue: DispatchQueue = DispatchQueue.main,
                          closure: @escaping Request.ProgressHandler) -> Self
    {
        return downloadProgress(queue: queue, closure: closure)
    }
    
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

// MARK: -
// MARK: Extends Alamofire's Request types with protocols

extension DataRequest: RequestProtocol, DataRequestProtocol
{
    public var runningSession: URLSession?
    {
        return self.session
    }
    
    public var currentProgress: Progress?
    {
        return self.progress
    }
}

extension DownloadRequest: RequestProtocol, DownloadRequestProtocol
{
    public var runningSession: URLSession?
    {
        return self.session
    }
    
    public var currentProgress: Progress?
    {
        return self.progress
    }
}

// UploadRequest inherits from DataRequest.
// Since we are making DataRequest conform to both RequestProtocol and DataRequestProtocol
//  UploadRequests extends from both in addition to UploadRequestProtocol.
extension UploadRequest: UploadRequestProtocol
{
}

#if !os(watchOS)

extension StreamRequest: RequestProtocol
{
    public var runningSession: URLSession?
    {
        return self.session
    }
}

#endif
