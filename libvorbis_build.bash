# Config
IDZ_VORBIS_VERSION=1.3.5
IDZ_OGG_VERSION=$IDZ_OGG_VERSION

#Update IDZ_IOS_SDK_VERSION to the version available on your mac
#Run xcodebuild -showsdks to see the iOS version availanle on your mac
xcodebuild -showsdks

IDZ_IOS_SDK_VERSION=9.3

pushd $IDZ_BUILD_ROOT

mkdir -p libvorbis/$IDZ_VORBIS_VERSION
pushd libvorbis/$IDZ_VORBIS_VERSION
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-$IDZ_VORBIS_VERSION.tar.gz
tar xvfz libvorbis-$IDZ_VORBIS_VERSION.tar.gz

# Phone builds
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/$IDZ_OGG_VERSION/install-iPhoneOS-armv7
idz_configure armv7 $IDZ_IOS_SDK_VERSION libvorbis-$IDZ_VORBIS_VERSION/configure
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/$IDZ_OGG_VERSION/install-iPhoneOS-armv7s
idz_configure armv7s $IDZ_IOS_SDK_VERSION libvorbis-$IDZ_VORBIS_VERSION/configure
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/$IDZ_OGG_VERSION/install-iPhoneOS-arm64
idz_configure arm64 $IDZ_IOS_SDK_VERSION libvorbis-$IDZ_VORBIS_VERSION/configure

# Simulator build
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/$IDZ_OGG_VERSION/install-iPhoneSimulator-i386
idz_configure i386 $IDZ_IOS_SDK_VERSION libvorbis-$IDZ_VORBIS_VERSION/configure
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg=$IDZ_BUILD_ROOT/libogg/$IDZ_OGG_VERSION/install-iPhoneSimulator-x86_64
idz_configure x86_64 $IDZ_IOS_SDK_VERSION libvorbis-$IDZ_VORBIS_VERSION/configure

# Combine libraries
pushd install-iPhoneOS-armv7/lib
idz_combine libvorbisall.a *.a
popd
pushd install-iPhoneOS-armv7s/lib
idz_combine libvorbisall.a *.a
popd
pushd install-iPhoneOS-arm64/lib
idz_combine libvorbisall.a *.a
popd
pushd install-iPhoneSimulator-i386/lib
idz_combine libvorbisall.a *.a
popd
pushd install-iPhoneSimulator-x86_64/lib
idz_combine libvorbisall.a *.a
popd

# Create pseudo-framework
idz_fw Vorbis libvorbisall.a install-iPhoneSimulator-i386/include/vorbis

# Back to where we started!
popd
