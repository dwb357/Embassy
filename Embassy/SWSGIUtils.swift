//
//  SWSGIUtils.swift
//  Embassy
//
//  Created by Fang-Pen Lin on 5/23/16.
//  Copyright © 2016 Fang-Pen Lin. All rights reserved.
//

import Foundation

// from http://stackoverflow.com/a/24052094/25077
/// Update one dictionay by another
private func +=<K, V> (inout left: [K: V], right: [K: V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

struct SWSGIUtils {
    /// Transform given request into environ dictionary
    static func environForRequest(request: HTTPRequest) -> [String: AnyObject] {
        var environ: [String: AnyObject] = [
            "REQUEST_METHOD": String(request.method),
            "SCRIPT_NAME": request.path,
            "PATH_INFO": request.path
        ]
        
        let queryParts = request.path.componentsSeparatedByString("?")
        if queryParts.count > 1 {
            environ["QUERY_STRING"] = queryParts[1..<queryParts.count].joinWithSeparator("?")
        }
        if let contentType = request.headers["Content-Type"] {
            environ["CONTENT_TYPE"] = contentType
        }
        if let contentLength = request.headers["Content-Length"] {
            environ["CONTENT_LENGTH"] = contentLength
        }
        environ += environForHeaders(request.rawHeaders)
        return environ
    }
    
    /// Transform given header key value pair array into environ style header map,
    /// like from Content-Length to HTTP_CONTENT_LENGTH
    static func environForHeaders(headers: [(String, String)]) -> [String: AnyObject] {
        var environ: [String: AnyObject] = [:]
        for (key, value) in headers {
            let key = "HTTP_" + key.uppercaseString.stringByReplacingOccurrencesOfString("-", withString: "_")
            environ[key] = value
        }
        return environ
    }
}
