//
// Created by Mengyu Li on 2019-05-07.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

public enum TaycanError: Error {

    // LMDB defined errors.
    case keyExists
    case notFound
    case pageNotFound
    case corrupted
    case panic
    case versionMismatch
    case invalid
    case mapFull
    case dbsFull
    case readersFull
    case tlsFull
    case txnFull
    case cursorFull
    case pageFull
    case mapResized
    case incompatible
    case badReaderSlot
    case badTransaction
    case badValueSize
    case badDBI

    // OS errors
    case invalidParameter
    case outOfDiskSpace
    case outOfMemory
    case ioError
    case accessViolation

    case other(returnCode: Int32)

    init(returnCode: Int32) {

        switch returnCode {
        case TAYCAN_KEYEXIST:
            self = .keyExists
        case TAYCAN_NOTFOUND:
            self = .notFound
        case TAYCAN_PAGE_NOTFOUND:
            self = .pageNotFound
        case TAYCAN_CORRUPTED:
            self = .corrupted
        case TAYCAN_PANIC:
            self = .panic
        case TAYCAN_VERSION_MISMATCH:
            self = .versionMismatch
        case TAYCAN_INVALID:
            self = .invalid
        case TAYCAN_MAP_FULL:
            self = .mapFull
        case TAYCAN_DBS_FULL:
            self = .dbsFull
        case TAYCAN_READERS_FULL:
            self = .readersFull
        case TAYCAN_TLS_FULL:
            self = .tlsFull
        case TAYCAN_TXN_FULL:
            self = .txnFull
        case TAYCAN_CURSOR_FULL:
            self = .cursorFull
        case TAYCAN_PAGE_FULL:
            self = .pageFull
        case TAYCAN_MAP_RESIZED:
            self = .mapResized
        case TAYCAN_INCOMPATIBLE:
            self = .incompatible
        case TAYCAN_BAD_RSLOT:
            self = .badReaderSlot
        case TAYCAN_BAD_TXN:
            self = .badTransaction
        case TAYCAN_BAD_VALSIZE:
            self = .badValueSize
        case TAYCAN_BAD_DBI:
            self = .badDBI

        case EINVAL:
            self = .invalidParameter
        case ENOSPC:
            self = .outOfDiskSpace
        case ENOMEM:
            self = .outOfMemory
        case EIO:
            self = .ioError
        case EACCES:
            self = .accessViolation

        default: self = .other(returnCode: returnCode)
        }
    }
}
