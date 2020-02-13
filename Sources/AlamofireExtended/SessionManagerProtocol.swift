//
//  File.swift
//  
//  Created by dmason on 2/11/20.
//

import Foundation
import Alamofire

/// Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
public protocol SessionManagerProtocol
{
    /// The underlying session.
    var runningSession: URLSession? { get }
    
    /// The session delegate handling all the task and session delegate callbacks.
    var delegate: SessionDelegate { get }
    
    /// Whether to start requests immediately after being constructed. `true` by default.
    var startRequestsImmediately: Bool { get set }
    
    /// The request adapter called each time a new request is created.
    var adapter: RequestAdapter? { get set }
    
    /// The request retrier called each time a request encounters an error to determine whether to retry the request.
    var retrier: RequestRetrier? { get set }
    
    /// The background completion handler closure provided by the UIApplicationDelegate
    /// `application:handleEventsForBackgroundURLSession:completionHandler:` method. By setting the background
    /// completion handler, the SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` closure implementation
    /// will automatically call the handler.
    ///
    /// If you need to handle your own events before the handler is called, then you need to override the
    /// SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` and manually call the handler when finished.
    ///
    /// `nil` by default.
    var backgroundCompletionHandler: (() -> Void)? { get set }
    
    /// Creates a `DataRequest` to retrieve the contents of the specified `url`, `method`, `parameters`, `encoding`
    /// and `headers`.
    ///
    /// - parameter url:        The URL.
    /// - parameter method:     The HTTP method. `.get` by default.
    /// - parameter parameters: The parameters. `nil` by default.
    /// - parameter encoding:   The parameter encoding. `URLEncoding.default` by default.
    /// - parameter headers:    The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `DataRequest`.
    @discardableResult
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?,
                 encoding: ParameterEncoding, headers: HTTPHeaders?)  -> DataRequestProtocol
    
    /// Creates a `DataRequest` to retrieve the contents of a URL based on the specified `urlRequest`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `DataRequest`.
    func request(_ urlRequest: URLRequestConvertible) -> DataRequestProtocol
    
    /// Creates a `DownloadRequest` to retrieve the contents the specified `url`, `method`, `parameters`, `encoding`,
    /// `headers` and save them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter url:         The URL.
    /// - parameter method:      The HTTP method. `.get` by default.
    /// - parameter parameters:  The parameters. `nil` by default.
    /// - parameter encoding:    The parameter encoding. `URLEncoding.default` by default.
    /// - parameter headers:     The HTTP headers. `nil` by default.
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    func download(_ url: URLConvertible,
                    method: HTTPMethod,
                    parameters: Parameters?,
                    encoding: ParameterEncoding,
                    headers: HTTPHeaders?,
                    to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol
    
    /// Creates a `DownloadRequest` to retrieve the contents of a URL based on the specified `urlRequest` and save
    /// them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter urlRequest:  The URL request
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    func download(_ urlRequest: URLRequestConvertible,
                    to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol
    
    /// Creates a `DownloadRequest` from the `resumeData` produced from a previous request cancellation to retrieve
    /// the contents of the original request and save them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// On the latest release of all the Apple platforms (iOS 10, macOS 10.12, tvOS 10, watchOS 3), `resumeData` is broken
    /// on background URL session configurations. There's an underlying bug in the `resumeData` generation logic where the
    /// data is written incorrectly and will always fail to resume the download. For more information about the bug and
    /// possible workarounds, please refer to the following Stack Overflow post:
    ///
    ///    - http://stackoverflow.com/a/39347461/1342462
    ///
    /// - parameter resumeData:  The resume data. This is an opaque data blob produced by `URLSessionDownloadTask`
    ///                          when a task is cancelled. See `URLSession -downloadTask(withResumeData:)` for
    ///                          additional information.
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    func download(resumingWith resumeData: Data,
                  to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol
    
    /// Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `file`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter file:    The file to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    func upload(_ fileURL: URL, to url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders?) -> UploadRequestProtocol
    
    /// Creates a `UploadRequest` from the specified `urlRequest` for uploading the `file`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter file:       The file to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    func upload(_ fileURL: URL, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    
    /// Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `data`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter data:    The data to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    func upload(_ data: Data, to url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders?) -> UploadRequestProtocol
    
    /// Creates an `UploadRequest` from the specified `urlRequest` for uploading the `data`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter data:       The data to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    func upload(_ data: Data, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    
    /// Creates an `UploadRequest` from the specified `url`, `method` and `headers` for uploading the `stream`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter stream:  The stream to upload.
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method. `.post` by default.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    func upload(_ stream: InputStream, to url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders?) -> UploadRequestProtocol
    
    /// Creates an `UploadRequest` from the specified `urlRequest` for uploading the `stream`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter stream:     The stream to upload.
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `UploadRequest`.
    @discardableResult
    func upload(_ stream: InputStream, with urlRequest: URLRequestConvertible) -> UploadRequestProtocol
    
    /// Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    /// `UploadRequest` using the `url`, `method` and `headers`.
    ///
    /// It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
    /// payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
    /// efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
    /// be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
    /// footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
    /// used for larger payloads such as video content.
    ///
    /// The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
    /// or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
    /// encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
    /// during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
    /// technique was used.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
    /// - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
    ///                                      `multipartFormDataEncodingMemoryThreshold` by default.
    /// - parameter url:                     The URL.
    /// - parameter method:                  The HTTP method. `.post` by default.
    /// - parameter headers:                 The HTTP headers. `nil` by default.
    /// - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
    func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64,
        to url: URLConvertible,
        method: HTTPMethod,
        headers: HTTPHeaders?,
        queue: DispatchQueue?,
        encodingCompletion: ((MultipartFormDataResult) -> Void)?)
    
    /// Encodes `multipartFormData` using `encodingMemoryThreshold` and calls `encodingCompletion` with new
    /// `UploadRequest` using the `urlRequest`.
    ///
    /// It is important to understand the memory implications of uploading `MultipartFormData`. If the cummulative
    /// payload is small, encoding the data in-memory and directly uploading to a server is the by far the most
    /// efficient approach. However, if the payload is too large, encoding the data in-memory could cause your app to
    /// be terminated. Larger payloads must first be written to disk using input and output streams to keep the memory
    /// footprint low, then the data can be uploaded as a stream from the resulting file. Streaming from disk MUST be
    /// used for larger payloads such as video content.
    ///
    /// The `encodingMemoryThreshold` parameter allows Alamofire to automatically determine whether to encode in-memory
    /// or stream from disk. If the content length of the `MultipartFormData` is below the `encodingMemoryThreshold`,
    /// encoding takes place in-memory. If the content length exceeds the threshold, the data is streamed to disk
    /// during the encoding process. Then the result is uploaded as data or as a stream depending on which encoding
    /// technique was used.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter multipartFormData:       The closure used to append body parts to the `MultipartFormData`.
    /// - parameter encodingMemoryThreshold: The encoding memory threshold in bytes.
    ///                                      `multipartFormDataEncodingMemoryThreshold` by default.
    /// - parameter urlRequest:              The URL request.
    /// - parameter encodingCompletion:      The closure called when the `MultipartFormData` encoding is complete.
    func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        usingThreshold encodingMemoryThreshold: UInt64,
        with urlRequest: URLRequestConvertible,
        queue: DispatchQueue?,
        encodingCompletion: ((MultipartFormDataResult) -> Void)?)

#if !os(watchOS)
    /// Creates a `StreamRequest` for bidirectional streaming using the `hostname` and `port`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter hostName: The hostname of the server to connect to.
    /// - parameter port:     The port of the server to connect to.
    ///
    /// - returns: The created `StreamRequest`.
    @discardableResult
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    func stream(withHostName hostName: String, port: Int) -> RequestProtocol
    
    /// Creates a `StreamRequest` for bidirectional streaming using the `netService`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter netService: The net service used to identify the endpoint.
    ///
    /// - returns: The created `StreamRequest`.
    @discardableResult
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    func stream(with netService: NetService) -> RequestProtocol
#endif
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
    
#if !os(watchOS)
    
    func stream(withHostName hostName: String, port: Int) -> RequestProtocol
    {
        return stream(withHostName: hostName, port: port)
    }
    
    func stream(with netService: NetService) -> RequestProtocol
    {
        return stream(with: netService)
    }
    
#endif
}

extension SessionManager: SessionManagerProtocol
{
    public var runningSession: URLSession?
    {
        return self.session
    }
    
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
    
#if !os(watchOS)
    
    public func stream(withHostName hostName: String, port: Int) -> RequestProtocol
    {
        let request: StreamRequest = stream(withHostName: hostName, port: port)
        return request as RequestProtocol
    }
    
    public func stream(with netService: NetService) -> RequestProtocol
    {
        let request: StreamRequest = stream(with: netService)
        return request as RequestProtocol
    }
    
#endif
}
