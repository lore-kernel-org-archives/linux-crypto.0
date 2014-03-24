From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 03/21] staging: crypto: skein: remove brg_*.h includes
Date: Mon, 24 Mar 2014 01:49:00 +0000
Message-ID: <8865adec68720a2fc41fd0838f8a9eeb8f42231d.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32927 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbaCXBth (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:37 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/brg_endian.h | 148 -----------------------------
 drivers/staging/skein/include/brg_types.h  | 131 -------------------------
 drivers/staging/skein/include/skein_port.h |   6 +-
 3 files changed, 2 insertions(+), 283 deletions(-)
 delete mode 100644 drivers/staging/skein/include/brg_endian.h
 delete mode 100644 drivers/staging/skein/include/brg_types.h

diff --git a/drivers/staging/skein/include/brg_endian.h b/drivers/staging/skein/include/brg_endian.h
deleted file mode 100644
index c03c7c5d1eb4..000000000000
--- a/drivers/staging/skein/include/brg_endian.h
+++ /dev/null
@@ -1,148 +0,0 @@
-/*
- ---------------------------------------------------------------------------
- Copyright (c) 2003, Dr Brian Gladman, Worcester, UK.   All rights reserved.
-
- LICENSE TERMS
-
- The free distribution and use of this software in both source and binary
- form is allowed (with or without changes) provided that:
-
-   1. distributions of this source code include the above copyright
-      notice, this list of conditions and the following disclaimer;
-
-   2. distributions in binary form include the above copyright
-      notice, this list of conditions and the following disclaimer
-      in the documentation and/or other associated materials;
-
-   3. the copyright holder's name is not used to endorse products
-      built using this software without specific written permission.
-
- ALTERNATIVELY, provided that this notice is retained in full, this product
- may be distributed under the terms of the GNU General Public License (GPL),
- in which case the provisions of the GPL apply INSTEAD OF those given above.
-
- DISCLAIMER
-
- This software is provided 'as is' with no explicit or implied warranties
- in respect of its properties, including, but not limited to, correctness
- and/or fitness for purpose.
- ---------------------------------------------------------------------------
- Issue 20/10/2006
-*/
-
-#ifndef BRG_ENDIAN_H
-#define BRG_ENDIAN_H
-
-#define IS_BIG_ENDIAN      4321 /* byte 0 is most significant (mc68k) */
-#define IS_LITTLE_ENDIAN   1234 /* byte 0 is least significant (i386) */
-
-/* Include files where endian defines and byteswap functions may reside */
-#if defined( __FreeBSD__ ) || defined( __OpenBSD__ ) || defined( __NetBSD__ )
-#  include <sys/endian.h>
-#elif defined( BSD ) && ( BSD >= 199103 ) || defined( __APPLE__ ) || \
-      defined( __CYGWIN32__ ) || defined( __DJGPP__ ) || defined( __osf__ )
-#  include <machine/endian.h>
-#elif defined( __linux__ ) || defined( __GNUC__ ) || defined( __GNU_LIBRARY__ )
-#  if !defined( __MINGW32__ ) && !defined(AVR)
-#    include <endian.h>
-#    if !defined( __BEOS__ )
-#      include <byteswap.h>
-#    endif
-#  endif
-#endif
-
-/* Now attempt to set the define for platform byte order using any  */
-/* of the four forms SYMBOL, _SYMBOL, __SYMBOL & __SYMBOL__, which  */
-/* seem to encompass most endian symbol definitions                 */
-
-#if defined( BIG_ENDIAN ) && defined( LITTLE_ENDIAN )
-#  if defined( BYTE_ORDER ) && BYTE_ORDER == BIG_ENDIAN
-#    define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#  elif defined( BYTE_ORDER ) && BYTE_ORDER == LITTLE_ENDIAN
-#    define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#  endif
-#elif defined( BIG_ENDIAN )
-#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#elif defined( LITTLE_ENDIAN )
-#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#endif
-
-#if defined( _BIG_ENDIAN ) && defined( _LITTLE_ENDIAN )
-#  if defined( _BYTE_ORDER ) && _BYTE_ORDER == _BIG_ENDIAN
-#    define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#  elif defined( _BYTE_ORDER ) && _BYTE_ORDER == _LITTLE_ENDIAN
-#    define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#  endif
-#elif defined( _BIG_ENDIAN )
-#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#elif defined( _LITTLE_ENDIAN )
-#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#endif
-
-#if defined( __BIG_ENDIAN ) && defined( __LITTLE_ENDIAN )
-#  if defined( __BYTE_ORDER ) && __BYTE_ORDER == __BIG_ENDIAN
-#    define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#  elif defined( __BYTE_ORDER ) && __BYTE_ORDER == __LITTLE_ENDIAN
-#    define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#  endif
-#elif defined( __BIG_ENDIAN )
-#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#elif defined( __LITTLE_ENDIAN )
-#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#endif
-
-#if defined( __BIG_ENDIAN__ ) && defined( __LITTLE_ENDIAN__ )
-#  if defined( __BYTE_ORDER__ ) && __BYTE_ORDER__ == __BIG_ENDIAN__
-#    define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#  elif defined( __BYTE_ORDER__ ) && __BYTE_ORDER__ == __LITTLE_ENDIAN__
-#    define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#  endif
-#elif defined( __BIG_ENDIAN__ )
-#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#elif defined( __LITTLE_ENDIAN__ )
-#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#endif
-
-/*  if the platform byte order could not be determined, then try to */
-/*  set this define using common machine defines                    */
-#if !defined(PLATFORM_BYTE_ORDER)
-
-#if   defined( __alpha__ ) || defined( __alpha ) || defined( i386 )       || \
-      defined( __i386__ )  || defined( _M_I86 )  || defined( _M_IX86 )    || \
-      defined( __OS2__ )   || defined( sun386 )  || defined( __TURBOC__ ) || \
-      defined( vax )       || defined( vms )     || defined( VMS )        || \
-      defined( __VMS )     || defined( _M_X64 )  || defined( AVR )
-#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-
-#elif defined( AMIGA )   || defined( applec )    || defined( __AS400__ )  || \
-      defined( _CRAY )   || defined( __hppa )    || defined( __hp9000 )   || \
-      defined( ibm370 )  || defined( mc68000 )   || defined( m68k )       || \
-      defined( __MRC__ ) || defined( __MVS__ )   || defined( __MWERKS__ ) || \
-      defined( sparc )   || defined( __sparc)    || defined( SYMANTEC_C ) || \
-      defined( __VOS__ ) || defined( __TIGCC__ ) || defined( __TANDEM )   || \
-      defined( THINK_C ) || defined( __VMCMS__ )
-#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-
-#elif 0     /* **** EDIT HERE IF NECESSARY **** */
-#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#elif 0     /* **** EDIT HERE IF NECESSARY **** */
-#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
-#else
-#  error Please edit lines 126 or 128 in brg_endian.h to set the platform byte order
-#endif
-#endif
-
-/* special handler for IA64, which may be either endianness (?)  */
-/* here we assume little-endian, but this may need to be changed */
-#if defined(__ia64) || defined(__ia64__) || defined(_M_IA64)
-#  define PLATFORM_MUST_ALIGN (1)
-#ifndef PLATFORM_BYTE_ORDER
-#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
-#endif
-#endif
-
-#ifndef   PLATFORM_MUST_ALIGN
-#  define PLATFORM_MUST_ALIGN (0)
-#endif
-
-#endif  /* ifndef BRG_ENDIAN_H */
diff --git a/drivers/staging/skein/include/brg_types.h b/drivers/staging/skein/include/brg_types.h
deleted file mode 100644
index 3d9fe0df5238..000000000000
--- a/drivers/staging/skein/include/brg_types.h
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- ---------------------------------------------------------------------------
- Copyright (c) 1998-2006, Brian Gladman, Worcester, UK. All rights reserved.
-
- LICENSE TERMS
-
- The free distribution and use of this software in both source and binary
- form is allowed (with or without changes) provided that:
-
-   1. distributions of this source code include the above copyright
-      notice, this list of conditions and the following disclaimer;
-
-   2. distributions in binary form include the above copyright
-      notice, this list of conditions and the following disclaimer
-      in the documentation and/or other associated materials;
-
-   3. the copyright holder's name is not used to endorse products
-      built using this software without specific written permission.
-
- ALTERNATIVELY, provided that this notice is retained in full, this product
- may be distributed under the terms of the GNU General Public License (GPL),
- in which case the provisions of the GPL apply INSTEAD OF those given above.
-
- DISCLAIMER
-
- This software is provided 'as is' with no explicit or implied warranties
- in respect of its properties, including, but not limited to, correctness
- and/or fitness for purpose.
- ---------------------------------------------------------------------------
- Issue 09/09/2006
-
- The unsigned integer types defined here are of the form uint_<nn>t where
- <nn> is the length of the type; for example, the unsigned 32-bit type is
- 'uint_32t'.  These are NOT the same as the 'C99 integer types' that are
- defined in the inttypes.h and stdint.h headers since attempts to use these
- types have shown that support for them is still highly variable.  However,
- since the latter are of the form uint<nn>_t, a regular expression search
- and replace (in VC++ search on 'uint_{:z}t' and replace with 'uint\1_t')
- can be used to convert the types used here to the C99 standard types.
-*/
-
-#ifndef BRG_TYPES_H
-#define BRG_TYPES_H
-
-#if defined(__cplusplus)
-extern "C" {
-#endif
-
-#ifndef BRG_UI8
-#  define BRG_UI8
-     typedef unsigned char uint_8t;
-#endif
-
-#ifndef BRG_UI16
-#  define BRG_UI16
-     typedef unsigned short uint_16t;
-#endif
-
-#ifndef BRG_UI32
-#  define BRG_UI32
-#    define li_32(h) 0x##h##u
-     typedef unsigned int uint_32t;
-#endif
-
-#ifndef BRG_UI64
-#      define BRG_UI64
-#      define li_64(h) 0x##h##ull
-       typedef unsigned long long uint_64t;
-#endif
-
-#if defined( NEED_UINT_64T ) && !defined( BRG_UI64 )
-#  error Please define uint_64t as an unsigned 64 bit type in brg_types.h
-#endif
-
-#ifndef RETURN_VALUES
-#  define RETURN_VALUES
-#  if defined( DLL_EXPORT )
-#    if defined( _MSC_VER ) || defined ( __INTEL_COMPILER )
-#      define VOID_RETURN    __declspec( dllexport ) void __stdcall
-#      define INT_RETURN     __declspec( dllexport ) int  __stdcall
-#    elif defined( __GNUC__ )
-#      define VOID_RETURN    __declspec( __dllexport__ ) void
-#      define INT_RETURN     __declspec( __dllexport__ ) int
-#    else
-#      error Use of the DLL is only available on the Microsoft, Intel and GCC compilers
-#    endif
-#  elif defined( DLL_IMPORT )
-#    if defined( _MSC_VER ) || defined ( __INTEL_COMPILER )
-#      define VOID_RETURN    __declspec( dllimport ) void __stdcall
-#      define INT_RETURN     __declspec( dllimport ) int  __stdcall
-#    elif defined( __GNUC__ )
-#      define VOID_RETURN    __declspec( __dllimport__ ) void
-#      define INT_RETURN     __declspec( __dllimport__ ) int
-#    else
-#      error Use of the DLL is only available on the Microsoft, Intel and GCC compilers
-#    endif
-#  elif defined( __WATCOMC__ )
-#    define VOID_RETURN  void __cdecl
-#    define INT_RETURN   int  __cdecl
-#  else
-#    define VOID_RETURN  void
-#    define INT_RETURN   int
-#  endif
-#endif
-
-/*  These defines are used to declare buffers in a way that allows
-    faster operations on longer variables to be used.  In all these
-    defines 'size' must be a power of 2 and >= 8
-
-    dec_unit_type(size,x)       declares a variable 'x' of length 
-                                'size' bits
-
-    dec_bufr_type(size,bsize,x) declares a buffer 'x' of length 'bsize' 
-                                bytes defined as an array of variables
-                                each of 'size' bits (bsize must be a 
-                                multiple of size / 8)
-
-    ptr_cast(x,size)            casts a pointer to a pointer to a 
-                                varaiable of length 'size' bits
-*/
-
-#define ui_type(size)               uint_##size##t
-#define dec_unit_type(size,x)       typedef ui_type(size) x
-#define dec_bufr_type(size,bsize,x) typedef ui_type(size) x[bsize / (size >> 3)]
-#define ptr_cast(x,size)            ((ui_type(size)*)(x))
-
-#if defined(__cplusplus)
-}
-#endif
-
-#endif
diff --git a/drivers/staging/skein/include/skein_port.h b/drivers/staging/skein/include/skein_port.h
index 1c68070358ce..e78c976dccc5 100644
--- a/drivers/staging/skein/include/skein_port.h
+++ b/drivers/staging/skein/include/skein_port.h
@@ -15,11 +15,9 @@
 ** 
 ********************************************************************/
 
-#include <brg_types.h>                      /* get integer type definitions */
-
 typedef unsigned int    uint_t;             /* native unsigned integer */
-typedef uint_8t         u08b_t;             /*  8-bit unsigned integer */
-typedef uint_64t        u64b_t;             /* 64-bit unsigned integer */
+typedef uint8_t         u08b_t;             /*  8-bit unsigned integer */
+typedef uint64_t        u64b_t;             /* 64-bit unsigned integer */
 
 #ifndef RotL_64
 #define RotL_64(x,N)    (((x) << (N)) | ((x) >> (64-(N))))
-- 
1.9.1
