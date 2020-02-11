//
//  File.swift
//  
//  Created by dmason on 2/11/20.
//

import Foundation

public enum MultipartFormDataResult {
    case success(request: UploadRequestProtocol, streamingFromDisk: Bool, streamFileURL: URL?)
    case failure(Error)
}
