//
//  File.swift
//  
//  Created by dmason on 2/11/20.
//

import Foundation

/// Defines whether the `MultipartFormData` encoding was successful and contains result of the encoding as
/// associated values.
///
/// - Success: Represents a successful `MultipartFormData` encoding and contains the new `UploadRequest` along with
///            streaming information.
/// - Failure: Used to represent a failure in the `MultipartFormData` encoding and also contains the encoding
///            error.
public enum MultipartFormDataResult {
    case success(request: UploadRequestProtocol, streamingFromDisk: Bool, streamFileURL: URL?)
    case failure(Error)
}
