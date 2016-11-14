# Copyright (C) 2016 a1batross
# Licensed under WTFPL Public License

include(CMakeForceCompiler)

set(TIZEN TRUE)
set(TIZEN_SDK "$ENV{HOME}/tizen-sdk" CACHE STRING "Path to Tizen SDK")
set(TIZEN_PLATFORM "mobile" CACHE STRING "Target platform: tv, wearable, mobile")
set(TIZEN_API_VER "2.4" CACHE STRING "Target platform version: 2.3, 2.3.1 or 2.4")
set(TIZEN_ARCH "x86" CACHE STRING "Target architecture. arm for devices and x86 for emulator")
set(TIZEN_COMPILER_VER "4.9" CACHE STRING "Toolchain version")

# Latest SDK supports only ARM and x86. Itself, Tizen 3.0 have AArch64 and x86_64 support, but in the 
# end of 2016, Tizen SDK for 3.0 is not out yet. :(
if(TIZEN_ARCH STREQUAL "arm")
	set(TIZEN_TARGET "device")
	set(TIZEN_TRIPLET "arm-linux-gnueabi")
	set(CMAKE_SYSTEM_PROCESSOR ARM)
elseif(TIZEN_ARCH STREQUAL "x86")
	set(TIZEN_TARGET "emulator")
	set(TIZEN_TRIPLET "i386-linux-gnueabi")
	set(CMAKE_SYSTEM_PROCESSOR i686)
else()
	message(ERROR "This script supports only device for arm and emulator for x86 targets")
endif()

set(TIZEN_TOOLCHAIN "${TIZEN_SDK}/tools/${TIZEN_TRIPLET}-gcc-${TIZEN_COMPILER_VER}")

set(CMAKE_SYSROOT "${TIZEN_SDK}/platforms/tizen-${TIZEN_API_VER}/${TIZEN_PLATFORM}/rootstraps/${TIZEN_PLATFORM}-${TIZEN_API_VER}-${TIZEN_TARGET}.core/")
#message(${CMAKE_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(ENV{PKG_CONFIG_LIBDIR} ${CMAKE_SYSROOT}/usr/lib/pkgconfig/)  
set(PKG_CONFIG_USE_CMAKE_PREFIX_PATH 1)

set(CMAKE_SYSTEM_NAME "Linux")
set(CMAKE_C_COMPILER	"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-gcc")
set(CMAKE_CXX_COMPILER	"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-g++")
set(CMAKE_ASM			"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-as")
set(CMAKE_LINKER		"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-ld")
set(CMAKE_READELF		"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-readelf")
set(CMAKE_OBJDUMP		"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-objdump")
set(CMAKE_OBJCOPY		"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-objcopy")
set(CMAKE_SIZE			"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-size")
set(CMAKE_NM 			"${TIZEN_TOOLCHAIN}/bin/${TIZEN_TRIPLET}-nm")

set(CMAKE_C_COMPILER_TARGET ${TIZEN_TRIPLET})
set(CMAKE_CXX_COMPILER_TARGET ${TIZEN_TRIPLET})
set(CMAKE_EXE_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT}")

set(CMAKE_CROSSCOMPILING 1)

add_definitions("-DTIZEN -D__TIZEN__")

# Xash3D preferred settings
set(XASH_SDL OFF CACHE BOOLEAN "")
set(XASH_X11 OFF CACHE BOOLEAN "" )
set(XASH_VGUI OFF CACHE BOOLEAN "")
set(XASH_DLL_LOADER OFF CACHE BOOLEAN "")
set(XASH_GLES ON CACHE BOOLEAN "")
set(XASH_NANOGL ON CACHE BOOLEAN "")
set(XASH_SINGLE_BINARY ON CACHE BOOLEAN "")

