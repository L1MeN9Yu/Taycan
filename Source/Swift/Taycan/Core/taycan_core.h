
//
//  taycan_core.h
//  Taycan.Swift
//
//  Created by Mengyu Li on 2019-05-07.
//  Copyright © 2019 L1MeN9Yu. All rights reserved.
//

#ifndef taycan_core_h
#define taycan_core_h

#include <stdio.h>

// environment

// database

// transaction

int taycan_transaction_begin(void *environment, void *parent_transaction, unsigned int flags, void **transaction);

int taycan_transaction_commit(void *transaction);

void taycan_transaction_abort(void *transaction);

#endif /* taycan_core_h */
