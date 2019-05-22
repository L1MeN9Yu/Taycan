//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

extension Transaction {
    public struct Flags: OptionSet {
        public let rawValue: Int32

        public init(rawValue: Int32) { self.rawValue = rawValue }

        public static let readOnly = Flags(rawValue: TAYCAN_RDONLY)
    }
}