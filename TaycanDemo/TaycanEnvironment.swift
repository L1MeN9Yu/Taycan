//
// Created by Mengyu Li on 2018-12-29.
// Copyright (c) 2018 Limengyu. All rights reserved.
//

import Foundation
import Taycan

struct TaycanEnvironment {
    static func setup() {
        Taycan.setup(horn: self)
    }
}

extension TaycanEnvironment: Taycan.Horn {

}
