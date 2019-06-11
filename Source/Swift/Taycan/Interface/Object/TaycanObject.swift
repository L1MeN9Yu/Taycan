//
// Created by Mengyu Li on 2019-06-11.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

class TaycanObject {
    let pointer: OpaquePointer?

    init(dataConvertible: DataConvertible) {
        let keyPointer = dataConvertible.data.withUnsafeBytes { UnsafeMutableRawPointer(mutating: $0) }
        pointer = taycan_object_create(keyPointer, dataConvertible.data.count)
    }

    init(pointer: OpaquePointer?) {
        self.pointer = pointer
    }

    deinit {
        taycan_object_delete_pointer(pointer)
    }

    var data: UnsafeRawPointer? {
        return taycan_object_pointer_data(pointer)
    }

    var size: Int {
        return taycan_object_pointer_size(pointer)
    }
}
