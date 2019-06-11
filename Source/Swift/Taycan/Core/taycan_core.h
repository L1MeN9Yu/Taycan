
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

int taycan_database_drop(const void *transaction, taycan_database_id database_id, int is_delete);

// Taycan Object
typedef struct taycan_object *taycan_object_ref;

taycan_object_ref taycan_object_create(const void *data, size_t size);

void taycan_object_delete_pointer(taycan_object_ref taycan_object);

size_t taycan_object_pointer_size(taycan_object_ref taycan_object);

const void *taycan_object_pointer_data(taycan_object_ref taycan_object);

// Key Value
int taycan_database_delete_value(const void *transaction, taycan_database_id database_id, taycan_object_ref key);

int taycan_database_put_value(const void *transaction, taycan_database_id database_id, taycan_object_ref key, taycan_object_ref value, unsigned int flags);

int taycan_database_get_value(const void *transaction, taycan_database_id database_id, taycan_object_ref key, taycan_object_ref *value);

// transaction

int taycan_transaction_begin(const void *environment, const void *parent_transaction, unsigned int flags, void **transaction);

int taycan_transaction_commit(const void *transaction);

void taycan_transaction_abort(const void *transaction);

#endif /* taycan_core_h */
