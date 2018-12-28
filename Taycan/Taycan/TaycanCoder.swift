//
// Created by Mengyu Li on 2018-12-28.
// Copyright (c) 2018 Limengyu. All rights reserved.
//

import Foundation

struct TaycanCoder {
    static let encoder = { () -> JSONEncoder in
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return encoder
    }()

    static let decoder = { () -> JSONDecoder in
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
}
