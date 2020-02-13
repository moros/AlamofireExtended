# AlamofireExtended

Extension to Alamofire that extends various classes with protocols.

Alamofire is an awesome HTTP networking library written in Swift but writting tests around code that uses 
concrete classes can be painful. 

Several of Alamofire's classes have been extended through the awesomeness of extensions:

1. SessionManager now conforms to a SessionManagerProtocol which returns a DataRequest protocol for each of the various request, download, and upload methods
2. SessionManagerProtocol defines all properties and methods that are public so taking a dependency of  `SessionManagerProtocol` should be just like taking a dependency of  `SessionManager`. Since Alamofire's session manager conforms to this new protocol, one can in an initializer default the dependency to some value like so `init(manager: SessionManagerProtocol = SessionManager.default)`
3. The various request types have been extended so that they too conform to protocols. Since the `DataRequest`, `DownloadRequest`, and `UploadRequest` types inherit from a `Request` type, there is a general `RequestProtocol`. 

    - `DataRequestProtocol` inherits from `RequestProtocol`
    - `DownloadRequestProtocol` inherits from `RequestProtocol` and `DownloadRequestProtocol`
    - `UploadRequestProtocol` just inherits from `RequestProtocol`
    
Alamofire's `DataRequest` inherits from their `Request` type, this type `DataRequest` now conforms to both `RequestProtocol` and `DataRequestProtocol`.
    
Alamofire's `DownloadRequest` inhierts from their `Request` type, this type `DownloadRequest` now conforms to both `RequestProtocol` and `DownloadRequestProtocol`.

Alamofire's `UploadRequest` inherits from their `DataRequest` type, this type `UploadRequest` now conforms to `UploadRequestProtocol`. Because the `DataRequest` type is conforming to `RequestProtocol`, `UploadRequest` indirectly conforms to the `RequestProtocol`.

## Package

This package can be used either with Swift Package Manager or CocoaPods. 

Supported OS versions:

- macOS(.v10_12),
- iOS(.v10),
- tvOS(.v10),
- watchOS(.v4)
