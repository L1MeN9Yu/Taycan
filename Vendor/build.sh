echo "build for all arch"
xmake m package -p iphoneos -f "--target_minver=8 --cxflags=\"-fembed-bitcode\" --mxflags=\"-fembed-bitcode\" --asflags=\"-fembed-bitcode\""

echo "copy to project"
cp build/lmdb.pkg/iphoneos/universal/lib/release/liblmdb.a ../Source/ExternalLibrary/lmdb/library/liblmdb.a
cp build/lmdb.pkg/iphoneos/arm64/include/lmdb.h ../Source/ExternalLibrary/lmdb/include/lmdb/lmdb.h

rm -r .xmake
rm -r build