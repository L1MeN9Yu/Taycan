//
//  taycan_core_error.h
//  Taycan.Swift
//
//  Created by Mengyu Li on 2019-05-07.
//  Copyright © 2019 L1MeN9Yu. All rights reserved.
//

#ifndef taycan_core_error_h
#define taycan_core_error_h

#include <stdio.h>

// Error Code
extern const int TAYCAN_KEYEXIST;
extern const int TAYCAN_NOTFOUND;
extern const int TAYCAN_PAGE_NOTFOUND;
extern const int TAYCAN_CORRUPTED;
extern const int TAYCAN_PANIC;
extern const int TAYCAN_VERSION_MISMATCH;
extern const int TAYCAN_INVALID;
extern const int TAYCAN_MAP_FULL;
extern const int TAYCAN_DBS_FULL;
extern const int TAYCAN_READERS_FULL;
extern const int TAYCAN_TLS_FULL;
extern const int TAYCAN_TXN_FULL;
extern const int TAYCAN_CURSOR_FULL;
extern const int TAYCAN_PAGE_FULL;
extern const int TAYCAN_MAP_RESIZED;
extern const int TAYCAN_INCOMPATIBLE;
extern const int TAYCAN_BAD_RSLOT;
extern const int TAYCAN_BAD_TXN;
extern const int TAYCAN_BAD_VALSIZE;
extern const int TAYCAN_BAD_DBI;

// Environment/Database Flags
extern const int TAYCAN_FIXEDMAP;
extern const int TAYCAN_NOSUBDIR;
extern const int TAYCAN_NOSYNC;
extern const int TAYCAN_RDONLY;
extern const int TAYCAN_NOMETASYNC;
extern const int TAYCAN_WRITEMAP;
extern const int TAYCAN_MAPASYNC;
extern const int TAYCAN_NOTLS;
extern const int TAYCAN_NOLOCK;
extern const int TAYCAN_NORDAHEAD;
extern const int TAYCAN_NOMEMINIT;
extern const int TAYCAN_CREATE;
extern const int TAYCAN_NODUPDATA;
extern const int TAYCAN_NOOVERWRITE;
extern const int TAYCAN_RESERVE;
extern const int TAYCAN_APPEND;
extern const int TAYCAN_APPENDDUP;
#endif /* taycan_core_error_h */
