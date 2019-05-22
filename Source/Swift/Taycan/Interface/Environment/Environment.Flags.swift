//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

extension Environment {
    public struct Flags: OptionSet {
        public let rawValue: Int32
        public init(rawValue: Int32) { self.rawValue = rawValue}

        public static let fixedMap = Flags(rawValue: TAYCAN_FIXEDMAP)
        public static let noSubDir = Flags(rawValue: TAYCAN_NOSUBDIR)
        public static let noSync = Flags(rawValue: TAYCAN_NOSYNC)
        public static let readOnly = Flags(rawValue: TAYCAN_RDONLY)
        public static let noMetaSync = Flags(rawValue: TAYCAN_NOMETASYNC)
        public static let writeMap = Flags(rawValue: TAYCAN_WRITEMAP)
        public static let mapAsync = Flags(rawValue: TAYCAN_MAPASYNC)
        public static let noTLS = Flags(rawValue: TAYCAN_NOTLS)
        public static let noLock = Flags(rawValue: TAYCAN_NOLOCK)
        public static let noReadahead = Flags(rawValue: TAYCAN_NORDAHEAD)
        public static let noMemoryInit = Flags(rawValue: TAYCAN_NOMEMINIT)
    }
}