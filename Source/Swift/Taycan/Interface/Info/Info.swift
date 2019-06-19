//
// Created by Mengyu Li on 2019-06-19.
// Copyright (c) 2019 L1MeN9Yu. All rights reserved.
//

import Foundation

public final class Info {
    public static let versionInfo: String = {
        let versionInfo = String(cString: taycan_internal_version_info())
        return versionInfo
    }()
}
