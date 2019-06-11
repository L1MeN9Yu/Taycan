
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
typedef unsigned int taycan_database_id;

void taycan_database_close(const void *environment, taycan_database_id database_id);

int taycan_database_open(const void *transaction, const char *name, unsigned int flags, taycan_database_id *database_id);

// transaction

int taycan_transaction_begin(const void *environment, const void *parent_transaction, unsigned int flags, void **transaction);

int taycan_transaction_commit(const void *transaction);

void taycan_transaction_abort(const void *transaction);

#endif /* taycan_core_h */
