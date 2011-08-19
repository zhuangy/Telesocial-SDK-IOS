xcodebuild -configuration Release -target TelesocialSDK -sdk iphoneos4.3 "ARCHS=armv6 armv7" clean build || { exit 1; }
xcodebuild -configuration Release -target TelesocialSDK -sdk iphonesimulator4.3 "ARCHS=i386 x86_64" "VALID_ARCHS=i386 x86_64" clean build || { exit 1; }


BASEDIR=$(dirname $0)
DEST=build/TelesocialSDK
rm -r $BASEDIR/$DEST
mkdir $BASEDIR/$DEST

lipo -output $DEST/libTelesocialSDK.a -create build/Release-iphoneos/libTelesocialSDK.a build/Release-iphonesimulator/libTelesocialSDK.a || { exit 1; }
cp TelesocialSDK.h TSMediaInfo.h TSRestClient.h TSRestClientDelegate.h TSStatus.h $DEST
echo "*** PACKAGE IS READY ***"
