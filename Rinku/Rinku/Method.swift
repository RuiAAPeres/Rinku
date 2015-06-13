//
//  Method.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2015.
//  Copyright © 2015 Aphely. All rights reserved.
//

import Foundation

public enum Method: String { // Stolen from chriseidhof/github-issues
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}