//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

extension Database {
    public struct Flags: OptionSet {
        public let rawValue: Int32
        public init(rawValue: Int32) { self.rawValue = rawValue}

        public static let reverseKey = Flags(rawValue: TAYCAN_FIXEDMAP)
        public static let duplicateSort = Flags(rawValue: TAYCAN_NOSUBDIR)
        public static let integerKey = Flags(rawValue: TAYCAN_NOSYNC)
        public static let duplicateFixed = Flags(rawValue: TAYCAN_RDONLY)
        public static let integerDuplicate = Flags(rawValue: TAYCAN_NOMETASYNC)
        public static let reverseDuplicate = Flags(rawValue: TAYCAN_WRITEMAP)
        public static let create = Flags(rawValue: TAYCAN_CREATE)
    }
}