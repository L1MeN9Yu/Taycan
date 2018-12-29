//
//  taycan_log.c
//  Taycan
//
//  Created by Mengyu Li on 2018-12-29.
//  Copyright © 2018 Limengyu. All rights reserved.
//

#include "taycan_log.h"
#include "unqlite.h"

void (*taycan_log_callback)(
        taycan_log_flag flag,
        const char *message,
        const char *file_name,
        const char *function,
        int line
);

void
config_log_callback(
        void (*log_callback)(
                taycan_log_flag flag,
                const char *message,
                const char *file_name,
                const char *function,
                int line
        )
) {
    taycan_log_callback = log_callback;
}

#define LOG_MAX_BUF_SIZE 512

void
taycan_core_log(
        taycan_log_flag flag,
        const char *file_name,
        const char *function,
        int line,
        const char *format, ...
) {
    if (taycan_log_callback) {
        static char buffer[LOG_MAX_BUF_SIZE];
        va_list args;
        va_start(args, format);
        vsnprintf(buffer, LOG_MAX_BUF_SIZE, format, args);
        va_end(args);
        taycan_log_callback(flag, buffer, file_name, function, line);
    }
}

const char *
taycan_core_message_form_return_code(
        int return_code
) {
    switch (return_code) {
        case UNQLITE_OK:
            return "Successful result";
        case UNQLITE_NOMEM:
            return "Out of memory";
        case UNQLITE_ABORT:
            return "Another thread have released this instance";
        case UNQLITE_IOERR:
            return "IO error";
        case UNQLITE_CORRUPT:
            return "Corrupt pointer";
        case UNQLITE_LOCKED:
            return "Forbidden Operation";
        case UNQLITE_BUSY:
            return "The database file is locked";
        case UNQLITE_DONE:
            return "Operation done";
        case UNQLITE_PERM:
            return "Permission error";
        case UNQLITE_NOTIMPLEMENTED:
            return "Method not implemented by the underlying Key/Value storage engine";
        case UNQLITE_NOTFOUND:
            return "No such record";
        case UNQLITE_NOOP:
            return "No such method";
        case UNQLITE_INVALID:
            return "Invalid parameter";
        case UNQLITE_EOF:
            return "End Of Input";
        case UNQLITE_UNKNOWN:
            return "Unknown configuration option";
        case UNQLITE_LIMIT:
            return "Database limit reached";
        case UNQLITE_EXISTS:
            return "Record exists";
        case UNQLITE_EMPTY:
            return "Empty record";
        case UNQLITE_COMPILE_ERR:
            return "Compilation error";
        case UNQLITE_VM_ERR:
            return "Virtual machine error";
        case UNQLITE_FULL:
            return "Full database (unlikely)";
        case UNQLITE_CANTOPEN:
            return "Unable to open the database file";
        case UNQLITE_READ_ONLY:
            return "Read only Key/Value storage engine";
        case UNQLITE_LOCKERR:
            return "Locking protocol error";
        default:
            return "unknown error";
    }
}

unsigned int
taycan_core_log_flag_form_return_code(
        int return_code
) {
    switch (return_code) {
        case UNQLITE_OK:
            return taycan_log_flag_trace;
        case UNQLITE_NOMEM:
            return taycan_log_flag_fatal_error;
        case UNQLITE_ABORT:
            return taycan_log_flag_fatal_error;
        case UNQLITE_IOERR:
            return taycan_log_flag_fatal_error;
        case UNQLITE_CORRUPT:
            return taycan_log_flag_fatal_error;
        case UNQLITE_LOCKED:
            return taycan_log_flag_fatal_error;
        case UNQLITE_BUSY:
            return taycan_log_flag_error;
        case UNQLITE_DONE:
            return taycan_log_flag_info;
        case UNQLITE_PERM:
            return taycan_log_flag_error;
        case UNQLITE_NOTIMPLEMENTED:
            return taycan_log_flag_error;
        case UNQLITE_NOTFOUND:
            return taycan_log_flag_info;
        case UNQLITE_NOOP:
            return taycan_log_flag_info;
        case UNQLITE_INVALID:
            return taycan_log_flag_error;
        case UNQLITE_EOF:
            return taycan_log_flag_warning;
        case UNQLITE_UNKNOWN:
            return taycan_log_flag_error;
        case UNQLITE_LIMIT:
            return taycan_log_flag_warning;
        case UNQLITE_EXISTS:
            return taycan_log_flag_info;
        case UNQLITE_EMPTY:
            return taycan_log_flag_warning;
        case UNQLITE_COMPILE_ERR:
            return taycan_log_flag_error;
        case UNQLITE_VM_ERR:
            return taycan_log_flag_error;
        case UNQLITE_FULL:
            return taycan_log_flag_error;
        case UNQLITE_CANTOPEN:
            return taycan_log_flag_error;
        case UNQLITE_READ_ONLY:
            return taycan_log_flag_error;
        case UNQLITE_LOCKERR:
            return taycan_log_flag_fatal_error;
        default:
            return taycan_log_flag_fatal_error;
    }
}