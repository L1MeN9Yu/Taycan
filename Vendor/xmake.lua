target("lmdb")
    set_kind("static")
    
    add_files("lmdb/libraries/liblmdb/mdb.c")
    add_files("lmdb/libraries/liblmdb/midl.c")

    add_headerfiles("lmdb/libraries/liblmdb/lmdb.h")