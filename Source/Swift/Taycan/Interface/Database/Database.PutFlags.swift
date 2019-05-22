//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

extension Database {
    /// These flags can be passed when putting values into the database.
    public struct PutFlags: OptionSet {
        public let rawValue: Int32
        public init(rawValue: Int32) { self.rawValue = rawValue}

        public static let noDuplicateData = PutFlags(rawValue: TAYCAN_NODUPDATA)
        public static let noOverwrite = PutFlags(rawValue: TAYCAN_NOOVERWRITE)
        public static let reserve = PutFlags(rawValue: TAYCAN_RESERVE)
        public static let append = PutFlags(rawValue: TAYCAN_APPEND)
        public static let appendDuplicate = PutFlags(rawValue: TAYCAN_APPENDDUP)
    }
}