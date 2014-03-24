From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 01/21] staging: crypto: skein: import code from
 Skein3Fish.git
Date: Mon, 24 Mar 2014 01:48:58 +0000
Message-ID: <a7b3a7493d8948026ca09251c7f45db364956071.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
 Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
List-Id: linux-crypto.vger.kernel.org

This is a byte-for-byte copy of the skein implementation found at:

  https://github.com/wernerd/Skein3Fish.git

Specifically, from the master branch at commit:

  00e925444c2c Merge pull request #4 from csm/master

The next commit will do the minimum necessary to build this code as a
module.

I've generated the sha256 sums of the files by:

$ (cd drivers/staging/skein; find . -type f | sort | xargs sha256sum)
bcd73168e5805b1b157dbf08863e6a8c217a7b270b6be1a361540591b00624e3  ./CMakeLists.txt
e1adb97dd9e87bc7c05892ed7863a66d1d9fde6728a97a8b7b092709da664d29  ./include/brg_endian.h
240329b4ca4d829ac4d1490e96e83118e161e719e448c7e8dbf15735ab8a8e87  ./include/brg_types.h
0d8f16438f641fa365844a5991220eb04969f0a19c60dff08e10f521e74db5c3  ./include/skein.h
8f7362796e9e43f7619d51020d6faeedce786492b65bebd2ff6a833b621051cb  ./include/skeinApi.h
90510d8a9f686c3bfbf6cf7737237e3fa263c1ed5046b0f19727ba55b9bffeb9  ./include/skein_iv.h
42c6c8eff8f364ee2f0de3177d468dbceba9c6a73222fea473fe6d603213806a  ./include/skein_port.h
0154a4b8d54f5aa424b39a7ee668b31f2522b907bf3a8536fe46440b584531a1  ./include/threefishApi.h
ac0fc0f95a48a716d30cf02e5adad77af17725a938f939cf94f6dfba42badeca  ./skein.c
7af70b177bc63690f68eebceca2dbfef8a4473dcc847ae3525508c65c7d7bcc1  ./skeinApi.c
d7ef7330be8253f7f061de3c36880dbc83b0f5d90c8f2b72d3478766f54fbff0  ./skeinBlockNo3F.c
8bb3d7864afc9eab5569949fb2799cb6f14e583ba00641313cf877a5aea1c763  ./skein_block.c
438e6cb59a0090166e8f1e39418c0a2d0036737a32c5e2822c2ed8b803e2132f  ./threefish1024Block.c
e812ec6f2881300e90c803cfd9d044e954f1ca64faa2fc17a709f56a2f122ff8  ./threefish256Block.c
926f680057e128cdd1feba4a8544c177a74420137af480267b949ae79f3d02b8  ./threefish512Block.c
19357f5d47e7183bc8558a8d0949a3f5a80a931848917d26f36eebb7d205f003  ./threefishApi.c

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/CMakeLists.txt         |   27 +
 drivers/staging/skein/include/brg_endian.h   |  148 +++
 drivers/staging/skein/include/brg_types.h    |  188 ++++
 drivers/staging/skein/include/skein.h        |  327 ++++++
 drivers/staging/skein/include/skeinApi.h     |  239 +++++
 drivers/staging/skein/include/skein_iv.h     |  199 ++++
 drivers/staging/skein/include/skein_port.h   |  124 +++
 drivers/staging/skein/include/threefishApi.h |  167 ++++
 drivers/staging/skein/skein.c                |  742 ++++++++++++++
 drivers/staging/skein/skeinApi.c             |  221 ++++
 drivers/staging/skein/skeinBlockNo3F.c       |  172 ++++
 drivers/staging/skein/skein_block.c          |  689 +++++++++++++
 drivers/staging/skein/threefish1024Block.c   | 1385 ++++++++++++++++++++++++++
 drivers/staging/skein/threefish256Block.c    |  349 +++++++
 drivers/staging/skein/threefish512Block.c    |  643 ++++++++++++
 drivers/staging/skein/threefishApi.c         |   79 ++
 16 files changed, 5699 insertions(+)
 create mode 100755 drivers/staging/skein/CMakeLists.txt
 create mode 100644 drivers/staging/skein/include/brg_endian.h
 create mode 100644 drivers/staging/skein/include/brg_types.h
 create mode 100644 drivers/staging/skein/include/skein.h
 create mode 100755 drivers/staging/skein/include/skeinApi.h
 create mode 100644 drivers/staging/skein/include/skein_iv.h
 create mode 100644 drivers/staging/skein/include/skein_port.h
 create mode 100644 drivers/staging/skein/include/threefishApi.h
 create mode 100644 drivers/staging/skein/skein.c
 create mode 100755 drivers/staging/skein/skeinApi.c
 create mode 100644 drivers/staging/skein/skeinBlockNo3F.c
 create mode 100644 drivers/staging/skein/skein_block.c
 create mode 100644 drivers/staging/skein/threefish1024Block.c
 create mode 100644 drivers/staging/skein/threefish256Block.c
 create mode 100644 drivers/staging/skein/threefish512Block.c
 create mode 100644 drivers/staging/skein/threefishApi.c

diff --git a/drivers/staging/skein/CMakeLists.txt b/drivers/staging/skein/CMakeLists.txt
new file mode 100755
index 000000000000..604aaa394cb1
--- /dev/null
+++ b/drivers/staging/skein/CMakeLists.txt
@@ -0,0 +1,27 @@
+cmake_minimum_required (VERSION 2.6)
+
+include_directories (${CMAKE_CURRENT_SOURCE_DIR}/include)
+
+# set(skeinBlock_src skein_block.c)
+set(skeinBlock_src skeinBlockNo3F.c)
+
+set(skein_src 
+    ${skeinBlock_src}
+    skein.c
+    skeinApi.c
+    )
+
+set(threefish_src
+    threefishApi.c
+    threefish256Block.c
+    threefish512Block.c
+    threefish1024Block.c
+    )
+set(s3f_src ${skein_src} ${threefish_src})
+
+add_library(skein3fish SHARED ${s3f_src})
+set_target_properties(skein3fish PROPERTIES VERSION ${VERSION} SOVERSION ${SOVERSION})
+target_link_libraries(skein3fish ${LIBS})
+
+install(TARGETS skein3fish DESTINATION ${LIBDIRNAME})
+
diff --git a/drivers/staging/skein/include/brg_endian.h b/drivers/staging/skein/include/brg_endian.h
new file mode 100644
index 000000000000..c03c7c5d1eb4
--- /dev/null
+++ b/drivers/staging/skein/include/brg_endian.h
@@ -0,0 +1,148 @@
+/*
+ ---------------------------------------------------------------------------
+ Copyright (c) 2003, Dr Brian Gladman, Worcester, UK.   All rights reserved.
+
+ LICENSE TERMS
+
+ The free distribution and use of this software in both source and binary
+ form is allowed (with or without changes) provided that:
+
+   1. distributions of this source code include the above copyright
+      notice, this list of conditions and the following disclaimer;
+
+   2. distributions in binary form include the above copyright
+      notice, this list of conditions and the following disclaimer
+      in the documentation and/or other associated materials;
+
+   3. the copyright holder's name is not used to endorse products
+      built using this software without specific written permission.
+
+ ALTERNATIVELY, provided that this notice is retained in full, this product
+ may be distributed under the terms of the GNU General Public License (GPL),
+ in which case the provisions of the GPL apply INSTEAD OF those given above.
+
+ DISCLAIMER
+
+ This software is provided 'as is' with no explicit or implied warranties
+ in respect of its properties, including, but not limited to, correctness
+ and/or fitness for purpose.
+ ---------------------------------------------------------------------------
+ Issue 20/10/2006
+*/
+
+#ifndef BRG_ENDIAN_H
+#define BRG_ENDIAN_H
+
+#define IS_BIG_ENDIAN      4321 /* byte 0 is most significant (mc68k) */
+#define IS_LITTLE_ENDIAN   1234 /* byte 0 is least significant (i386) */
+
+/* Include files where endian defines and byteswap functions may reside */
+#if defined( __FreeBSD__ ) || defined( __OpenBSD__ ) || defined( __NetBSD__ )
+#  include <sys/endian.h>
+#elif defined( BSD ) && ( BSD >= 199103 ) || defined( __APPLE__ ) || \
+      defined( __CYGWIN32__ ) || defined( __DJGPP__ ) || defined( __osf__ )
+#  include <machine/endian.h>
+#elif defined( __linux__ ) || defined( __GNUC__ ) || defined( __GNU_LIBRARY__ )
+#  if !defined( __MINGW32__ ) && !defined(AVR)
+#    include <endian.h>
+#    if !defined( __BEOS__ )
+#      include <byteswap.h>
+#    endif
+#  endif
+#endif
+
+/* Now attempt to set the define for platform byte order using any  */
+/* of the four forms SYMBOL, _SYMBOL, __SYMBOL & __SYMBOL__, which  */
+/* seem to encompass most endian symbol definitions                 */
+
+#if defined( BIG_ENDIAN ) && defined( LITTLE_ENDIAN )
+#  if defined( BYTE_ORDER ) && BYTE_ORDER == BIG_ENDIAN
+#    define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#  elif defined( BYTE_ORDER ) && BYTE_ORDER == LITTLE_ENDIAN
+#    define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#  endif
+#elif defined( BIG_ENDIAN )
+#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#elif defined( LITTLE_ENDIAN )
+#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#endif
+
+#if defined( _BIG_ENDIAN ) && defined( _LITTLE_ENDIAN )
+#  if defined( _BYTE_ORDER ) && _BYTE_ORDER == _BIG_ENDIAN
+#    define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#  elif defined( _BYTE_ORDER ) && _BYTE_ORDER == _LITTLE_ENDIAN
+#    define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#  endif
+#elif defined( _BIG_ENDIAN )
+#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#elif defined( _LITTLE_ENDIAN )
+#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#endif
+
+#if defined( __BIG_ENDIAN ) && defined( __LITTLE_ENDIAN )
+#  if defined( __BYTE_ORDER ) && __BYTE_ORDER == __BIG_ENDIAN
+#    define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#  elif defined( __BYTE_ORDER ) && __BYTE_ORDER == __LITTLE_ENDIAN
+#    define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#  endif
+#elif defined( __BIG_ENDIAN )
+#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#elif defined( __LITTLE_ENDIAN )
+#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#endif
+
+#if defined( __BIG_ENDIAN__ ) && defined( __LITTLE_ENDIAN__ )
+#  if defined( __BYTE_ORDER__ ) && __BYTE_ORDER__ == __BIG_ENDIAN__
+#    define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#  elif defined( __BYTE_ORDER__ ) && __BYTE_ORDER__ == __LITTLE_ENDIAN__
+#    define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#  endif
+#elif defined( __BIG_ENDIAN__ )
+#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#elif defined( __LITTLE_ENDIAN__ )
+#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#endif
+
+/*  if the platform byte order could not be determined, then try to */
+/*  set this define using common machine defines                    */
+#if !defined(PLATFORM_BYTE_ORDER)
+
+#if   defined( __alpha__ ) || defined( __alpha ) || defined( i386 )       || \
+      defined( __i386__ )  || defined( _M_I86 )  || defined( _M_IX86 )    || \
+      defined( __OS2__ )   || defined( sun386 )  || defined( __TURBOC__ ) || \
+      defined( vax )       || defined( vms )     || defined( VMS )        || \
+      defined( __VMS )     || defined( _M_X64 )  || defined( AVR )
+#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+
+#elif defined( AMIGA )   || defined( applec )    || defined( __AS400__ )  || \
+      defined( _CRAY )   || defined( __hppa )    || defined( __hp9000 )   || \
+      defined( ibm370 )  || defined( mc68000 )   || defined( m68k )       || \
+      defined( __MRC__ ) || defined( __MVS__ )   || defined( __MWERKS__ ) || \
+      defined( sparc )   || defined( __sparc)    || defined( SYMANTEC_C ) || \
+      defined( __VOS__ ) || defined( __TIGCC__ ) || defined( __TANDEM )   || \
+      defined( THINK_C ) || defined( __VMCMS__ )
+#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+
+#elif 0     /* **** EDIT HERE IF NECESSARY **** */
+#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#elif 0     /* **** EDIT HERE IF NECESSARY **** */
+#  define PLATFORM_BYTE_ORDER IS_BIG_ENDIAN
+#else
+#  error Please edit lines 126 or 128 in brg_endian.h to set the platform byte order
+#endif
+#endif
+
+/* special handler for IA64, which may be either endianness (?)  */
+/* here we assume little-endian, but this may need to be changed */
+#if defined(__ia64) || defined(__ia64__) || defined(_M_IA64)
+#  define PLATFORM_MUST_ALIGN (1)
+#ifndef PLATFORM_BYTE_ORDER
+#  define PLATFORM_BYTE_ORDER IS_LITTLE_ENDIAN
+#endif
+#endif
+
+#ifndef   PLATFORM_MUST_ALIGN
+#  define PLATFORM_MUST_ALIGN (0)
+#endif
+
+#endif  /* ifndef BRG_ENDIAN_H */
diff --git a/drivers/staging/skein/include/brg_types.h b/drivers/staging/skein/include/brg_types.h
new file mode 100644
index 000000000000..6db737d71b9e
--- /dev/null
+++ b/drivers/staging/skein/include/brg_types.h
@@ -0,0 +1,188 @@
+/*
+ ---------------------------------------------------------------------------
+ Copyright (c) 1998-2006, Brian Gladman, Worcester, UK. All rights reserved.
+
+ LICENSE TERMS
+
+ The free distribution and use of this software in both source and binary
+ form is allowed (with or without changes) provided that:
+
+   1. distributions of this source code include the above copyright
+      notice, this list of conditions and the following disclaimer;
+
+   2. distributions in binary form include the above copyright
+      notice, this list of conditions and the following disclaimer
+      in the documentation and/or other associated materials;
+
+   3. the copyright holder's name is not used to endorse products
+      built using this software without specific written permission.
+
+ ALTERNATIVELY, provided that this notice is retained in full, this product
+ may be distributed under the terms of the GNU General Public License (GPL),
+ in which case the provisions of the GPL apply INSTEAD OF those given above.
+
+ DISCLAIMER
+
+ This software is provided 'as is' with no explicit or implied warranties
+ in respect of its properties, including, but not limited to, correctness
+ and/or fitness for purpose.
+ ---------------------------------------------------------------------------
+ Issue 09/09/2006
+
+ The unsigned integer types defined here are of the form uint_<nn>t where
+ <nn> is the length of the type; for example, the unsigned 32-bit type is
+ 'uint_32t'.  These are NOT the same as the 'C99 integer types' that are
+ defined in the inttypes.h and stdint.h headers since attempts to use these
+ types have shown that support for them is still highly variable.  However,
+ since the latter are of the form uint<nn>_t, a regular expression search
+ and replace (in VC++ search on 'uint_{:z}t' and replace with 'uint\1_t')
+ can be used to convert the types used here to the C99 standard types.
+*/
+
+#ifndef BRG_TYPES_H
+#define BRG_TYPES_H
+
+#if defined(__cplusplus)
+extern "C" {
+#endif
+
+#include <limits.h>
+
+#ifndef BRG_UI8
+#  define BRG_UI8
+#  if UCHAR_MAX == 255u
+     typedef unsigned char uint_8t;
+#  else
+#    error Please define uint_8t as an 8-bit unsigned integer type in brg_types.h
+#  endif
+#endif
+
+#ifndef BRG_UI16
+#  define BRG_UI16
+#  if USHRT_MAX == 65535u
+     typedef unsigned short uint_16t;
+#  else
+#    error Please define uint_16t as a 16-bit unsigned short type in brg_types.h
+#  endif
+#endif
+
+#ifndef BRG_UI32
+#  define BRG_UI32
+#  if UINT_MAX == 4294967295u
+#    define li_32(h) 0x##h##u
+     typedef unsigned int uint_32t;
+#  elif ULONG_MAX == 4294967295u
+#    define li_32(h) 0x##h##ul
+     typedef unsigned long uint_32t;
+#  elif defined( _CRAY )
+#    error This code needs 32-bit data types, which Cray machines do not provide
+#  else
+#    error Please define uint_32t as a 32-bit unsigned integer type in brg_types.h
+#  endif
+#endif
+
+#ifndef BRG_UI64
+#  if defined( __BORLANDC__ ) && !defined( __MSDOS__ )
+#    define BRG_UI64
+#    define li_64(h) 0x##h##ui64
+     typedef unsigned __int64 uint_64t;
+#  elif defined( _MSC_VER ) && ( _MSC_VER < 1300 )    /* 1300 == VC++ 7.0 */
+#    define BRG_UI64
+#    define li_64(h) 0x##h##ui64
+     typedef unsigned __int64 uint_64t;
+#  elif defined( __sun ) && defined(ULONG_MAX) && ULONG_MAX == 0xfffffffful
+#    define BRG_UI64
+#    define li_64(h) 0x##h##ull
+     typedef unsigned long long uint_64t;
+#  elif defined( UINT_MAX ) && UINT_MAX > 4294967295u
+#    if UINT_MAX == 18446744073709551615u
+#      define BRG_UI64
+#      define li_64(h) 0x##h##u
+       typedef unsigned int uint_64t;
+#    endif
+#  elif defined( ULONG_MAX ) && ULONG_MAX > 4294967295u
+#    if ULONG_MAX == 18446744073709551615ul
+#      define BRG_UI64
+#      define li_64(h) 0x##h##ul
+       typedef unsigned long uint_64t;
+#    endif
+#  elif defined( ULLONG_MAX ) && ULLONG_MAX > 4294967295u
+#    if ULLONG_MAX == 18446744073709551615ull
+#      define BRG_UI64
+#      define li_64(h) 0x##h##ull
+       typedef unsigned long long uint_64t;
+#    endif
+#  elif defined( ULONG_LONG_MAX ) && ULONG_LONG_MAX > 4294967295u
+#    if ULONG_LONG_MAX == 18446744073709551615ull
+#      define BRG_UI64
+#      define li_64(h) 0x##h##ull
+       typedef unsigned long long uint_64t;
+#    endif
+#  elif defined(__GNUC__)  /* DLW: avoid mingw problem with -ansi */
+#      define BRG_UI64
+#      define li_64(h) 0x##h##ull
+       typedef unsigned long long uint_64t;
+#  endif
+#endif
+
+#if defined( NEED_UINT_64T ) && !defined( BRG_UI64 )
+#  error Please define uint_64t as an unsigned 64 bit type in brg_types.h
+#endif
+
+#ifndef RETURN_VALUES
+#  define RETURN_VALUES
+#  if defined( DLL_EXPORT )
+#    if defined( _MSC_VER ) || defined ( __INTEL_COMPILER )
+#      define VOID_RETURN    __declspec( dllexport ) void __stdcall
+#      define INT_RETURN     __declspec( dllexport ) int  __stdcall
+#    elif defined( __GNUC__ )
+#      define VOID_RETURN    __declspec( __dllexport__ ) void
+#      define INT_RETURN     __declspec( __dllexport__ ) int
+#    else
+#      error Use of the DLL is only available on the Microsoft, Intel and GCC compilers
+#    endif
+#  elif defined( DLL_IMPORT )
+#    if defined( _MSC_VER ) || defined ( __INTEL_COMPILER )
+#      define VOID_RETURN    __declspec( dllimport ) void __stdcall
+#      define INT_RETURN     __declspec( dllimport ) int  __stdcall
+#    elif defined( __GNUC__ )
+#      define VOID_RETURN    __declspec( __dllimport__ ) void
+#      define INT_RETURN     __declspec( __dllimport__ ) int
+#    else
+#      error Use of the DLL is only available on the Microsoft, Intel and GCC compilers
+#    endif
+#  elif defined( __WATCOMC__ )
+#    define VOID_RETURN  void __cdecl
+#    define INT_RETURN   int  __cdecl
+#  else
+#    define VOID_RETURN  void
+#    define INT_RETURN   int
+#  endif
+#endif
+
+/*  These defines are used to declare buffers in a way that allows
+    faster operations on longer variables to be used.  In all these
+    defines 'size' must be a power of 2 and >= 8
+
+    dec_unit_type(size,x)       declares a variable 'x' of length 
+                                'size' bits
+
+    dec_bufr_type(size,bsize,x) declares a buffer 'x' of length 'bsize' 
+                                bytes defined as an array of variables
+                                each of 'size' bits (bsize must be a 
+                                multiple of size / 8)
+
+    ptr_cast(x,size)            casts a pointer to a pointer to a 
+                                varaiable of length 'size' bits
+*/
+
+#define ui_type(size)               uint_##size##t
+#define dec_unit_type(size,x)       typedef ui_type(size) x
+#define dec_bufr_type(size,bsize,x) typedef ui_type(size) x[bsize / (size >> 3)]
+#define ptr_cast(x,size)            ((ui_type(size)*)(x))
+
+#if defined(__cplusplus)
+}
+#endif
+
+#endif
diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
new file mode 100644
index 000000000000..cb613fa09d9e
--- /dev/null
+++ b/drivers/staging/skein/include/skein.h
@@ -0,0 +1,327 @@
+#ifndef _SKEIN_H_
+#define _SKEIN_H_     1
+/**************************************************************************
+**
+** Interface declarations and internal definitions for Skein hashing.
+**
+** Source code author: Doug Whiting, 2008.
+**
+** This algorithm and source code is released to the public domain.
+**
+***************************************************************************
+** 
+** The following compile-time switches may be defined to control some
+** tradeoffs between speed, code size, error checking, and security.
+**
+** The "default" note explains what happens when the switch is not defined.
+**
+**  SKEIN_DEBUG            -- make callouts from inside Skein code
+**                            to examine/display intermediate values.
+**                            [default: no callouts (no overhead)]
+**
+**  SKEIN_ERR_CHECK        -- how error checking is handled inside Skein
+**                            code. If not defined, most error checking 
+**                            is disabled (for performance). Otherwise, 
+**                            the switch value is interpreted as:
+**                                0: use assert()      to flag errors
+**                                1: return SKEIN_FAIL to flag errors
+**
+***************************************************************************/
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
+#include <stddef.h>                          /* get size_t definition */
+#include <skein_port.h>               /* get platform-specific definitions */
+
+enum
+    {
+    SKEIN_SUCCESS         =      0,          /* return codes from Skein calls */
+    SKEIN_FAIL            =      1,
+    SKEIN_BAD_HASHLEN     =      2
+    };
+
+#define  SKEIN_MODIFIER_WORDS  ( 2)          /* number of modifier (tweak) words */
+
+#define  SKEIN_256_STATE_WORDS ( 4)
+#define  SKEIN_512_STATE_WORDS ( 8)
+#define  SKEIN1024_STATE_WORDS (16)
+#define  SKEIN_MAX_STATE_WORDS (16)
+
+#define  SKEIN_256_STATE_BYTES ( 8*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_STATE_BYTES ( 8*SKEIN_512_STATE_WORDS)
+#define  SKEIN1024_STATE_BYTES ( 8*SKEIN1024_STATE_WORDS)
+
+#define  SKEIN_256_STATE_BITS  (64*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_STATE_BITS  (64*SKEIN_512_STATE_WORDS)
+#define  SKEIN1024_STATE_BITS  (64*SKEIN1024_STATE_WORDS)
+
+#define  SKEIN_256_BLOCK_BYTES ( 8*SKEIN_256_STATE_WORDS)
+#define  SKEIN_512_BLOCK_BYTES ( 8*SKEIN_512_STATE_WORDS)
+#define  SKEIN1024_BLOCK_BYTES ( 8*SKEIN1024_STATE_WORDS)
+
+typedef struct
+    {
+    size_t  hashBitLen;                      /* size of hash result, in bits */
+    size_t  bCnt;                            /* current byte count in buffer b[] */
+    u64b_t  T[SKEIN_MODIFIER_WORDS];         /* tweak words: T[0]=byte cnt, T[1]=flags */
+    } Skein_Ctxt_Hdr_t;
+
+typedef struct                               /*  256-bit Skein hash context structure */
+    {
+    Skein_Ctxt_Hdr_t h;                      /* common header context variables */
+    u64b_t  X[SKEIN_256_STATE_WORDS];        /* chaining variables */
+    u08b_t  b[SKEIN_256_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+    } Skein_256_Ctxt_t;
+
+typedef struct                               /*  512-bit Skein hash context structure */
+    {
+    Skein_Ctxt_Hdr_t h;                      /* common header context variables */
+    u64b_t  X[SKEIN_512_STATE_WORDS];        /* chaining variables */
+    u08b_t  b[SKEIN_512_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+    } Skein_512_Ctxt_t;
+
+typedef struct                               /* 1024-bit Skein hash context structure */
+    {
+    Skein_Ctxt_Hdr_t h;                      /* common header context variables */
+    u64b_t  X[SKEIN1024_STATE_WORDS];        /* chaining variables */
+    u08b_t  b[SKEIN1024_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+    } Skein1024_Ctxt_t;
+
+/*   Skein APIs for (incremental) "straight hashing" */
+int  Skein_256_Init  (Skein_256_Ctxt_t *ctx, size_t hashBitLen);
+int  Skein_512_Init  (Skein_512_Ctxt_t *ctx, size_t hashBitLen);
+int  Skein1024_Init  (Skein1024_Ctxt_t *ctx, size_t hashBitLen);
+
+int  Skein_256_Update(Skein_256_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt);
+int  Skein_512_Update(Skein_512_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt);
+int  Skein1024_Update(Skein1024_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt);
+
+int  Skein_256_Final (Skein_256_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein_512_Final (Skein_512_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein1024_Final (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
+
+/*
+**   Skein APIs for "extended" initialization: MAC keys, tree hashing.
+**   After an InitExt() call, just use Update/Final calls as with Init().
+**
+**   Notes: Same parameters as _Init() calls, plus treeInfo/key/keyBytes.
+**          When keyBytes == 0 and treeInfo == SKEIN_SEQUENTIAL, 
+**              the results of InitExt() are identical to calling Init().
+**          The function Init() may be called once to "precompute" the IV for
+**              a given hashBitLen value, then by saving a copy of the context
+**              the IV computation may be avoided in later calls.
+**          Similarly, the function InitExt() may be called once per MAC key 
+**              to precompute the MAC IV, then a copy of the context saved and
+**              reused for each new MAC computation.
+**/
+int  Skein_256_InitExt(Skein_256_Ctxt_t *ctx, size_t hashBitLen, u64b_t treeInfo, const u08b_t *key, size_t keyBytes);
+int  Skein_512_InitExt(Skein_512_Ctxt_t *ctx, size_t hashBitLen, u64b_t treeInfo, const u08b_t *key, size_t keyBytes);
+int  Skein1024_InitExt(Skein1024_Ctxt_t *ctx, size_t hashBitLen, u64b_t treeInfo, const u08b_t *key, size_t keyBytes);
+
+/*
+**   Skein APIs for MAC and tree hash:
+**      Final_Pad:  pad, do final block, but no OUTPUT type
+**      Output:     do just the output stage
+*/
+int  Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
+
+#ifndef SKEIN_TREE_HASH
+#define SKEIN_TREE_HASH (1)
+#endif
+#if  SKEIN_TREE_HASH
+int  Skein_256_Output   (Skein_256_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein_512_Output   (Skein_512_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
+#endif
+
+/*****************************************************************
+** "Internal" Skein definitions
+**    -- not needed for sequential hashing API, but will be 
+**           helpful for other uses of Skein (e.g., tree hash mode).
+**    -- included here so that they can be shared between
+**           reference and optimized code.
+******************************************************************/
+
+/* tweak word T[1]: bit field starting positions */
+#define SKEIN_T1_BIT(BIT)       ((BIT) - 64)            /* offset 64 because it's the second word  */
+                                
+#define SKEIN_T1_POS_TREE_LVL   SKEIN_T1_BIT(112)       /* bits 112..118: level in hash tree       */
+#define SKEIN_T1_POS_BIT_PAD    SKEIN_T1_BIT(119)       /* bit  119     : partial final input byte */
+#define SKEIN_T1_POS_BLK_TYPE   SKEIN_T1_BIT(120)       /* bits 120..125: type field               */
+#define SKEIN_T1_POS_FIRST      SKEIN_T1_BIT(126)       /* bits 126     : first block flag         */
+#define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127)       /* bit  127     : final block flag         */
+                                
+/* tweak word T[1]: flag bit definition(s) */
+#define SKEIN_T1_FLAG_FIRST     (((u64b_t)  1 ) << SKEIN_T1_POS_FIRST)
+#define SKEIN_T1_FLAG_FINAL     (((u64b_t)  1 ) << SKEIN_T1_POS_FINAL)
+#define SKEIN_T1_FLAG_BIT_PAD   (((u64b_t)  1 ) << SKEIN_T1_POS_BIT_PAD)
+                                
+/* tweak word T[1]: tree level bit field mask */
+#define SKEIN_T1_TREE_LVL_MASK  (((u64b_t)0x7F) << SKEIN_T1_POS_TREE_LVL)
+#define SKEIN_T1_TREE_LEVEL(n)  (((u64b_t) (n)) << SKEIN_T1_POS_TREE_LVL)
+
+/* tweak word T[1]: block type field */
+#define SKEIN_BLK_TYPE_KEY      ( 0)                    /* key, for MAC and KDF */
+#define SKEIN_BLK_TYPE_CFG      ( 4)                    /* configuration block */
+#define SKEIN_BLK_TYPE_PERS     ( 8)                    /* personalization string */
+#define SKEIN_BLK_TYPE_PK       (12)                    /* public key (for digital signature hashing) */
+#define SKEIN_BLK_TYPE_KDF      (16)                    /* key identifier for KDF */
+#define SKEIN_BLK_TYPE_NONCE    (20)                    /* nonce for PRNG */
+#define SKEIN_BLK_TYPE_MSG      (48)                    /* message processing */
+#define SKEIN_BLK_TYPE_OUT      (63)                    /* output stage */
+#define SKEIN_BLK_TYPE_MASK     (63)                    /* bit field mask */
+
+#define SKEIN_T1_BLK_TYPE(T)   (((u64b_t) (SKEIN_BLK_TYPE_##T)) << SKEIN_T1_POS_BLK_TYPE)
+#define SKEIN_T1_BLK_TYPE_KEY   SKEIN_T1_BLK_TYPE(KEY)  /* key, for MAC and KDF */
+#define SKEIN_T1_BLK_TYPE_CFG   SKEIN_T1_BLK_TYPE(CFG)  /* configuration block */
+#define SKEIN_T1_BLK_TYPE_PERS  SKEIN_T1_BLK_TYPE(PERS) /* personalization string */
+#define SKEIN_T1_BLK_TYPE_PK    SKEIN_T1_BLK_TYPE(PK)   /* public key (for digital signature hashing) */
+#define SKEIN_T1_BLK_TYPE_KDF   SKEIN_T1_BLK_TYPE(KDF)  /* key identifier for KDF */
+#define SKEIN_T1_BLK_TYPE_NONCE SKEIN_T1_BLK_TYPE(NONCE)/* nonce for PRNG */
+#define SKEIN_T1_BLK_TYPE_MSG   SKEIN_T1_BLK_TYPE(MSG)  /* message processing */
+#define SKEIN_T1_BLK_TYPE_OUT   SKEIN_T1_BLK_TYPE(OUT)  /* output stage */
+#define SKEIN_T1_BLK_TYPE_MASK  SKEIN_T1_BLK_TYPE(MASK) /* field bit mask */
+
+#define SKEIN_T1_BLK_TYPE_CFG_FINAL       (SKEIN_T1_BLK_TYPE_CFG | SKEIN_T1_FLAG_FINAL)
+#define SKEIN_T1_BLK_TYPE_OUT_FINAL       (SKEIN_T1_BLK_TYPE_OUT | SKEIN_T1_FLAG_FINAL)
+
+#define SKEIN_VERSION           (1)
+
+#ifndef SKEIN_ID_STRING_LE      /* allow compile-time personalization */
+#define SKEIN_ID_STRING_LE      (0x33414853)            /* "SHA3" (little-endian)*/
+#endif
+
+#define SKEIN_MK_64(hi32,lo32)  ((lo32) + (((u64b_t) (hi32)) << 32))
+#define SKEIN_SCHEMA_VER        SKEIN_MK_64(SKEIN_VERSION,SKEIN_ID_STRING_LE)
+#define SKEIN_KS_PARITY         SKEIN_MK_64(0x1BD11BDA,0xA9FC1A22)
+
+#define SKEIN_CFG_STR_LEN       (4*8)
+
+/* bit field definitions in config block treeInfo word */
+#define SKEIN_CFG_TREE_LEAF_SIZE_POS  ( 0)
+#define SKEIN_CFG_TREE_NODE_SIZE_POS  ( 8)
+#define SKEIN_CFG_TREE_MAX_LEVEL_POS  (16)
+
+#define SKEIN_CFG_TREE_LEAF_SIZE_MSK  (((u64b_t) 0xFF) << SKEIN_CFG_TREE_LEAF_SIZE_POS)
+#define SKEIN_CFG_TREE_NODE_SIZE_MSK  (((u64b_t) 0xFF) << SKEIN_CFG_TREE_NODE_SIZE_POS)
+#define SKEIN_CFG_TREE_MAX_LEVEL_MSK  (((u64b_t) 0xFF) << SKEIN_CFG_TREE_MAX_LEVEL_POS)
+
+#define SKEIN_CFG_TREE_INFO(leaf,node,maxLvl)                   \
+    ( (((u64b_t)(leaf  )) << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
+      (((u64b_t)(node  )) << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
+      (((u64b_t)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS) )
+
+#define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0,0,0) /* use as treeInfo in InitExt() call for sequential processing */
+
+/*
+**   Skein macros for getting/setting tweak words, etc.
+**   These are useful for partial input bytes, hash tree init/update, etc.
+**/
+#define Skein_Get_Tweak(ctxPtr,TWK_NUM)         ((ctxPtr)->h.T[TWK_NUM])
+#define Skein_Set_Tweak(ctxPtr,TWK_NUM,tVal)    {(ctxPtr)->h.T[TWK_NUM] = (tVal);}
+
+#define Skein_Get_T0(ctxPtr)    Skein_Get_Tweak(ctxPtr,0)
+#define Skein_Get_T1(ctxPtr)    Skein_Get_Tweak(ctxPtr,1)
+#define Skein_Set_T0(ctxPtr,T0) Skein_Set_Tweak(ctxPtr,0,T0)
+#define Skein_Set_T1(ctxPtr,T1) Skein_Set_Tweak(ctxPtr,1,T1)
+
+/* set both tweak words at once */
+#define Skein_Set_T0_T1(ctxPtr,T0,T1)           \
+    {                                           \
+    Skein_Set_T0(ctxPtr,(T0));                  \
+    Skein_Set_T1(ctxPtr,(T1));                  \
+    }
+
+#define Skein_Set_Type(ctxPtr,BLK_TYPE)         \
+    Skein_Set_T1(ctxPtr,SKEIN_T1_BLK_TYPE_##BLK_TYPE)
+
+/* set up for starting with a new type: h.T[0]=0; h.T[1] = NEW_TYPE; h.bCnt=0; */
+#define Skein_Start_New_Type(ctxPtr,BLK_TYPE)   \
+    { Skein_Set_T0_T1(ctxPtr,0,SKEIN_T1_FLAG_FIRST | SKEIN_T1_BLK_TYPE_##BLK_TYPE); (ctxPtr)->h.bCnt=0; }
+
+#define Skein_Clear_First_Flag(hdr)      { (hdr).T[1] &= ~SKEIN_T1_FLAG_FIRST;       }
+#define Skein_Set_Bit_Pad_Flag(hdr)      { (hdr).T[1] |=  SKEIN_T1_FLAG_BIT_PAD;     }
+
+#define Skein_Set_Tree_Level(hdr,height) { (hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height);}
+
+/*****************************************************************
+** "Internal" Skein definitions for debugging and error checking
+******************************************************************/
+#ifdef  SKEIN_DEBUG             /* examine/display intermediate values? */
+#include "skein_debug.h"
+#else                           /* default is no callouts */
+#define Skein_Show_Block(bits,ctx,X,blkPtr,wPtr,ksEvenPtr,ksOddPtr)
+#define Skein_Show_Round(bits,ctx,r,X)
+#define Skein_Show_R_Ptr(bits,ctx,r,X_ptr)
+#define Skein_Show_Final(bits,ctx,cnt,outPtr)
+#define Skein_Show_Key(bits,ctx,key,keyBytes)
+#endif
+
+#ifndef SKEIN_ERR_CHECK        /* run-time checks (e.g., bad params, uninitialized context)? */
+#define Skein_Assert(x,retCode)/* default: ignore all Asserts, for performance */
+#define Skein_assert(x)
+#elif   defined(SKEIN_ASSERT)
+#include <assert.h>     
+#define Skein_Assert(x,retCode) assert(x) 
+#define Skein_assert(x)         assert(x) 
+#else
+#include <assert.h>     
+#define Skein_Assert(x,retCode) { if (!(x)) return retCode; } /*  caller  error */
+#define Skein_assert(x)         assert(x)                     /* internal error */
+#endif
+
+/*****************************************************************
+** Skein block function constants (shared across Ref and Opt code)
+******************************************************************/
+enum    
+    {   
+        /* Skein_256 round rotation constants */
+    R_256_0_0=14, R_256_0_1=16,
+    R_256_1_0=52, R_256_1_1=57,
+    R_256_2_0=23, R_256_2_1=40,
+    R_256_3_0= 5, R_256_3_1=37,
+    R_256_4_0=25, R_256_4_1=33,
+    R_256_5_0=46, R_256_5_1=12,
+    R_256_6_0=58, R_256_6_1=22,
+    R_256_7_0=32, R_256_7_1=32,
+
+        /* Skein_512 round rotation constants */
+    R_512_0_0=46, R_512_0_1=36, R_512_0_2=19, R_512_0_3=37,
+    R_512_1_0=33, R_512_1_1=27, R_512_1_2=14, R_512_1_3=42,
+    R_512_2_0=17, R_512_2_1=49, R_512_2_2=36, R_512_2_3=39,
+    R_512_3_0=44, R_512_3_1= 9, R_512_3_2=54, R_512_3_3=56,
+    R_512_4_0=39, R_512_4_1=30, R_512_4_2=34, R_512_4_3=24,
+    R_512_5_0=13, R_512_5_1=50, R_512_5_2=10, R_512_5_3=17,
+    R_512_6_0=25, R_512_6_1=29, R_512_6_2=39, R_512_6_3=43,
+    R_512_7_0= 8, R_512_7_1=35, R_512_7_2=56, R_512_7_3=22,
+
+        /* Skein1024 round rotation constants */
+    R1024_0_0=24, R1024_0_1=13, R1024_0_2= 8, R1024_0_3=47, R1024_0_4= 8, R1024_0_5=17, R1024_0_6=22, R1024_0_7=37,
+    R1024_1_0=38, R1024_1_1=19, R1024_1_2=10, R1024_1_3=55, R1024_1_4=49, R1024_1_5=18, R1024_1_6=23, R1024_1_7=52,
+    R1024_2_0=33, R1024_2_1= 4, R1024_2_2=51, R1024_2_3=13, R1024_2_4=34, R1024_2_5=41, R1024_2_6=59, R1024_2_7=17,
+    R1024_3_0= 5, R1024_3_1=20, R1024_3_2=48, R1024_3_3=41, R1024_3_4=47, R1024_3_5=28, R1024_3_6=16, R1024_3_7=25,
+    R1024_4_0=41, R1024_4_1= 9, R1024_4_2=37, R1024_4_3=31, R1024_4_4=12, R1024_4_5=47, R1024_4_6=44, R1024_4_7=30,
+    R1024_5_0=16, R1024_5_1=34, R1024_5_2=56, R1024_5_3=51, R1024_5_4= 4, R1024_5_5=53, R1024_5_6=42, R1024_5_7=41,
+    R1024_6_0=31, R1024_6_1=44, R1024_6_2=47, R1024_6_3=46, R1024_6_4=19, R1024_6_5=42, R1024_6_6=44, R1024_6_7=25,
+    R1024_7_0= 9, R1024_7_1=48, R1024_7_2=35, R1024_7_3=52, R1024_7_4=23, R1024_7_5=31, R1024_7_6=37, R1024_7_7=20
+    };
+
+#ifndef SKEIN_ROUNDS
+#define SKEIN_256_ROUNDS_TOTAL (72)          /* number of rounds for the different block sizes */
+#define SKEIN_512_ROUNDS_TOTAL (72)
+#define SKEIN1024_ROUNDS_TOTAL (80)
+#else                                        /* allow command-line define in range 8*(5..14)   */
+#define SKEIN_256_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/100) + 5) % 10) + 5))
+#define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/ 10) + 5) % 10) + 5))
+#define SKEIN1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS    ) + 5) % 10) + 5))
+#endif
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif  /* ifndef _SKEIN_H_ */
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
new file mode 100755
index 000000000000..19c3225460fc
--- /dev/null
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -0,0 +1,239 @@
+/*
+Copyright (c) 2010 Werner Dittmann
+
+Permission is hereby granted, free of charge, to any person
+obtaining a copy of this software and associated documentation
+files (the "Software"), to deal in the Software without
+restriction, including without limitation the rights to use,
+copy, modify, merge, publish, distribute, sublicense, and/or sell
+copies of the Software, and to permit persons to whom the
+Software is furnished to do so, subject to the following
+conditions:
+
+The above copyright notice and this permission notice shall be
+included in all copies or substantial portions of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+OTHER DEALINGS IN THE SOFTWARE.
+
+*/
+
+#ifndef SKEINAPI_H
+#define SKEINAPI_H
+
+/**
+ * @file skeinApi.h
+ * @brief A Skein API and its functions.
+ * @{
+ *
+ * This API and the functions that implement this API simplify the usage
+ * of Skein. The design and the way to use the functions follow the openSSL
+ * design but at the same time take care of some Skein specific behaviour
+ * and possibilities.
+ * 
+ * The functions enable applications to create a normal Skein hashes and
+ * message authentication codes (MAC).
+ * 
+ * Using these functions is simple and straight forward:
+ * 
+ * @code
+ * 
+ * #include <skeinApi.h>
+ * 
+ * ...
+ * SkeinCtx_t ctx;             // a Skein hash or MAC context
+ * 
+ * // prepare context, here for a Skein with a state size of 512 bits.
+ * skeinCtxPrepare(&ctx, Skein512);
+ * 
+ * // Initialize the context to set the requested hash length in bits
+ * // here request a output hash size of 31 bits (Skein supports variable
+ * // output sizes even very strange sizes)
+ * skeinInit(&ctx, 31);
+ * 
+ * // Now update Skein with any number of message bits. A function that
+ * // takes a number of bytes is also available.
+ * skeinUpdateBits(&ctx, message, msgLength);
+ * 
+ * // Now get the result of the Skein hash. The output buffer must be
+ * // large enough to hold the request number of output bits. The application
+ * // may now extract the bits.
+ * skeinFinal(&ctx, result);
+ * ...
+ * @endcode
+ * 
+ * An application may use @c skeinReset to reset a Skein context and use
+ * it for creation of another hash with the same Skein state size and output
+ * bit length. In this case the API implementation restores some internal
+ * internal state data and saves a full Skein initialization round.
+ * 
+ * To create a MAC the application just uses @c skeinMacInit instead of 
+ * @c skeinInit. All other functions calls remain the same.
+ * 
+ */
+
+#include <skein.h>
+#include <stdint.h>
+
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
+    /**
+     * Which Skein size to use
+     */
+    typedef enum SkeinSize {
+        Skein256 = 256,     /*!< Skein with 256 bit state */
+        Skein512 = 512,     /*!< Skein with 512 bit state */
+        Skein1024 = 1024    /*!< Skein with 1024 bit state */
+    } SkeinSize_t;
+
+    /**
+     * Context for Skein.
+     *
+     * This structure was setup with some know-how of the internal
+     * Skein structures, in particular ordering of header and size dependent
+     * variables. If Skein implementation changes this, then adapt these
+     * structures as well.
+     */
+    typedef struct SkeinCtx {
+        u64b_t skeinSize;
+        u64b_t  XSave[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
+        union {
+            Skein_Ctxt_Hdr_t h;
+            Skein_256_Ctxt_t s256;
+            Skein_512_Ctxt_t s512;
+            Skein1024_Ctxt_t s1024;
+        } m;
+    } SkeinCtx_t;
+
+    /**
+     * Prepare a Skein context.
+     * 
+     * An application must call this function before it can use the Skein
+     * context. The functions clears memory and initializes size dependent
+     * variables.
+     *
+     * @param ctx
+     *     Pointer to a Skein context.
+     * @param size
+     *     Which Skein size to use.
+     * @return
+     *     SKEIN_SUCESS of SKEIN_FAIL
+     */
+    int skeinCtxPrepare(SkeinCtx_t* ctx, SkeinSize_t size);
+
+    /**
+     * Initialize a Skein context.
+     *
+     * Initializes the context with this data and saves the resulting Skein 
+     * state variables for further use.
+     *
+     * @param ctx
+     *     Pointer to a Skein context.
+     * @param hashBitLen
+     *     Number of MAC hash bits to compute
+     * @return
+     *     SKEIN_SUCESS of SKEIN_FAIL
+     * @see skeinReset
+     */
+    int skeinInit(SkeinCtx_t* ctx, size_t hashBitLen);
+
+    /**
+     * Resets a Skein context for further use.
+     * 
+     * Restores the saved chaining variables to reset the Skein context. 
+     * Thus applications can reuse the same setup to  process several 
+     * messages. This saves a complete Skein initialization cycle.
+     * 
+     * @param ctx
+     *     Pointer to a pre-initialized Skein MAC context
+     */
+    void skeinReset(SkeinCtx_t* ctx);
+    
+    /**
+     * Initializes a Skein context for MAC usage.
+     * 
+     * Initializes the context with this data and saves the resulting Skein 
+     * state variables for further use.
+     *
+     * Applications call the normal Skein functions to update the MAC and
+     * get the final result.
+     *
+     * @param ctx
+     *     Pointer to an empty or preinitialized Skein MAC context
+     * @param key
+     *     Pointer to key bytes or NULL
+     * @param keyLen
+     *     Length of the key in bytes or zero
+     * @param hashBitLen
+     *     Number of MAC hash bits to compute
+     * @return
+     *     SKEIN_SUCESS of SKEIN_FAIL
+     */
+    int skeinMacInit(SkeinCtx_t* ctx, const uint8_t *key, size_t keyLen,
+                     size_t hashBitLen);
+
+    /**
+     * Update Skein with the next part of the message.
+     *
+     * @param ctx
+     *     Pointer to initialized Skein context
+     * @param msg
+     *     Pointer to the message.
+     * @param msgByteCnt
+     *     Length of the message in @b bytes
+     * @return
+     *     Success or error code.
+     */
+    int skeinUpdate(SkeinCtx_t *ctx, const uint8_t *msg,
+                    size_t msgByteCnt);
+
+    /**
+     * Update the hash with a message bit string.
+     *
+     * Skein can handle data not only as bytes but also as bit strings of
+     * arbitrary length (up to its maximum design size).
+     *
+     * @param ctx
+     *     Pointer to initialized Skein context
+     * @param msg
+     *     Pointer to the message.
+     * @param msgBitCnt
+     *     Length of the message in @b bits.
+     */
+    int skeinUpdateBits(SkeinCtx_t *ctx, const uint8_t *msg,
+                        size_t msgBitCnt);
+
+    /**
+     * Finalize Skein and return the hash.
+     * 
+     * Before an application can reuse a Skein setup the application must
+     * reset the Skein context.
+     *
+     * @param ctx
+     *     Pointer to initialized Skein context
+     * @param hash
+     *     Pointer to buffer that receives the hash. The buffer must be large
+     *     enough to store @c hashBitLen bits.
+     * @return
+     *     Success or error code.
+     * @see skeinReset
+     */
+    int skeinFinal(SkeinCtx_t* ctx, uint8_t* hash);
+
+#ifdef __cplusplus
+}
+#endif
+
+/**
+ * @}
+ */
+#endif
diff --git a/drivers/staging/skein/include/skein_iv.h b/drivers/staging/skein/include/skein_iv.h
new file mode 100644
index 000000000000..555ea619500b
--- /dev/null
+++ b/drivers/staging/skein/include/skein_iv.h
@@ -0,0 +1,199 @@
+#ifndef _SKEIN_IV_H_
+#define _SKEIN_IV_H_
+
+#include <skein.h>    /* get Skein macros and types */
+
+/*
+***************** Pre-computed Skein IVs *******************
+**
+** NOTE: these values are not "magic" constants, but
+** are generated using the Threefish block function.
+** They are pre-computed here only for speed; i.e., to
+** avoid the need for a Threefish call during Init().
+**
+** The IV for any fixed hash length may be pre-computed.
+** Only the most common values are included here.
+**
+************************************************************
+**/
+
+#define MK_64 SKEIN_MK_64
+
+/* blkSize =  256 bits. hashSize =  128 bits */
+const u64b_t SKEIN_256_IV_128[] =
+    {
+    MK_64(0xE1111906,0x964D7260),
+    MK_64(0x883DAAA7,0x7C8D811C),
+    MK_64(0x10080DF4,0x91960F7A),
+    MK_64(0xCCF7DDE5,0xB45BC1C2)
+    };
+
+/* blkSize =  256 bits. hashSize =  160 bits */
+const u64b_t SKEIN_256_IV_160[] =
+    {
+    MK_64(0x14202314,0x72825E98),
+    MK_64(0x2AC4E9A2,0x5A77E590),
+    MK_64(0xD47A5856,0x8838D63E),
+    MK_64(0x2DD2E496,0x8586AB7D)
+    };
+
+/* blkSize =  256 bits. hashSize =  224 bits */
+const u64b_t SKEIN_256_IV_224[] =
+    {
+    MK_64(0xC6098A8C,0x9AE5EA0B),
+    MK_64(0x876D5686,0x08C5191C),
+    MK_64(0x99CB88D7,0xD7F53884),
+    MK_64(0x384BDDB1,0xAEDDB5DE)
+    };
+
+/* blkSize =  256 bits. hashSize =  256 bits */
+const u64b_t SKEIN_256_IV_256[] =
+    {
+    MK_64(0xFC9DA860,0xD048B449),
+    MK_64(0x2FCA6647,0x9FA7D833),
+    MK_64(0xB33BC389,0x6656840F),
+    MK_64(0x6A54E920,0xFDE8DA69)
+    };
+
+/* blkSize =  512 bits. hashSize =  128 bits */
+const u64b_t SKEIN_512_IV_128[] =
+    {
+    MK_64(0xA8BC7BF3,0x6FBF9F52),
+    MK_64(0x1E9872CE,0xBD1AF0AA),
+    MK_64(0x309B1790,0xB32190D3),
+    MK_64(0xBCFBB854,0x3F94805C),
+    MK_64(0x0DA61BCD,0x6E31B11B),
+    MK_64(0x1A18EBEA,0xD46A32E3),
+    MK_64(0xA2CC5B18,0xCE84AA82),
+    MK_64(0x6982AB28,0x9D46982D)
+    };
+
+/* blkSize =  512 bits. hashSize =  160 bits */
+const u64b_t SKEIN_512_IV_160[] =
+    {
+    MK_64(0x28B81A2A,0xE013BD91),
+    MK_64(0xC2F11668,0xB5BDF78F),
+    MK_64(0x1760D8F3,0xF6A56F12),
+    MK_64(0x4FB74758,0x8239904F),
+    MK_64(0x21EDE07F,0x7EAF5056),
+    MK_64(0xD908922E,0x63ED70B8),
+    MK_64(0xB8EC76FF,0xECCB52FA),
+    MK_64(0x01A47BB8,0xA3F27A6E)
+    };
+
+/* blkSize =  512 bits. hashSize =  224 bits */
+const u64b_t SKEIN_512_IV_224[] =
+    {
+    MK_64(0xCCD06162,0x48677224),
+    MK_64(0xCBA65CF3,0xA92339EF),
+    MK_64(0x8CCD69D6,0x52FF4B64),
+    MK_64(0x398AED7B,0x3AB890B4),
+    MK_64(0x0F59D1B1,0x457D2BD0),
+    MK_64(0x6776FE65,0x75D4EB3D),
+    MK_64(0x99FBC70E,0x997413E9),
+    MK_64(0x9E2CFCCF,0xE1C41EF7)
+    };
+
+/* blkSize =  512 bits. hashSize =  256 bits */
+const u64b_t SKEIN_512_IV_256[] =
+    {
+    MK_64(0xCCD044A1,0x2FDB3E13),
+    MK_64(0xE8359030,0x1A79A9EB),
+    MK_64(0x55AEA061,0x4F816E6F),
+    MK_64(0x2A2767A4,0xAE9B94DB),
+    MK_64(0xEC06025E,0x74DD7683),
+    MK_64(0xE7A436CD,0xC4746251),
+    MK_64(0xC36FBAF9,0x393AD185),
+    MK_64(0x3EEDBA18,0x33EDFC13)
+    };
+
+/* blkSize =  512 bits. hashSize =  384 bits */
+const u64b_t SKEIN_512_IV_384[] =
+    {
+    MK_64(0xA3F6C6BF,0x3A75EF5F),
+    MK_64(0xB0FEF9CC,0xFD84FAA4),
+    MK_64(0x9D77DD66,0x3D770CFE),
+    MK_64(0xD798CBF3,0xB468FDDA),
+    MK_64(0x1BC4A666,0x8A0E4465),
+    MK_64(0x7ED7D434,0xE5807407),
+    MK_64(0x548FC1AC,0xD4EC44D6),
+    MK_64(0x266E1754,0x6AA18FF8)
+    };
+
+/* blkSize =  512 bits. hashSize =  512 bits */
+const u64b_t SKEIN_512_IV_512[] =
+    {
+    MK_64(0x4903ADFF,0x749C51CE),
+    MK_64(0x0D95DE39,0x9746DF03),
+    MK_64(0x8FD19341,0x27C79BCE),
+    MK_64(0x9A255629,0xFF352CB1),
+    MK_64(0x5DB62599,0xDF6CA7B0),
+    MK_64(0xEABE394C,0xA9D5C3F4),
+    MK_64(0x991112C7,0x1A75B523),
+    MK_64(0xAE18A40B,0x660FCC33)
+    };
+
+/* blkSize = 1024 bits. hashSize =  384 bits */
+const u64b_t SKEIN1024_IV_384[] =
+    {
+    MK_64(0x5102B6B8,0xC1894A35),
+    MK_64(0xFEEBC9E3,0xFE8AF11A),
+    MK_64(0x0C807F06,0xE32BED71),
+    MK_64(0x60C13A52,0xB41A91F6),
+    MK_64(0x9716D35D,0xD4917C38),
+    MK_64(0xE780DF12,0x6FD31D3A),
+    MK_64(0x797846B6,0xC898303A),
+    MK_64(0xB172C2A8,0xB3572A3B),
+    MK_64(0xC9BC8203,0xA6104A6C),
+    MK_64(0x65909338,0xD75624F4),
+    MK_64(0x94BCC568,0x4B3F81A0),
+    MK_64(0x3EBBF51E,0x10ECFD46),
+    MK_64(0x2DF50F0B,0xEEB08542),
+    MK_64(0x3B5A6530,0x0DBC6516),
+    MK_64(0x484B9CD2,0x167BBCE1),
+    MK_64(0x2D136947,0xD4CBAFEA)
+    };
+
+/* blkSize = 1024 bits. hashSize =  512 bits */
+const u64b_t SKEIN1024_IV_512[] =
+    {
+    MK_64(0xCAEC0E5D,0x7C1B1B18),
+    MK_64(0xA01B0E04,0x5F03E802),
+    MK_64(0x33840451,0xED912885),
+    MK_64(0x374AFB04,0xEAEC2E1C),
+    MK_64(0xDF25A0E2,0x813581F7),
+    MK_64(0xE4004093,0x8B12F9D2),
+    MK_64(0xA662D539,0xC2ED39B6),
+    MK_64(0xFA8B85CF,0x45D8C75A),
+    MK_64(0x8316ED8E,0x29EDE796),
+    MK_64(0x053289C0,0x2E9F91B8),
+    MK_64(0xC3F8EF1D,0x6D518B73),
+    MK_64(0xBDCEC3C4,0xD5EF332E),
+    MK_64(0x549A7E52,0x22974487),
+    MK_64(0x67070872,0x5B749816),
+    MK_64(0xB9CD28FB,0xF0581BD1),
+    MK_64(0x0E2940B8,0x15804974)
+    };
+
+/* blkSize = 1024 bits. hashSize = 1024 bits */
+const u64b_t SKEIN1024_IV_1024[] =
+    {
+    MK_64(0xD593DA07,0x41E72355),
+    MK_64(0x15B5E511,0xAC73E00C),
+    MK_64(0x5180E5AE,0xBAF2C4F0),
+    MK_64(0x03BD41D3,0xFCBCAFAF),
+    MK_64(0x1CAEC6FD,0x1983A898),
+    MK_64(0x6E510B8B,0xCDD0589F),
+    MK_64(0x77E2BDFD,0xC6394ADA),
+    MK_64(0xC11E1DB5,0x24DCB0A3),
+    MK_64(0xD6D14AF9,0xC6329AB5),
+    MK_64(0x6A9B0BFC,0x6EB67E0D),
+    MK_64(0x9243C60D,0xCCFF1332),
+    MK_64(0x1A1F1DDE,0x743F02D4),
+    MK_64(0x0996753C,0x10ED0BB8),
+    MK_64(0x6572DD22,0xF2B4969A),
+    MK_64(0x61FD3062,0xD00A579A),
+    MK_64(0x1DE0536E,0x8682E539)
+    };
+
+#endif /* _SKEIN_IV_H_ */
diff --git a/drivers/staging/skein/include/skein_port.h b/drivers/staging/skein/include/skein_port.h
new file mode 100644
index 000000000000..18d892553c8d
--- /dev/null
+++ b/drivers/staging/skein/include/skein_port.h
@@ -0,0 +1,124 @@
+#ifndef _SKEIN_PORT_H_
+#define _SKEIN_PORT_H_
+/*******************************************************************
+**
+** Platform-specific definitions for Skein hash function.
+**
+** Source code author: Doug Whiting, 2008.
+**
+** This algorithm and source code is released to the public domain.
+**
+** Many thanks to Brian Gladman for his portable header files.
+**
+** To port Skein to an "unsupported" platform, change the definitions
+** in this file appropriately.
+** 
+********************************************************************/
+
+#include <brg_types.h>                      /* get integer type definitions */
+
+typedef unsigned int    uint_t;             /* native unsigned integer */
+typedef uint_8t         u08b_t;             /*  8-bit unsigned integer */
+typedef uint_64t        u64b_t;             /* 64-bit unsigned integer */
+
+#ifndef RotL_64
+#define RotL_64(x,N)    (((x) << (N)) | ((x) >> (64-(N))))
+#endif
+
+/*
+ * Skein is "natively" little-endian (unlike SHA-xxx), for optimal
+ * performance on x86 CPUs.  The Skein code requires the following
+ * definitions for dealing with endianness:
+ *
+ *    SKEIN_NEED_SWAP:  0 for little-endian, 1 for big-endian
+ *    Skein_Put64_LSB_First
+ *    Skein_Get64_LSB_First
+ *    Skein_Swap64
+ *
+ * If SKEIN_NEED_SWAP is defined at compile time, it is used here
+ * along with the portable versions of Put64/Get64/Swap64, which 
+ * are slow in general.
+ *
+ * Otherwise, an "auto-detect" of endianness is attempted below.
+ * If the default handling doesn't work well, the user may insert
+ * platform-specific code instead (e.g., for big-endian CPUs).
+ *
+ */
+#ifndef SKEIN_NEED_SWAP /* compile-time "override" for endianness? */
+
+#include <brg_endian.h>              /* get endianness selection */
+#if   PLATFORM_BYTE_ORDER == IS_BIG_ENDIAN
+    /* here for big-endian CPUs */
+#define SKEIN_NEED_SWAP   (1)
+#elif PLATFORM_BYTE_ORDER == IS_LITTLE_ENDIAN
+    /* here for x86 and x86-64 CPUs (and other detected little-endian CPUs) */
+#define SKEIN_NEED_SWAP   (0)
+#if   PLATFORM_MUST_ALIGN == 0              /* ok to use "fast" versions? */
+#define Skein_Put64_LSB_First(dst08,src64,bCnt) memcpy(dst08,src64,bCnt)
+#define Skein_Get64_LSB_First(dst64,src08,wCnt) memcpy(dst64,src08,8*(wCnt))
+#endif
+#else
+#error "Skein needs endianness setting!"
+#endif
+
+#endif /* ifndef SKEIN_NEED_SWAP */
+
+/*
+ ******************************************************************
+ *      Provide any definitions still needed.
+ ******************************************************************
+ */
+#ifndef Skein_Swap64  /* swap for big-endian, nop for little-endian */
+#if     SKEIN_NEED_SWAP
+#define Skein_Swap64(w64)                       \
+  ( (( ((u64b_t)(w64))       & 0xFF) << 56) |   \
+    (((((u64b_t)(w64)) >> 8) & 0xFF) << 48) |   \
+    (((((u64b_t)(w64)) >>16) & 0xFF) << 40) |   \
+    (((((u64b_t)(w64)) >>24) & 0xFF) << 32) |   \
+    (((((u64b_t)(w64)) >>32) & 0xFF) << 24) |   \
+    (((((u64b_t)(w64)) >>40) & 0xFF) << 16) |   \
+    (((((u64b_t)(w64)) >>48) & 0xFF) <<  8) |   \
+    (((((u64b_t)(w64)) >>56) & 0xFF)      ) )
+#else
+#define Skein_Swap64(w64)  (w64)
+#endif
+#endif  /* ifndef Skein_Swap64 */
+
+
+#ifndef Skein_Put64_LSB_First
+void    Skein_Put64_LSB_First(u08b_t *dst,const u64b_t *src,size_t bCnt)
+#ifdef  SKEIN_PORT_CODE /* instantiate the function code here? */
+    { /* this version is fully portable (big-endian or little-endian), but slow */
+    size_t n;
+
+    for (n=0;n<bCnt;n++)
+        dst[n] = (u08b_t) (src[n>>3] >> (8*(n&7)));
+    }
+#else
+    ;    /* output only the function prototype */
+#endif
+#endif   /* ifndef Skein_Put64_LSB_First */
+
+
+#ifndef Skein_Get64_LSB_First
+void    Skein_Get64_LSB_First(u64b_t *dst,const u08b_t *src,size_t wCnt)
+#ifdef  SKEIN_PORT_CODE /* instantiate the function code here? */
+    { /* this version is fully portable (big-endian or little-endian), but slow */
+    size_t n;
+
+    for (n=0;n<8*wCnt;n+=8)
+        dst[n/8] = (((u64b_t) src[n  ])      ) +
+                   (((u64b_t) src[n+1]) <<  8) +
+                   (((u64b_t) src[n+2]) << 16) +
+                   (((u64b_t) src[n+3]) << 24) +
+                   (((u64b_t) src[n+4]) << 32) +
+                   (((u64b_t) src[n+5]) << 40) +
+                   (((u64b_t) src[n+6]) << 48) +
+                   (((u64b_t) src[n+7]) << 56) ;
+    }
+#else
+    ;    /* output only the function prototype */
+#endif
+#endif   /* ifndef Skein_Get64_LSB_First */
+
+#endif   /* ifndef _SKEIN_PORT_H_ */
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
new file mode 100644
index 000000000000..85afd72fe987
--- /dev/null
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -0,0 +1,167 @@
+
+#ifndef THREEFISHAPI_H
+#define THREEFISHAPI_H
+
+/**
+ * @file threefishApi.h
+ * @brief A Threefish cipher API and its functions.
+ * @{
+ *
+ * This API and the functions that implement this API simplify the usage
+ * of the Threefish cipher. The design and the way to use the functions 
+ * follow the openSSL design but at the same time take care of some Threefish
+ * specific behaviour and possibilities.
+ *
+ * These are the low level functions that deal with Threefisch blocks only.
+ * Implementations for cipher modes such as ECB, CFB, or CBC may use these 
+ * functions.
+ * 
+@code
+    // Threefish cipher context data
+    ThreefishKey_t keyCtx;
+
+    // Initialize the context
+    threefishSetKey(&keyCtx, Threefish512, key, tweak);
+
+    // Encrypt
+    threefishEncryptBlockBytes(&keyCtx, input, cipher);
+@endcode
+ */
+
+#include <skein.h>
+#include <stdint.h>
+
+#define KeyScheduleConst 0x1BD11BDAA9FC1A22L
+
+#ifdef __cplusplus
+extern "C"
+{
+#endif
+
+    /**
+     * Which Threefish size to use
+     */
+    typedef enum ThreefishSize {
+        Threefish256 = 256,     /*!< Skein with 256 bit state */
+        Threefish512 = 512,     /*!< Skein with 512 bit state */
+        Threefish1024 = 1024    /*!< Skein with 1024 bit state */
+    } ThreefishSize_t;
+    
+    /**
+     * Context for Threefish key and tweak words.
+     * 
+     * This structure was setup with some know-how of the internal
+     * Skein structures, in particular ordering of header and size dependent
+     * variables. If Skein implementation changes this, the adapt these
+     * structures as well.
+     */
+    typedef struct ThreefishKey {
+        u64b_t stateSize;
+        u64b_t key[SKEIN_MAX_STATE_WORDS+1];   /* max number of key words*/
+        u64b_t tweak[3];
+    } ThreefishKey_t;
+
+    /**
+     * Set Threefish key and tweak data.
+     * 
+     * This function sets the key and tweak data for the Threefish cipher of
+     * the given size. The key data must have the same length (number of bits)
+     * as the state size 
+     *
+     * @param keyCtx
+     *     Pointer to a Threefish key structure.
+     * @param size
+     *     Which Skein size to use.
+     * @param keyData
+     *     Pointer to the key words (word has 64 bits).
+     * @param tweak
+     *     Pointer to the two tweak words (word has 64 bits).
+     */
+    void threefishSetKey(ThreefishKey_t* keyCtx, ThreefishSize_t stateSize, uint64_t* keyData, uint64_t* tweak);
+    
+    /**
+     * Encrypt Threefisch block (bytes).
+     * 
+     * The buffer must have at least the same length (number of bits) aas the 
+     * state size for this key. The function uses the first @c stateSize bits
+     * of the input buffer, encrypts them and stores the result in the output
+     * buffer.
+     * 
+     * @param keyCtx
+     *     Pointer to a Threefish key structure.
+     * @param in
+     *     Poionter to plaintext data buffer.
+     * @param out
+     *     Pointer to cipher buffer.
+     */
+    void threefishEncryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in, uint8_t* out);
+    
+    /**
+     * Encrypt Threefisch block (words).
+     * 
+     * The buffer must have at least the same length (number of bits) aas the 
+     * state size for this key. The function uses the first @c stateSize bits
+     * of the input buffer, encrypts them and stores the result in the output
+     * buffer.
+     * 
+     * The wordsize ist set to 64 bits.
+     * 
+     * @param keyCtx
+     *     Pointer to a Threefish key structure.
+     * @param in
+     *     Poionter to plaintext data buffer.
+     * @param out
+     *     Pointer to cipher buffer.
+     */
+    void threefishEncryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in, uint64_t* out);
+
+    /**
+     * Decrypt Threefisch block (bytes).
+     * 
+     * The buffer must have at least the same length (number of bits) aas the 
+     * state size for this key. The function uses the first @c stateSize bits
+     * of the input buffer, decrypts them and stores the result in the output
+     * buffer
+     * 
+     * @param keyCtx
+     *     Pointer to a Threefish key structure.
+     * @param in
+     *     Poionter to cipher data buffer.
+     * @param out
+     *     Pointer to plaintext buffer.
+     */
+    void threefishDecryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in, uint8_t* out);
+
+    /**
+     * Decrypt Threefisch block (words).
+     * 
+     * The buffer must have at least the same length (number of bits) aas the 
+     * state size for this key. The function uses the first @c stateSize bits
+     * of the input buffer, encrypts them and stores the result in the output
+     * buffer.
+     * 
+     * The wordsize ist set to 64 bits.
+     * 
+     * @param keyCtx
+     *     Pointer to a Threefish key structure.
+     * @param in
+     *     Poionter to cipher data buffer.
+     * @param out
+     *     Pointer to plaintext buffer.
+     */
+    void threefishDecryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in, uint64_t* out);
+
+    void threefishEncrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishEncrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishEncrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishDecrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishDecrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishDecrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
+#ifdef __cplusplus
+}
+#endif
+
+/**
+ * @}
+ */
+#endif
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
new file mode 100644
index 000000000000..f0b176ac1dc7
--- /dev/null
+++ b/drivers/staging/skein/skein.c
@@ -0,0 +1,742 @@
+/***********************************************************************
+**
+** Implementation of the Skein hash function.
+**
+** Source code author: Doug Whiting, 2008.
+**
+** This algorithm and source code is released to the public domain.
+**
+************************************************************************/
+
+#define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
+
+#include <string.h>       /* get the memcpy/memset functions */
+#include <skein.h> /* get the Skein API definitions   */
+#include <skein_iv.h>    /* get precomputed IVs */
+
+/*****************************************************************/
+/* External function to process blkCnt (nonzero) full block(s) of data. */
+void    Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd);
+
+/*****************************************************************/
+/*     256-bit Skein                                             */
+/*****************************************************************/
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a straight hashing operation  */
+int Skein_256_Init(Skein_256_Ctxt_t *ctx, size_t hashBitLen)
+{
+    union
+    {
+        u08b_t  b[SKEIN_256_STATE_BYTES];
+        u64b_t  w[SKEIN_256_STATE_WORDS];
+    } cfg;                              /* config block */
+
+    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
+
+    switch (hashBitLen)
+    {             /* use pre-computed values, where available */
+    case  256:
+        memcpy(ctx->X,SKEIN_256_IV_256,sizeof(ctx->X));
+        break;
+    case  224:
+        memcpy(ctx->X,SKEIN_256_IV_224,sizeof(ctx->X));
+        break;
+    case  160:
+        memcpy(ctx->X,SKEIN_256_IV_160,sizeof(ctx->X));
+        break;
+    case  128:
+        memcpy(ctx->X,SKEIN_256_IV_128,sizeof(ctx->X));
+        break;
+    default:
+        /* here if there is no precomputed IV value available */
+        /* build/process the config block, type == CONFIG (could be precomputed) */
+        Skein_Start_New_Type(ctx,CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
+
+        cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
+        cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+        cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+        memset(&cfg.w[3],0,sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+
+        /* compute the initial chaining values from config block */
+        memset(ctx->X,0,sizeof(ctx->X));            /* zero the chaining variables */
+        Skein_256_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+        break;
+    }
+    /* The chaining vars ctx->X are now initialized for the given hashBitLen. */
+    /* Set up to process the data message portion of the hash (default) */
+    Skein_Start_New_Type(ctx,MSG);              /* T0=0, T1= MSG type */
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a MAC and/or tree hash operation */
+/* [identical to Skein_256_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int Skein_256_InitExt(Skein_256_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, const u08b_t *key, size_t keyBytes)
+{
+    union
+    {
+        u08b_t  b[SKEIN_256_STATE_BYTES];
+        u64b_t  w[SKEIN_256_STATE_WORDS];
+    } cfg;                              /* config block */
+
+    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    Skein_Assert(keyBytes == 0 || key != NULL,SKEIN_FAIL);
+
+    /* compute the initial chaining values ctx->X[], based on key */
+    if (keyBytes == 0)                          /* is there a key? */
+    {
+        memset(ctx->X,0,sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+    }
+    else                                        /* here to pre-process a key */
+    {
+        Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+        /* do a mini-Init right here */
+        ctx->h.hashBitLen=8*sizeof(ctx->X);     /* set output hash bit count = state size */
+        Skein_Start_New_Type(ctx,KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
+        memset(ctx->X,0,sizeof(ctx->X));        /* zero the initial chaining variables */
+        Skein_256_Update(ctx,key,keyBytes);     /* hash the key */
+        Skein_256_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
+        memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
+#if SKEIN_NEED_SWAP
+        {
+            uint_t i;
+            for (i=0;i<SKEIN_256_STATE_WORDS;i++)   /* convert key bytes to context words */
+                ctx->X[i] = Skein_Swap64(ctx->X[i]);
+        }
+#endif
+    }
+    /* build/process the config block, type == CONFIG (could be precomputed for each key) */
+    ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
+    Skein_Start_New_Type(ctx,CFG_FINAL);
+
+    memset(&cfg.w,0,sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+    cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+    cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+    cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+
+    Skein_Show_Key(256,&ctx->h,key,keyBytes);
+
+    /* compute the initial chaining values from config block */
+    Skein_256_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+
+    /* The chaining vars ctx->X are now initialized */
+    /* Set up to process the data message portion of the hash (default) */
+    Skein_Start_New_Type(ctx,MSG);
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* process the input bytes */
+int Skein_256_Update(Skein_256_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt)
+{
+    size_t n;
+
+    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    /* process full blocks, if any */
+    if (msgByteCnt + ctx->h.bCnt > SKEIN_256_BLOCK_BYTES)
+    {
+        if (ctx->h.bCnt)                              /* finish up any buffered message data */
+        {
+            n = SKEIN_256_BLOCK_BYTES - ctx->h.bCnt;  /* # bytes free in buffer b[] */
+            if (n)
+            {
+                Skein_assert(n < msgByteCnt);         /* check on our logic here */
+                memcpy(&ctx->b[ctx->h.bCnt],msg,n);
+                msgByteCnt  -= n;
+                msg         += n;
+                ctx->h.bCnt += n;
+            }
+            Skein_assert(ctx->h.bCnt == SKEIN_256_BLOCK_BYTES);
+            Skein_256_Process_Block(ctx,ctx->b,1,SKEIN_256_BLOCK_BYTES);
+            ctx->h.bCnt = 0;
+        }
+        /* now process any remaining full blocks, directly from input message data */
+        if (msgByteCnt > SKEIN_256_BLOCK_BYTES)
+        {
+            n = (msgByteCnt-1) / SKEIN_256_BLOCK_BYTES;   /* number of full blocks to process */
+            Skein_256_Process_Block(ctx,msg,n,SKEIN_256_BLOCK_BYTES);
+            msgByteCnt -= n * SKEIN_256_BLOCK_BYTES;
+            msg        += n * SKEIN_256_BLOCK_BYTES;
+        }
+        Skein_assert(ctx->h.bCnt == 0);
+    }
+
+    /* copy any remaining source message data bytes into b[] */
+    if (msgByteCnt)
+    {
+        Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES);
+        memcpy(&ctx->b[ctx->h.bCnt],msg,msgByteCnt);
+        ctx->h.bCnt += msgByteCnt;
+    }
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the result */
+int Skein_256_Final(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    size_t i,n,byteCnt;
+    u64b_t X[SKEIN_256_STATE_WORDS];
+    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
+    if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)            /* zero pad b[] if necessary */
+        memset(&ctx->b[ctx->h.bCnt],0,SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
+
+    Skein_256_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);  /* process the final block */
+
+    /* now output the result */
+    byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
+
+    /* run Threefish in "counter mode" to generate output */
+    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i=0;i*SKEIN_256_BLOCK_BYTES < byteCnt;i++)
+    {
+        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        Skein_Start_New_Type(ctx,OUT_FINAL);
+        Skein_256_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        n = byteCnt - i*SKEIN_256_BLOCK_BYTES;   /* number of output bytes left to go */
+        if (n >= SKEIN_256_BLOCK_BYTES)
+            n  = SKEIN_256_BLOCK_BYTES;
+        Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(256,&ctx->h,n,hashVal+i*SKEIN_256_BLOCK_BYTES);
+        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+    }
+    return SKEIN_SUCCESS;
+}
+
+/*****************************************************************/
+/*     512-bit Skein                                             */
+/*****************************************************************/
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a straight hashing operation  */
+int Skein_512_Init(Skein_512_Ctxt_t *ctx, size_t hashBitLen)
+{
+    union
+    {
+        u08b_t  b[SKEIN_512_STATE_BYTES];
+        u64b_t  w[SKEIN_512_STATE_WORDS];
+    } cfg;                              /* config block */
+
+    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
+
+    switch (hashBitLen)
+    {             /* use pre-computed values, where available */
+    case  512:
+        memcpy(ctx->X,SKEIN_512_IV_512,sizeof(ctx->X));
+        break;
+    case  384:
+        memcpy(ctx->X,SKEIN_512_IV_384,sizeof(ctx->X));
+        break;
+    case  256:
+        memcpy(ctx->X,SKEIN_512_IV_256,sizeof(ctx->X));
+        break;
+    case  224:
+        memcpy(ctx->X,SKEIN_512_IV_224,sizeof(ctx->X));
+        break;
+    default:
+        /* here if there is no precomputed IV value available */
+        /* build/process the config block, type == CONFIG (could be precomputed) */
+        Skein_Start_New_Type(ctx,CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
+
+        cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
+        cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+        cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+        memset(&cfg.w[3],0,sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+
+        /* compute the initial chaining values from config block */
+        memset(ctx->X,0,sizeof(ctx->X));            /* zero the chaining variables */
+        Skein_512_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+        break;
+    }
+
+    /* The chaining vars ctx->X are now initialized for the given hashBitLen. */
+    /* Set up to process the data message portion of the hash (default) */
+    Skein_Start_New_Type(ctx,MSG);              /* T0=0, T1= MSG type */
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a MAC and/or tree hash operation */
+/* [identical to Skein_512_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int Skein_512_InitExt(Skein_512_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, const u08b_t *key, size_t keyBytes)
+{
+    union
+    {
+        u08b_t  b[SKEIN_512_STATE_BYTES];
+        u64b_t  w[SKEIN_512_STATE_WORDS];
+    } cfg;                              /* config block */
+
+    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    Skein_Assert(keyBytes == 0 || key != NULL,SKEIN_FAIL);
+
+    /* compute the initial chaining values ctx->X[], based on key */
+    if (keyBytes == 0)                          /* is there a key? */
+    {
+        memset(ctx->X,0,sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+    }
+    else                                        /* here to pre-process a key */
+    {
+        Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+        /* do a mini-Init right here */
+        ctx->h.hashBitLen=8*sizeof(ctx->X);     /* set output hash bit count = state size */
+        Skein_Start_New_Type(ctx,KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
+        memset(ctx->X,0,sizeof(ctx->X));        /* zero the initial chaining variables */
+        Skein_512_Update(ctx,key,keyBytes);     /* hash the key */
+        Skein_512_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
+        memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
+#if SKEIN_NEED_SWAP
+        {
+            uint_t i;
+            for (i=0;i<SKEIN_512_STATE_WORDS;i++)   /* convert key bytes to context words */
+                ctx->X[i] = Skein_Swap64(ctx->X[i]);
+        }
+#endif
+    }
+    /* build/process the config block, type == CONFIG (could be precomputed for each key) */
+    ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
+    Skein_Start_New_Type(ctx,CFG_FINAL);
+
+    memset(&cfg.w,0,sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+    cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+    cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+    cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+
+    Skein_Show_Key(512,&ctx->h,key,keyBytes);
+
+    /* compute the initial chaining values from config block */
+    Skein_512_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+
+    /* The chaining vars ctx->X are now initialized */
+    /* Set up to process the data message portion of the hash (default) */
+    Skein_Start_New_Type(ctx,MSG);
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* process the input bytes */
+int Skein_512_Update(Skein_512_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt)
+{
+    size_t n;
+
+    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    /* process full blocks, if any */
+    if (msgByteCnt + ctx->h.bCnt > SKEIN_512_BLOCK_BYTES)
+    {
+        if (ctx->h.bCnt)                              /* finish up any buffered message data */
+        {
+            n = SKEIN_512_BLOCK_BYTES - ctx->h.bCnt;  /* # bytes free in buffer b[] */
+            if (n)
+            {
+                Skein_assert(n < msgByteCnt);         /* check on our logic here */
+                memcpy(&ctx->b[ctx->h.bCnt],msg,n);
+                msgByteCnt  -= n;
+                msg         += n;
+                ctx->h.bCnt += n;
+            }
+            Skein_assert(ctx->h.bCnt == SKEIN_512_BLOCK_BYTES);
+            Skein_512_Process_Block(ctx,ctx->b,1,SKEIN_512_BLOCK_BYTES);
+            ctx->h.bCnt = 0;
+        }
+        /* now process any remaining full blocks, directly from input message data */
+        if (msgByteCnt > SKEIN_512_BLOCK_BYTES)
+        {
+            n = (msgByteCnt-1) / SKEIN_512_BLOCK_BYTES;   /* number of full blocks to process */
+            Skein_512_Process_Block(ctx,msg,n,SKEIN_512_BLOCK_BYTES);
+            msgByteCnt -= n * SKEIN_512_BLOCK_BYTES;
+            msg        += n * SKEIN_512_BLOCK_BYTES;
+        }
+        Skein_assert(ctx->h.bCnt == 0);
+    }
+
+    /* copy any remaining source message data bytes into b[] */
+    if (msgByteCnt)
+    {
+        Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES);
+        memcpy(&ctx->b[ctx->h.bCnt],msg,msgByteCnt);
+        ctx->h.bCnt += msgByteCnt;
+    }
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the result */
+int Skein_512_Final(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    size_t i,n,byteCnt;
+    u64b_t X[SKEIN_512_STATE_WORDS];
+    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
+    if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)            /* zero pad b[] if necessary */
+        memset(&ctx->b[ctx->h.bCnt],0,SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
+
+    Skein_512_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);  /* process the final block */
+
+    /* now output the result */
+    byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
+
+    /* run Threefish in "counter mode" to generate output */
+    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i=0;i*SKEIN_512_BLOCK_BYTES < byteCnt;i++)
+    {
+        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        Skein_Start_New_Type(ctx,OUT_FINAL);
+        Skein_512_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        n = byteCnt - i*SKEIN_512_BLOCK_BYTES;   /* number of output bytes left to go */
+        if (n >= SKEIN_512_BLOCK_BYTES)
+            n  = SKEIN_512_BLOCK_BYTES;
+        Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(512,&ctx->h,n,hashVal+i*SKEIN_512_BLOCK_BYTES);
+        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+    }
+    return SKEIN_SUCCESS;
+}
+
+/*****************************************************************/
+/*    1024-bit Skein                                             */
+/*****************************************************************/
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a straight hashing operation  */
+int Skein1024_Init(Skein1024_Ctxt_t *ctx, size_t hashBitLen)
+{
+    union
+    {
+        u08b_t  b[SKEIN1024_STATE_BYTES];
+        u64b_t  w[SKEIN1024_STATE_WORDS];
+    } cfg;                              /* config block */
+
+    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
+
+    switch (hashBitLen)
+    {              /* use pre-computed values, where available */
+    case  512:
+        memcpy(ctx->X,SKEIN1024_IV_512 ,sizeof(ctx->X));
+        break;
+    case  384:
+        memcpy(ctx->X,SKEIN1024_IV_384 ,sizeof(ctx->X));
+        break;
+    case 1024:
+        memcpy(ctx->X,SKEIN1024_IV_1024,sizeof(ctx->X));
+        break;
+    default:
+        /* here if there is no precomputed IV value available */
+        /* build/process the config block, type == CONFIG (could be precomputed) */
+        Skein_Start_New_Type(ctx,CFG_FINAL);        /* set tweaks: T0=0; T1=CFG | FINAL */
+
+        cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);  /* set the schema, version */
+        cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+        cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+        memset(&cfg.w[3],0,sizeof(cfg) - 3*sizeof(cfg.w[0])); /* zero pad config block */
+
+        /* compute the initial chaining values from config block */
+        memset(ctx->X,0,sizeof(ctx->X));            /* zero the chaining variables */
+        Skein1024_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+        break;
+    }
+
+    /* The chaining vars ctx->X are now initialized for the given hashBitLen. */
+    /* Set up to process the data message portion of the hash (default) */
+    Skein_Start_New_Type(ctx,MSG);              /* T0=0, T1= MSG type */
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* init the context for a MAC and/or tree hash operation */
+/* [identical to Skein1024_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int Skein1024_InitExt(Skein1024_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, const u08b_t *key, size_t keyBytes)
+{
+    union
+    {
+        u08b_t  b[SKEIN1024_STATE_BYTES];
+        u64b_t  w[SKEIN1024_STATE_WORDS];
+    } cfg;                              /* config block */
+
+    Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
+    Skein_Assert(keyBytes == 0 || key != NULL,SKEIN_FAIL);
+
+    /* compute the initial chaining values ctx->X[], based on key */
+    if (keyBytes == 0)                          /* is there a key? */
+    {
+        memset(ctx->X,0,sizeof(ctx->X));        /* no key: use all zeroes as key for config block */
+    }
+    else                                        /* here to pre-process a key */
+    {
+        Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+        /* do a mini-Init right here */
+        ctx->h.hashBitLen=8*sizeof(ctx->X);     /* set output hash bit count = state size */
+        Skein_Start_New_Type(ctx,KEY);          /* set tweaks: T0 = 0; T1 = KEY type */
+        memset(ctx->X,0,sizeof(ctx->X));        /* zero the initial chaining variables */
+        Skein1024_Update(ctx,key,keyBytes);     /* hash the key */
+        Skein1024_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
+        memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
+#if SKEIN_NEED_SWAP
+        {
+            uint_t i;
+            for (i=0;i<SKEIN1024_STATE_WORDS;i++)   /* convert key bytes to context words */
+                ctx->X[i] = Skein_Swap64(ctx->X[i]);
+        }
+#endif
+    }
+    /* build/process the config block, type == CONFIG (could be precomputed for each key) */
+    ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
+    Skein_Start_New_Type(ctx,CFG_FINAL);
+
+    memset(&cfg.w,0,sizeof(cfg.w));             /* pre-pad cfg.w[] with zeroes */
+    cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+    cfg.w[1] = Skein_Swap64(hashBitLen);        /* hash result length in bits */
+    cfg.w[2] = Skein_Swap64(treeInfo);          /* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
+
+    Skein_Show_Key(1024,&ctx->h,key,keyBytes);
+
+    /* compute the initial chaining values from config block */
+    Skein1024_Process_Block(ctx,cfg.b,1,SKEIN_CFG_STR_LEN);
+
+    /* The chaining vars ctx->X are now initialized */
+    /* Set up to process the data message portion of the hash (default) */
+    Skein_Start_New_Type(ctx,MSG);
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* process the input bytes */
+int Skein1024_Update(Skein1024_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt)
+{
+    size_t n;
+
+    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    /* process full blocks, if any */
+    if (msgByteCnt + ctx->h.bCnt > SKEIN1024_BLOCK_BYTES)
+    {
+        if (ctx->h.bCnt)                              /* finish up any buffered message data */
+        {
+            n = SKEIN1024_BLOCK_BYTES - ctx->h.bCnt;  /* # bytes free in buffer b[] */
+            if (n)
+            {
+                Skein_assert(n < msgByteCnt);         /* check on our logic here */
+                memcpy(&ctx->b[ctx->h.bCnt],msg,n);
+                msgByteCnt  -= n;
+                msg         += n;
+                ctx->h.bCnt += n;
+            }
+            Skein_assert(ctx->h.bCnt == SKEIN1024_BLOCK_BYTES);
+            Skein1024_Process_Block(ctx,ctx->b,1,SKEIN1024_BLOCK_BYTES);
+            ctx->h.bCnt = 0;
+        }
+        /* now process any remaining full blocks, directly from input message data */
+        if (msgByteCnt > SKEIN1024_BLOCK_BYTES)
+        {
+            n = (msgByteCnt-1) / SKEIN1024_BLOCK_BYTES;   /* number of full blocks to process */
+            Skein1024_Process_Block(ctx,msg,n,SKEIN1024_BLOCK_BYTES);
+            msgByteCnt -= n * SKEIN1024_BLOCK_BYTES;
+            msg        += n * SKEIN1024_BLOCK_BYTES;
+        }
+        Skein_assert(ctx->h.bCnt == 0);
+    }
+
+    /* copy any remaining source message data bytes into b[] */
+    if (msgByteCnt)
+    {
+        Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES);
+        memcpy(&ctx->b[ctx->h.bCnt],msg,msgByteCnt);
+        ctx->h.bCnt += msgByteCnt;
+    }
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the result */
+int Skein1024_Final(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    size_t i,n,byteCnt;
+    u64b_t X[SKEIN1024_STATE_WORDS];
+    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
+    if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)            /* zero pad b[] if necessary */
+        memset(&ctx->b[ctx->h.bCnt],0,SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
+
+    Skein1024_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);  /* process the final block */
+
+    /* now output the result */
+    byteCnt = (ctx->h.hashBitLen + 7) >> 3;             /* total number of output bytes */
+
+    /* run Threefish in "counter mode" to generate output */
+    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i=0;i*SKEIN1024_BLOCK_BYTES < byteCnt;i++)
+    {
+        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        Skein_Start_New_Type(ctx,OUT_FINAL);
+        Skein1024_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        n = byteCnt - i*SKEIN1024_BLOCK_BYTES;   /* number of output bytes left to go */
+        if (n >= SKEIN1024_BLOCK_BYTES)
+            n  = SKEIN1024_BLOCK_BYTES;
+        Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(1024,&ctx->h,n,hashVal+i*SKEIN1024_BLOCK_BYTES);
+        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+    }
+    return SKEIN_SUCCESS;
+}
+
+/**************** Functions to support MAC/tree hashing ***************/
+/*   (this code is identical for Optimized and Reference versions)    */
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the block, no OUTPUT stage */
+int Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
+    if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)   /* zero pad b[] if necessary */
+        memset(&ctx->b[ctx->h.bCnt],0,SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
+    Skein_256_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);    /* process the final block */
+
+    Skein_Put64_LSB_First(hashVal,ctx->X,SKEIN_256_BLOCK_BYTES);   /* "output" the state bytes */
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the block, no OUTPUT stage */
+int Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
+    if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)   /* zero pad b[] if necessary */
+        memset(&ctx->b[ctx->h.bCnt],0,SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
+    Skein_512_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);    /* process the final block */
+
+    Skein_Put64_LSB_First(hashVal,ctx->X,SKEIN_512_BLOCK_BYTES);   /* "output" the state bytes */
+
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* finalize the hash computation and output the block, no OUTPUT stage */
+int Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;        /* tag as the final block */
+    if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)   /* zero pad b[] if necessary */
+        memset(&ctx->b[ctx->h.bCnt],0,SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
+    Skein1024_Process_Block(ctx,ctx->b,1,ctx->h.bCnt);    /* process the final block */
+
+    Skein_Put64_LSB_First(hashVal,ctx->X,SKEIN1024_BLOCK_BYTES);   /* "output" the state bytes */
+
+    return SKEIN_SUCCESS;
+}
+
+#if SKEIN_TREE_HASH
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* just do the OUTPUT stage                                       */
+int Skein_256_Output(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    size_t i,n,byteCnt;
+    u64b_t X[SKEIN_256_STATE_WORDS];
+    Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    /* now output the result */
+    byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
+
+    /* run Threefish in "counter mode" to generate output */
+    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i=0;i*SKEIN_256_BLOCK_BYTES < byteCnt;i++)
+    {
+        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        Skein_Start_New_Type(ctx,OUT_FINAL);
+        Skein_256_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        n = byteCnt - i*SKEIN_256_BLOCK_BYTES;   /* number of output bytes left to go */
+        if (n >= SKEIN_256_BLOCK_BYTES)
+            n  = SKEIN_256_BLOCK_BYTES;
+        Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(256,&ctx->h,n,hashVal+i*SKEIN_256_BLOCK_BYTES);
+        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+    }
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* just do the OUTPUT stage                                       */
+int Skein_512_Output(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    size_t i,n,byteCnt;
+    u64b_t X[SKEIN_512_STATE_WORDS];
+    Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    /* now output the result */
+    byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
+
+    /* run Threefish in "counter mode" to generate output */
+    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i=0;i*SKEIN_512_BLOCK_BYTES < byteCnt;i++)
+    {
+        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        Skein_Start_New_Type(ctx,OUT_FINAL);
+        Skein_512_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        n = byteCnt - i*SKEIN_512_BLOCK_BYTES;   /* number of output bytes left to go */
+        if (n >= SKEIN_512_BLOCK_BYTES)
+            n  = SKEIN_512_BLOCK_BYTES;
+        Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(256,&ctx->h,n,hashVal+i*SKEIN_512_BLOCK_BYTES);
+        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+    }
+    return SKEIN_SUCCESS;
+}
+
+/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+/* just do the OUTPUT stage                                       */
+int Skein1024_Output(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
+{
+    size_t i,n,byteCnt;
+    u64b_t X[SKEIN1024_STATE_WORDS];
+    Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
+
+    /* now output the result */
+    byteCnt = (ctx->h.hashBitLen + 7) >> 3;    /* total number of output bytes */
+
+    /* run Threefish in "counter mode" to generate output */
+    memset(ctx->b,0,sizeof(ctx->b));  /* zero out b[], so it can hold the counter */
+    memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
+    for (i=0;i*SKEIN1024_BLOCK_BYTES < byteCnt;i++)
+    {
+        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        Skein_Start_New_Type(ctx,OUT_FINAL);
+        Skein1024_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        n = byteCnt - i*SKEIN1024_BLOCK_BYTES;   /* number of output bytes left to go */
+        if (n >= SKEIN1024_BLOCK_BYTES)
+            n  = SKEIN1024_BLOCK_BYTES;
+        Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES,ctx->X,n);   /* "output" the ctr mode bytes */
+        Skein_Show_Final(256,&ctx->h,n,hashVal+i*SKEIN1024_BLOCK_BYTES);
+        memcpy(ctx->X,X,sizeof(X));   /* restore the counter mode key for next time */
+    }
+    return SKEIN_SUCCESS;
+}
+#endif
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
new file mode 100755
index 000000000000..7b963758d32c
--- /dev/null
+++ b/drivers/staging/skein/skeinApi.c
@@ -0,0 +1,221 @@
+/*
+Copyright (c) 2010 Werner Dittmann
+
+Permission is hereby granted, free of charge, to any person
+obtaining a copy of this software and associated documentation
+files (the "Software"), to deal in the Software without
+restriction, including without limitation the rights to use,
+copy, modify, merge, publish, distribute, sublicense, and/or sell
+copies of the Software, and to permit persons to whom the
+Software is furnished to do so, subject to the following
+conditions:
+
+The above copyright notice and this permission notice shall be
+included in all copies or substantial portions of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+OTHER DEALINGS IN THE SOFTWARE.
+
+*/
+
+#define SKEIN_ERR_CHECK 1
+#include <skeinApi.h>
+#include <string.h>
+#include <stdio.h>
+
+int skeinCtxPrepare(SkeinCtx_t* ctx, SkeinSize_t size)
+{
+    Skein_Assert(ctx && size, SKEIN_FAIL);
+
+    memset(ctx ,0, sizeof(SkeinCtx_t));
+    ctx->skeinSize = size;
+
+    return SKEIN_SUCCESS;
+}
+
+int skeinInit(SkeinCtx_t* ctx, size_t hashBitLen)
+{
+    int ret = SKEIN_FAIL;
+    size_t Xlen = 0;
+    u64b_t*  X = NULL;
+    uint64_t treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
+
+    Skein_Assert(ctx, SKEIN_FAIL);
+    /*
+     * The following two lines rely of the fact that the real Skein contexts are
+     * a union in out context and thus have tha maximum memory available.
+     * The beauty of C :-) .
+     */
+    X = ctx->m.s256.X;
+    Xlen = ctx->skeinSize/8;
+    /*
+     * If size is the same and hash bit length is zero then reuse
+     * the save chaining variables.
+     */
+    switch (ctx->skeinSize) {
+    case Skein256:
+        ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
+                                treeInfo, NULL, 0);
+        break;
+    case Skein512:
+        ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
+                                treeInfo, NULL, 0);
+        break;
+    case Skein1024:
+        ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
+                                treeInfo, NULL, 0);
+        break;
+    }
+
+    if (ret == SKEIN_SUCCESS) {
+        /* Save chaining variables for this combination of size and hashBitLen */
+        memcpy(ctx->XSave, X, Xlen);
+    }
+    return ret;
+}
+
+int skeinMacInit(SkeinCtx_t* ctx, const uint8_t *key, size_t keyLen,
+                 size_t hashBitLen)
+{
+    int ret = SKEIN_FAIL;
+    u64b_t*  X = NULL;
+    size_t Xlen = 0;
+    uint64_t treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
+
+    Skein_Assert(ctx, SKEIN_FAIL);
+
+    X = ctx->m.s256.X;
+    Xlen = ctx->skeinSize/8;
+
+    Skein_Assert(hashBitLen, SKEIN_BAD_HASHLEN);
+
+    switch (ctx->skeinSize) {
+    case Skein256:
+        ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
+                                treeInfo,
+                                (const u08b_t*)key, keyLen);
+
+        break;
+    case Skein512:
+        ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
+                                treeInfo,
+                                (const u08b_t*)key, keyLen);
+        break;
+    case Skein1024:
+        ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
+                                treeInfo,
+                                (const u08b_t*)key, keyLen);
+
+        break;
+    }
+    if (ret == SKEIN_SUCCESS) {
+        /* Save chaining variables for this combination of key, keyLen, hashBitLen */
+        memcpy(ctx->XSave, X, Xlen);
+    }
+    return ret;
+}
+
+void skeinReset(SkeinCtx_t* ctx)
+{
+    size_t Xlen = 0;
+    u64b_t*  X = NULL;
+
+    /*
+     * The following two lines rely of the fact that the real Skein contexts are
+     * a union in out context and thus have tha maximum memory available.
+     * The beautiy of C :-) .
+     */
+    X = ctx->m.s256.X;
+    Xlen = ctx->skeinSize/8;
+    /* Restore the chaing variable, reset byte counter */
+    memcpy(X, ctx->XSave, Xlen);
+
+    /* Setup context to process the message */
+    Skein_Start_New_Type(&ctx->m, MSG);
+}
+
+int skeinUpdate(SkeinCtx_t *ctx, const uint8_t *msg,
+                size_t msgByteCnt)
+{
+    int ret = SKEIN_FAIL;
+    Skein_Assert(ctx, SKEIN_FAIL);
+
+    switch (ctx->skeinSize) {
+    case Skein256:
+        ret = Skein_256_Update(&ctx->m.s256, (const u08b_t*)msg, msgByteCnt);
+        break;
+    case Skein512:
+        ret = Skein_512_Update(&ctx->m.s512, (const u08b_t*)msg, msgByteCnt);
+        break;
+    case Skein1024:
+        ret = Skein1024_Update(&ctx->m.s1024, (const u08b_t*)msg, msgByteCnt);
+        break;
+    }
+    return ret;
+
+}
+
+int skeinUpdateBits(SkeinCtx_t *ctx, const uint8_t *msg,
+                    size_t msgBitCnt)
+{
+    /*
+     * I've used the bit pad implementation from skein_test.c (see NIST CD)
+     * and modified it to use the convenience functions and added some pointer
+     * arithmetic.
+     */
+    size_t length;
+    uint8_t mask;
+    uint8_t* up;
+
+    /* only the final Update() call is allowed do partial bytes, else assert an error */
+    Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 || msgBitCnt == 0, SKEIN_FAIL);
+
+    /* if number of bits is a multiple of bytes - that's easy */
+    if ((msgBitCnt & 0x7) == 0) {
+        return skeinUpdate(ctx, msg, msgBitCnt >> 3);
+    }
+    skeinUpdate(ctx, msg, (msgBitCnt >> 3) + 1);
+
+    /*
+     * The next line rely on the fact that the real Skein contexts
+     * are a union in our context. After the addition the pointer points to
+     * Skein's real partial block buffer.
+     * If this layout ever changes we have to adapt this as well.
+     */
+    up = (uint8_t*)ctx->m.s256.X + ctx->skeinSize / 8;
+
+    Skein_Set_Bit_Pad_Flag(ctx->m.h);                       /* set tweak flag for the skeinFinal call */
+
+    /* now "pad" the final partial byte the way NIST likes */
+    length = ctx->m.h.bCnt;                                 /* get the bCnt value (same location for all block sizes) */
+    Skein_assert(length != 0);                              /* internal sanity check: there IS a partial byte in the buffer! */
+    mask = (uint8_t) (1u << (7 - (msgBitCnt & 7)));         /* partial byte bit mask */
+    up[length-1]  = (uint8_t)((up[length-1] & (0-mask))|mask);   /* apply bit padding on final byte (in the buffer) */
+
+    return SKEIN_SUCCESS;
+}
+
+int skeinFinal(SkeinCtx_t* ctx, uint8_t* hash)
+{
+    int ret = SKEIN_FAIL;
+    Skein_Assert(ctx, SKEIN_FAIL);
+
+    switch (ctx->skeinSize) {
+    case Skein256:
+        ret = Skein_256_Final(&ctx->m.s256, (u08b_t*)hash);
+        break;
+    case Skein512:
+        ret = Skein_512_Final(&ctx->m.s512, (u08b_t*)hash);
+        break;
+    case Skein1024:
+        ret = Skein1024_Final(&ctx->m.s1024, (u08b_t*)hash);
+        break;
+    }
+    return ret;
+}
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
new file mode 100644
index 000000000000..4ad6c50360e7
--- /dev/null
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -0,0 +1,172 @@
+
+#include <string.h>
+#include <skein.h>
+#include <threefishApi.h>
+
+
+/*****************************  Skein_256 ******************************/
+void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx, const u08b_t *blkPtr,
+                             size_t blkCnt, size_t byteCntAdd)
+{
+    ThreefishKey_t key;
+    u64b_t tweak[2];
+    int i;
+    u64b_t  w[SKEIN_256_STATE_WORDS];           /* local copy of input block */
+    u64b_t words[3];
+
+    Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+    tweak[0] = ctx->h.T[0];
+    tweak[1] = ctx->h.T[1];
+
+    do  {
+        u64b_t carry = byteCntAdd;
+
+        words[0] = tweak[0] & 0xffffffffL;
+        words[1] = ((tweak[0] >> 32) & 0xffffffffL);
+        words[2] = (tweak[1] & 0xffffffffL);
+
+        for (i = 0; i < 3; i++) {
+            carry += words[i];
+            words[i] = carry;
+            carry >>= 32;
+        }        
+        tweak[0] = words[0] & 0xffffffffL;
+        tweak[0] |= (words[1] & 0xffffffffL) << 32;
+        tweak[1] |= words[2] & 0xffffffffL;
+
+        threefishSetKey(&key, Threefish256, ctx->X, tweak);
+
+        Skein_Get64_LSB_First(w, blkPtr, SKEIN_256_STATE_WORDS);   /* get input block in little-endian format */
+
+        threefishEncryptBlockWords(&key, w, ctx->X);
+
+        blkPtr += SKEIN_256_BLOCK_BYTES;
+
+        /* do the final "feedforward" xor, update context chaining vars */
+        ctx->X[0] = ctx->X[0] ^ w[0];
+        ctx->X[1] = ctx->X[1] ^ w[1];
+        ctx->X[2] = ctx->X[2] ^ w[2];
+        ctx->X[3] = ctx->X[3] ^ w[3];
+
+        tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
+    } while (--blkCnt);
+
+    ctx->h.T[0] = tweak[0];
+    ctx->h.T[1] = tweak[1];
+}
+
+void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx, const u08b_t *blkPtr,
+                             size_t blkCnt, size_t byteCntAdd)
+{
+    ThreefishKey_t key;
+    u64b_t tweak[2];
+    int i;
+    u64b_t words[3];
+    u64b_t  w[SKEIN_512_STATE_WORDS];           /* local copy of input block */
+
+    Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+    tweak[0] = ctx->h.T[0];
+    tweak[1] = ctx->h.T[1];
+
+    do  {
+        u64b_t carry = byteCntAdd;
+
+        words[0] = tweak[0] & 0xffffffffL;
+        words[1] = ((tweak[0] >> 32) & 0xffffffffL);
+        words[2] = (tweak[1] & 0xffffffffL);
+
+        for (i = 0; i < 3; i++) {
+            carry += words[i];
+            words[i] = carry;
+            carry >>= 32;
+        }        
+        tweak[0] = words[0] & 0xffffffffL;
+        tweak[0] |= (words[1] & 0xffffffffL) << 32;
+        tweak[1] |= words[2] & 0xffffffffL;
+
+        threefishSetKey(&key, Threefish512, ctx->X, tweak);
+
+        Skein_Get64_LSB_First(w, blkPtr, SKEIN_512_STATE_WORDS);   /* get input block in little-endian format */
+
+        threefishEncryptBlockWords(&key, w, ctx->X);
+
+        blkPtr += SKEIN_512_BLOCK_BYTES;
+
+        /* do the final "feedforward" xor, update context chaining vars */
+        ctx->X[0] = ctx->X[0] ^ w[0];
+        ctx->X[1] = ctx->X[1] ^ w[1];
+        ctx->X[2] = ctx->X[2] ^ w[2];
+        ctx->X[3] = ctx->X[3] ^ w[3];
+        ctx->X[4] = ctx->X[4] ^ w[4];
+        ctx->X[5] = ctx->X[5] ^ w[5];
+        ctx->X[6] = ctx->X[6] ^ w[6];
+        ctx->X[7] = ctx->X[7] ^ w[7];
+
+        tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
+    } while (--blkCnt);
+
+    ctx->h.T[0] = tweak[0];
+    ctx->h.T[1] = tweak[1];
+}
+
+void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx, const u08b_t *blkPtr,
+                              size_t blkCnt, size_t byteCntAdd)
+{
+    ThreefishKey_t key;
+    u64b_t tweak[2];
+    int i;
+    u64b_t words[3];
+    u64b_t  w[SKEIN1024_STATE_WORDS];           /* local copy of input block */
+
+    Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+    tweak[0] = ctx->h.T[0];
+    tweak[1] = ctx->h.T[1];
+
+    do  {
+        u64b_t carry = byteCntAdd;
+
+        words[0] = tweak[0] & 0xffffffffL;
+        words[1] = ((tweak[0] >> 32) & 0xffffffffL);
+        words[2] = (tweak[1] & 0xffffffffL);
+
+        for (i = 0; i < 3; i++) {
+            carry += words[i];
+            words[i] = carry;
+            carry >>= 32;
+        }        
+        tweak[0] = words[0] & 0xffffffffL;
+        tweak[0] |= (words[1] & 0xffffffffL) << 32;
+        tweak[1] |= words[2] & 0xffffffffL;
+
+        threefishSetKey(&key, Threefish1024, ctx->X, tweak);
+
+        Skein_Get64_LSB_First(w, blkPtr, SKEIN1024_STATE_WORDS);   /* get input block in little-endian format */
+
+        threefishEncryptBlockWords(&key, w, ctx->X);
+
+        blkPtr += SKEIN1024_BLOCK_BYTES;
+
+        /* do the final "feedforward" xor, update context chaining vars */
+        ctx->X[ 0] = ctx->X[ 0] ^ w[ 0];
+        ctx->X[ 1] = ctx->X[ 1] ^ w[ 1];
+        ctx->X[ 2] = ctx->X[ 2] ^ w[ 2];
+        ctx->X[ 3] = ctx->X[ 3] ^ w[ 3];
+        ctx->X[ 4] = ctx->X[ 4] ^ w[ 4];
+        ctx->X[ 5] = ctx->X[ 5] ^ w[ 5];
+        ctx->X[ 6] = ctx->X[ 6] ^ w[ 6];
+        ctx->X[ 7] = ctx->X[ 7] ^ w[ 7];
+        ctx->X[ 8] = ctx->X[ 8] ^ w[ 8];
+        ctx->X[ 9] = ctx->X[ 9] ^ w[ 9];
+        ctx->X[10] = ctx->X[10] ^ w[10];
+        ctx->X[11] = ctx->X[11] ^ w[11];
+        ctx->X[12] = ctx->X[12] ^ w[12];
+        ctx->X[13] = ctx->X[13] ^ w[13];
+        ctx->X[14] = ctx->X[14] ^ w[14];
+        ctx->X[15] = ctx->X[15] ^ w[15];
+
+        tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
+    } while (--blkCnt);
+
+    ctx->h.T[0] = tweak[0];
+    ctx->h.T[1] = tweak[1];
+}
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
new file mode 100644
index 000000000000..86724a2443b5
--- /dev/null
+++ b/drivers/staging/skein/skein_block.c
@@ -0,0 +1,689 @@
+/***********************************************************************
+**
+** Implementation of the Skein block functions.
+**
+** Source code author: Doug Whiting, 2008.
+**
+** This algorithm and source code is released to the public domain.
+**
+** Compile-time switches:
+**
+**  SKEIN_USE_ASM  -- set bits (256/512/1024) to select which
+**                    versions use ASM code for block processing
+**                    [default: use C for all block sizes]
+**
+************************************************************************/
+
+#include <string.h>
+#include <skein.h>
+
+#ifndef SKEIN_USE_ASM
+#define SKEIN_USE_ASM   (0)                     /* default is all C code (no ASM) */
+#endif
+
+#ifndef SKEIN_LOOP
+#define SKEIN_LOOP 001                          /* default: unroll 256 and 512, but not 1024 */
+#endif
+
+#define BLK_BITS        (WCNT*64)               /* some useful definitions for code here */
+#define KW_TWK_BASE     (0)
+#define KW_KEY_BASE     (3)
+#define ks              (kw + KW_KEY_BASE)                
+#define ts              (kw + KW_TWK_BASE)
+
+#ifdef SKEIN_DEBUG
+#define DebugSaveTweak(ctx) { ctx->h.T[0] = ts[0]; ctx->h.T[1] = ts[1]; }
+#else
+#define DebugSaveTweak(ctx)
+#endif
+
+/*****************************  Skein_256 ******************************/
+#if !(SKEIN_USE_ASM & 256)
+void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd)
+    { /* do it in C */
+    enum
+        {
+        WCNT = SKEIN_256_STATE_WORDS
+        };
+#undef  RCNT
+#define RCNT  (SKEIN_256_ROUNDS_TOTAL/8)
+
+#ifdef  SKEIN_LOOP                              /* configure how much to unroll the loop */
+#define SKEIN_UNROLL_256 (((SKEIN_LOOP)/100)%10)
+#else
+#define SKEIN_UNROLL_256 (0)
+#endif
+
+#if SKEIN_UNROLL_256
+#if (RCNT % SKEIN_UNROLL_256)
+#error "Invalid SKEIN_UNROLL_256"               /* sanity check on unroll count */
+#endif
+    size_t  r;
+    u64b_t  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+#else
+    u64b_t  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+#endif
+    u64b_t  X0,X1,X2,X3;                        /* local copy of context vars, for speed */
+    u64b_t  w [WCNT];                           /* local copy of input block */
+#ifdef SKEIN_DEBUG
+    const u64b_t *Xptr[4];                      /* use for debugging (help compiler put Xn in registers) */
+    Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
+#endif
+    Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+    ts[0] = ctx->h.T[0];
+    ts[1] = ctx->h.T[1];
+    do  {
+        /* this implementation only supports 2**64 input bytes (no carry out here) */
+        ts[0] += byteCntAdd;                    /* update processed length */
+
+        /* precompute the key schedule for this block */
+        ks[0] = ctx->X[0];     
+        ks[1] = ctx->X[1];
+        ks[2] = ctx->X[2];
+        ks[3] = ctx->X[3];
+        ks[4] = ks[0] ^ ks[1] ^ ks[2] ^ ks[3] ^ SKEIN_KS_PARITY;
+
+        ts[2] = ts[0] ^ ts[1];
+
+        Skein_Get64_LSB_First(w,blkPtr,WCNT);   /* get input block in little-endian format */
+        DebugSaveTweak(ctx);
+        Skein_Show_Block(BLK_BITS,&ctx->h,ctx->X,blkPtr,w,ks,ts);
+
+        X0 = w[0] + ks[0];                      /* do the first full key injection */
+        X1 = w[1] + ks[1] + ts[0];
+        X2 = w[2] + ks[2] + ts[1];
+        X3 = w[3] + ks[3];
+
+        Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INITIAL,Xptr);    /* show starting state values */
+
+        blkPtr += SKEIN_256_BLOCK_BYTES;
+
+        /* run the rounds */
+
+#define Round256(p0,p1,p2,p3,ROT,rNum)                              \
+    X##p0 += X##p1; X##p1 = RotL_64(X##p1,ROT##_0); X##p1 ^= X##p0; \
+    X##p2 += X##p3; X##p3 = RotL_64(X##p3,ROT##_1); X##p3 ^= X##p2; \
+
+#if SKEIN_UNROLL_256 == 0                       
+#define R256(p0,p1,p2,p3,ROT,rNum)           /* fully unrolled */   \
+    Round256(p0,p1,p2,p3,ROT,rNum)                                  \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,rNum,Xptr);
+
+#define I256(R)                                                     \
+    X0   += ks[((R)+1) % 5];    /* inject the key schedule value */ \
+    X1   += ks[((R)+2) % 5] + ts[((R)+1) % 3];                      \
+    X2   += ks[((R)+3) % 5] + ts[((R)+2) % 3];                      \
+    X3   += ks[((R)+4) % 5] +     (R)+1;                            \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
+#else                                       /* looping version */
+#define R256(p0,p1,p2,p3,ROT,rNum)                                  \
+    Round256(p0,p1,p2,p3,ROT,rNum)                                  \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,4*(r-1)+rNum,Xptr);
+
+#define I256(R)                                                     \
+    X0   += ks[r+(R)+0];        /* inject the key schedule value */ \
+    X1   += ks[r+(R)+1] + ts[r+(R)+0];                              \
+    X2   += ks[r+(R)+2] + ts[r+(R)+1];                              \
+    X3   += ks[r+(R)+3] +    r+(R)   ;                              \
+    ks[r + (R)+4    ]   = ks[r+(R)-1];     /* rotate key schedule */\
+    ts[r + (R)+2    ]   = ts[r+(R)-1];                              \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
+
+    for (r=1;r < 2*RCNT;r+=2*SKEIN_UNROLL_256)  /* loop thru it */
+#endif  
+        {    
+#define R256_8_rounds(R)                  \
+        R256(0,1,2,3,R_256_0,8*(R) + 1);  \
+        R256(0,3,2,1,R_256_1,8*(R) + 2);  \
+        R256(0,1,2,3,R_256_2,8*(R) + 3);  \
+        R256(0,3,2,1,R_256_3,8*(R) + 4);  \
+        I256(2*(R));                      \
+        R256(0,1,2,3,R_256_4,8*(R) + 5);  \
+        R256(0,3,2,1,R_256_5,8*(R) + 6);  \
+        R256(0,1,2,3,R_256_6,8*(R) + 7);  \
+        R256(0,3,2,1,R_256_7,8*(R) + 8);  \
+        I256(2*(R)+1);
+
+        R256_8_rounds( 0);
+
+#define R256_Unroll_R(NN) ((SKEIN_UNROLL_256 == 0 && SKEIN_256_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_256 > (NN)))
+
+  #if   R256_Unroll_R( 1)
+        R256_8_rounds( 1);
+  #endif
+  #if   R256_Unroll_R( 2)
+        R256_8_rounds( 2);
+  #endif
+  #if   R256_Unroll_R( 3)
+        R256_8_rounds( 3);
+  #endif
+  #if   R256_Unroll_R( 4)
+        R256_8_rounds( 4);
+  #endif
+  #if   R256_Unroll_R( 5)
+        R256_8_rounds( 5);
+  #endif
+  #if   R256_Unroll_R( 6)
+        R256_8_rounds( 6);
+  #endif
+  #if   R256_Unroll_R( 7)
+        R256_8_rounds( 7);
+  #endif
+  #if   R256_Unroll_R( 8)
+        R256_8_rounds( 8);
+  #endif
+  #if   R256_Unroll_R( 9)
+        R256_8_rounds( 9);
+  #endif
+  #if   R256_Unroll_R(10)
+        R256_8_rounds(10);
+  #endif
+  #if   R256_Unroll_R(11)
+        R256_8_rounds(11);
+  #endif
+  #if   R256_Unroll_R(12)
+        R256_8_rounds(12);
+  #endif
+  #if   R256_Unroll_R(13)
+        R256_8_rounds(13);
+  #endif
+  #if   R256_Unroll_R(14)
+        R256_8_rounds(14);
+  #endif
+  #if  (SKEIN_UNROLL_256 > 14)
+#error  "need more unrolling in Skein_256_Process_Block"
+  #endif
+        }
+        /* do the final "feedforward" xor, update context chaining vars */
+        ctx->X[0] = X0 ^ w[0];
+        ctx->X[1] = X1 ^ w[1];
+        ctx->X[2] = X2 ^ w[2];
+        ctx->X[3] = X3 ^ w[3];
+
+        Skein_Show_Round(BLK_BITS,&ctx->h,SKEIN_RND_FEED_FWD,ctx->X);
+
+        ts[1] &= ~SKEIN_T1_FLAG_FIRST;
+        }
+    while (--blkCnt);
+    ctx->h.T[0] = ts[0];
+    ctx->h.T[1] = ts[1];
+    }
+
+#if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
+size_t Skein_256_Process_Block_CodeSize(void)
+    {
+    return ((u08b_t *) Skein_256_Process_Block_CodeSize) -
+           ((u08b_t *) Skein_256_Process_Block);
+    }
+uint_t Skein_256_Unroll_Cnt(void)
+    {
+    return SKEIN_UNROLL_256;
+    }
+#endif
+#endif
+
+/*****************************  Skein_512 ******************************/
+#if !(SKEIN_USE_ASM & 512)
+void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd)
+    { /* do it in C */
+    enum
+        {
+        WCNT = SKEIN_512_STATE_WORDS
+        };
+#undef  RCNT
+#define RCNT  (SKEIN_512_ROUNDS_TOTAL/8)
+
+#ifdef  SKEIN_LOOP                              /* configure how much to unroll the loop */
+#define SKEIN_UNROLL_512 (((SKEIN_LOOP)/10)%10)
+#else
+#define SKEIN_UNROLL_512 (0)
+#endif
+
+#if SKEIN_UNROLL_512
+#if (RCNT % SKEIN_UNROLL_512)
+#error "Invalid SKEIN_UNROLL_512"               /* sanity check on unroll count */
+#endif
+    size_t  r;
+    u64b_t  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+#else
+    u64b_t  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+#endif
+    u64b_t  X0,X1,X2,X3,X4,X5,X6,X7;            /* local copy of vars, for speed */
+    u64b_t  w [WCNT];                           /* local copy of input block */
+#ifdef SKEIN_DEBUG
+    const u64b_t *Xptr[8];                      /* use for debugging (help compiler put Xn in registers) */
+    Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
+    Xptr[4] = &X4;  Xptr[5] = &X5;  Xptr[6] = &X6;  Xptr[7] = &X7;
+#endif
+
+    Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+    ts[0] = ctx->h.T[0];
+    ts[1] = ctx->h.T[1];
+    do  {
+        /* this implementation only supports 2**64 input bytes (no carry out here) */
+        ts[0] += byteCntAdd;                    /* update processed length */
+
+        /* precompute the key schedule for this block */
+        ks[0] = ctx->X[0];
+        ks[1] = ctx->X[1];
+        ks[2] = ctx->X[2];
+        ks[3] = ctx->X[3];
+        ks[4] = ctx->X[4];
+        ks[5] = ctx->X[5];
+        ks[6] = ctx->X[6];
+        ks[7] = ctx->X[7];
+        ks[8] = ks[0] ^ ks[1] ^ ks[2] ^ ks[3] ^ 
+                ks[4] ^ ks[5] ^ ks[6] ^ ks[7] ^ SKEIN_KS_PARITY;
+
+        ts[2] = ts[0] ^ ts[1];
+
+        Skein_Get64_LSB_First(w,blkPtr,WCNT); /* get input block in little-endian format */
+        DebugSaveTweak(ctx);
+        Skein_Show_Block(BLK_BITS,&ctx->h,ctx->X,blkPtr,w,ks,ts);
+
+        X0   = w[0] + ks[0];                    /* do the first full key injection */
+        X1   = w[1] + ks[1];
+        X2   = w[2] + ks[2];
+        X3   = w[3] + ks[3];
+        X4   = w[4] + ks[4];
+        X5   = w[5] + ks[5] + ts[0];
+        X6   = w[6] + ks[6] + ts[1];
+        X7   = w[7] + ks[7];
+
+        blkPtr += SKEIN_512_BLOCK_BYTES;
+
+        Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INITIAL,Xptr);
+        /* run the rounds */
+#define Round512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)                  \
+    X##p0 += X##p1; X##p1 = RotL_64(X##p1,ROT##_0); X##p1 ^= X##p0; \
+    X##p2 += X##p3; X##p3 = RotL_64(X##p3,ROT##_1); X##p3 ^= X##p2; \
+    X##p4 += X##p5; X##p5 = RotL_64(X##p5,ROT##_2); X##p5 ^= X##p4; \
+    X##p6 += X##p7; X##p7 = RotL_64(X##p7,ROT##_3); X##p7 ^= X##p6; \
+
+#if SKEIN_UNROLL_512 == 0                       
+#define R512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)      /* unrolled */  \
+    Round512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)                      \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,rNum,Xptr);
+
+#define I512(R)                                                     \
+    X0   += ks[((R)+1) % 9];   /* inject the key schedule value */  \
+    X1   += ks[((R)+2) % 9];                                        \
+    X2   += ks[((R)+3) % 9];                                        \
+    X3   += ks[((R)+4) % 9];                                        \
+    X4   += ks[((R)+5) % 9];                                        \
+    X5   += ks[((R)+6) % 9] + ts[((R)+1) % 3];                      \
+    X6   += ks[((R)+7) % 9] + ts[((R)+2) % 3];                      \
+    X7   += ks[((R)+8) % 9] +     (R)+1;                            \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
+#else                                       /* looping version */
+#define R512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)                      \
+    Round512(p0,p1,p2,p3,p4,p5,p6,p7,ROT,rNum)                      \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,4*(r-1)+rNum,Xptr);
+
+#define I512(R)                                                     \
+    X0   += ks[r+(R)+0];        /* inject the key schedule value */ \
+    X1   += ks[r+(R)+1];                                            \
+    X2   += ks[r+(R)+2];                                            \
+    X3   += ks[r+(R)+3];                                            \
+    X4   += ks[r+(R)+4];                                            \
+    X5   += ks[r+(R)+5] + ts[r+(R)+0];                              \
+    X6   += ks[r+(R)+6] + ts[r+(R)+1];                              \
+    X7   += ks[r+(R)+7] +    r+(R)   ;                              \
+    ks[r +       (R)+8] = ks[r+(R)-1];  /* rotate key schedule */   \
+    ts[r +       (R)+2] = ts[r+(R)-1];                              \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
+
+    for (r=1;r < 2*RCNT;r+=2*SKEIN_UNROLL_512)   /* loop thru it */
+#endif                         /* end of looped code definitions */
+        {
+#define R512_8_rounds(R)  /* do 8 full rounds */  \
+        R512(0,1,2,3,4,5,6,7,R_512_0,8*(R)+ 1);   \
+        R512(2,1,4,7,6,5,0,3,R_512_1,8*(R)+ 2);   \
+        R512(4,1,6,3,0,5,2,7,R_512_2,8*(R)+ 3);   \
+        R512(6,1,0,7,2,5,4,3,R_512_3,8*(R)+ 4);   \
+        I512(2*(R));                              \
+        R512(0,1,2,3,4,5,6,7,R_512_4,8*(R)+ 5);   \
+        R512(2,1,4,7,6,5,0,3,R_512_5,8*(R)+ 6);   \
+        R512(4,1,6,3,0,5,2,7,R_512_6,8*(R)+ 7);   \
+        R512(6,1,0,7,2,5,4,3,R_512_7,8*(R)+ 8);   \
+        I512(2*(R)+1);        /* and key injection */
+
+        R512_8_rounds( 0);
+
+#define R512_Unroll_R(NN) ((SKEIN_UNROLL_512 == 0 && SKEIN_512_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_512 > (NN)))
+
+  #if   R512_Unroll_R( 1)
+        R512_8_rounds( 1);
+  #endif
+  #if   R512_Unroll_R( 2)
+        R512_8_rounds( 2);
+  #endif
+  #if   R512_Unroll_R( 3)
+        R512_8_rounds( 3);
+  #endif
+  #if   R512_Unroll_R( 4)
+        R512_8_rounds( 4);
+  #endif
+  #if   R512_Unroll_R( 5)
+        R512_8_rounds( 5);
+  #endif
+  #if   R512_Unroll_R( 6)
+        R512_8_rounds( 6);
+  #endif
+  #if   R512_Unroll_R( 7)
+        R512_8_rounds( 7);
+  #endif
+  #if   R512_Unroll_R( 8)
+        R512_8_rounds( 8);
+  #endif
+  #if   R512_Unroll_R( 9)
+        R512_8_rounds( 9);
+  #endif
+  #if   R512_Unroll_R(10)
+        R512_8_rounds(10);
+  #endif
+  #if   R512_Unroll_R(11)
+        R512_8_rounds(11);
+  #endif
+  #if   R512_Unroll_R(12)
+        R512_8_rounds(12);
+  #endif
+  #if   R512_Unroll_R(13)
+        R512_8_rounds(13);
+  #endif
+  #if   R512_Unroll_R(14)
+        R512_8_rounds(14);
+  #endif
+  #if  (SKEIN_UNROLL_512 > 14)
+#error  "need more unrolling in Skein_512_Process_Block"
+  #endif
+        }
+
+        /* do the final "feedforward" xor, update context chaining vars */
+        ctx->X[0] = X0 ^ w[0];
+        ctx->X[1] = X1 ^ w[1];
+        ctx->X[2] = X2 ^ w[2];
+        ctx->X[3] = X3 ^ w[3];
+        ctx->X[4] = X4 ^ w[4];
+        ctx->X[5] = X5 ^ w[5];
+        ctx->X[6] = X6 ^ w[6];
+        ctx->X[7] = X7 ^ w[7];
+        Skein_Show_Round(BLK_BITS,&ctx->h,SKEIN_RND_FEED_FWD,ctx->X);
+
+        ts[1] &= ~SKEIN_T1_FLAG_FIRST;
+        }
+    while (--blkCnt);
+    ctx->h.T[0] = ts[0];
+    ctx->h.T[1] = ts[1];
+    }
+
+#if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
+size_t Skein_512_Process_Block_CodeSize(void)
+    {
+    return ((u08b_t *) Skein_512_Process_Block_CodeSize) -
+           ((u08b_t *) Skein_512_Process_Block);
+    }
+uint_t Skein_512_Unroll_Cnt(void)
+    {
+    return SKEIN_UNROLL_512;
+    }
+#endif
+#endif
+
+/*****************************  Skein1024 ******************************/
+#if !(SKEIN_USE_ASM & 1024)
+void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd)
+    { /* do it in C, always looping (unrolled is bigger AND slower!) */
+    enum
+        {
+        WCNT = SKEIN1024_STATE_WORDS
+        };
+#undef  RCNT
+#define RCNT  (SKEIN1024_ROUNDS_TOTAL/8)
+
+#ifdef  SKEIN_LOOP                              /* configure how much to unroll the loop */
+#define SKEIN_UNROLL_1024 ((SKEIN_LOOP)%10)
+#else
+#define SKEIN_UNROLL_1024 (0)
+#endif
+
+#if (SKEIN_UNROLL_1024 != 0)
+#if (RCNT % SKEIN_UNROLL_1024)
+#error "Invalid SKEIN_UNROLL_1024"              /* sanity check on unroll count */
+#endif
+    size_t  r;
+    u64b_t  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+#else
+    u64b_t  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+#endif
+
+    u64b_t  X00,X01,X02,X03,X04,X05,X06,X07,    /* local copy of vars, for speed */
+            X08,X09,X10,X11,X12,X13,X14,X15;
+    u64b_t  w [WCNT];                           /* local copy of input block */
+#ifdef SKEIN_DEBUG
+    const u64b_t *Xptr[16];                     /* use for debugging (help compiler put Xn in registers) */
+    Xptr[ 0] = &X00;  Xptr[ 1] = &X01;  Xptr[ 2] = &X02;  Xptr[ 3] = &X03;
+    Xptr[ 4] = &X04;  Xptr[ 5] = &X05;  Xptr[ 6] = &X06;  Xptr[ 7] = &X07;
+    Xptr[ 8] = &X08;  Xptr[ 9] = &X09;  Xptr[10] = &X10;  Xptr[11] = &X11;
+    Xptr[12] = &X12;  Xptr[13] = &X13;  Xptr[14] = &X14;  Xptr[15] = &X15;
+#endif
+
+    Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
+    ts[0] = ctx->h.T[0];
+    ts[1] = ctx->h.T[1];
+    do  {
+        /* this implementation only supports 2**64 input bytes (no carry out here) */
+        ts[0] += byteCntAdd;                    /* update processed length */
+
+        /* precompute the key schedule for this block */
+        ks[ 0] = ctx->X[ 0];
+        ks[ 1] = ctx->X[ 1];
+        ks[ 2] = ctx->X[ 2];
+        ks[ 3] = ctx->X[ 3];
+        ks[ 4] = ctx->X[ 4];
+        ks[ 5] = ctx->X[ 5];
+        ks[ 6] = ctx->X[ 6];
+        ks[ 7] = ctx->X[ 7];
+        ks[ 8] = ctx->X[ 8];
+        ks[ 9] = ctx->X[ 9];
+        ks[10] = ctx->X[10];
+        ks[11] = ctx->X[11];
+        ks[12] = ctx->X[12];
+        ks[13] = ctx->X[13];
+        ks[14] = ctx->X[14];
+        ks[15] = ctx->X[15];
+        ks[16] = ks[ 0] ^ ks[ 1] ^ ks[ 2] ^ ks[ 3] ^
+                 ks[ 4] ^ ks[ 5] ^ ks[ 6] ^ ks[ 7] ^
+                 ks[ 8] ^ ks[ 9] ^ ks[10] ^ ks[11] ^
+                 ks[12] ^ ks[13] ^ ks[14] ^ ks[15] ^ SKEIN_KS_PARITY;
+
+        ts[2]  = ts[0] ^ ts[1];
+
+        Skein_Get64_LSB_First(w,blkPtr,WCNT); /* get input block in little-endian format */
+        DebugSaveTweak(ctx);
+        Skein_Show_Block(BLK_BITS,&ctx->h,ctx->X,blkPtr,w,ks,ts);
+
+        X00    = w[ 0] + ks[ 0];                 /* do the first full key injection */
+        X01    = w[ 1] + ks[ 1];
+        X02    = w[ 2] + ks[ 2];
+        X03    = w[ 3] + ks[ 3];
+        X04    = w[ 4] + ks[ 4];
+        X05    = w[ 5] + ks[ 5];
+        X06    = w[ 6] + ks[ 6];
+        X07    = w[ 7] + ks[ 7];
+        X08    = w[ 8] + ks[ 8];
+        X09    = w[ 9] + ks[ 9];
+        X10    = w[10] + ks[10];
+        X11    = w[11] + ks[11];
+        X12    = w[12] + ks[12];
+        X13    = w[13] + ks[13] + ts[0];
+        X14    = w[14] + ks[14] + ts[1];
+        X15    = w[15] + ks[15];
+
+        Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INITIAL,Xptr);
+
+#define Round1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rNum) \
+    X##p0 += X##p1; X##p1 = RotL_64(X##p1,ROT##_0); X##p1 ^= X##p0;   \
+    X##p2 += X##p3; X##p3 = RotL_64(X##p3,ROT##_1); X##p3 ^= X##p2;   \
+    X##p4 += X##p5; X##p5 = RotL_64(X##p5,ROT##_2); X##p5 ^= X##p4;   \
+    X##p6 += X##p7; X##p7 = RotL_64(X##p7,ROT##_3); X##p7 ^= X##p6;   \
+    X##p8 += X##p9; X##p9 = RotL_64(X##p9,ROT##_4); X##p9 ^= X##p8;   \
+    X##pA += X##pB; X##pB = RotL_64(X##pB,ROT##_5); X##pB ^= X##pA;   \
+    X##pC += X##pD; X##pD = RotL_64(X##pD,ROT##_6); X##pD ^= X##pC;   \
+    X##pE += X##pF; X##pF = RotL_64(X##pF,ROT##_7); X##pF ^= X##pE;   \
+
+#if SKEIN_UNROLL_1024 == 0                      
+#define R1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rn) \
+    Round1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rn) \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,rn,Xptr);
+
+#define I1024(R)                                                      \
+    X00   += ks[((R)+ 1) % 17]; /* inject the key schedule value */   \
+    X01   += ks[((R)+ 2) % 17];                                       \
+    X02   += ks[((R)+ 3) % 17];                                       \
+    X03   += ks[((R)+ 4) % 17];                                       \
+    X04   += ks[((R)+ 5) % 17];                                       \
+    X05   += ks[((R)+ 6) % 17];                                       \
+    X06   += ks[((R)+ 7) % 17];                                       \
+    X07   += ks[((R)+ 8) % 17];                                       \
+    X08   += ks[((R)+ 9) % 17];                                       \
+    X09   += ks[((R)+10) % 17];                                       \
+    X10   += ks[((R)+11) % 17];                                       \
+    X11   += ks[((R)+12) % 17];                                       \
+    X12   += ks[((R)+13) % 17];                                       \
+    X13   += ks[((R)+14) % 17] + ts[((R)+1) % 3];                     \
+    X14   += ks[((R)+15) % 17] + ts[((R)+2) % 3];                     \
+    X15   += ks[((R)+16) % 17] +     (R)+1;                           \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr); 
+#else                                       /* looping version */
+#define R1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rn) \
+    Round1024(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,pA,pB,pC,pD,pE,pF,ROT,rn) \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,4*(r-1)+rn,Xptr);
+
+#define I1024(R)                                                      \
+    X00   += ks[r+(R)+ 0];    /* inject the key schedule value */     \
+    X01   += ks[r+(R)+ 1];                                            \
+    X02   += ks[r+(R)+ 2];                                            \
+    X03   += ks[r+(R)+ 3];                                            \
+    X04   += ks[r+(R)+ 4];                                            \
+    X05   += ks[r+(R)+ 5];                                            \
+    X06   += ks[r+(R)+ 6];                                            \
+    X07   += ks[r+(R)+ 7];                                            \
+    X08   += ks[r+(R)+ 8];                                            \
+    X09   += ks[r+(R)+ 9];                                            \
+    X10   += ks[r+(R)+10];                                            \
+    X11   += ks[r+(R)+11];                                            \
+    X12   += ks[r+(R)+12];                                            \
+    X13   += ks[r+(R)+13] + ts[r+(R)+0];                              \
+    X14   += ks[r+(R)+14] + ts[r+(R)+1];                              \
+    X15   += ks[r+(R)+15] +    r+(R)   ;                              \
+    ks[r  +       (R)+16] = ks[r+(R)-1];  /* rotate key schedule */   \
+    ts[r  +       (R)+ 2] = ts[r+(R)-1];                              \
+    Skein_Show_R_Ptr(BLK_BITS,&ctx->h,SKEIN_RND_KEY_INJECT,Xptr);
+
+    for (r=1;r <= 2*RCNT;r+=2*SKEIN_UNROLL_1024)    /* loop thru it */
+#endif  
+        {
+#define R1024_8_rounds(R)    /* do 8 full rounds */                               \
+        R1024(00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,R1024_0,8*(R) + 1); \
+        R1024(00,09,02,13,06,11,04,15,10,07,12,03,14,05,08,01,R1024_1,8*(R) + 2); \
+        R1024(00,07,02,05,04,03,06,01,12,15,14,13,08,11,10,09,R1024_2,8*(R) + 3); \
+        R1024(00,15,02,11,06,13,04,09,14,01,08,05,10,03,12,07,R1024_3,8*(R) + 4); \
+        I1024(2*(R));                                                             \
+        R1024(00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,R1024_4,8*(R) + 5); \
+        R1024(00,09,02,13,06,11,04,15,10,07,12,03,14,05,08,01,R1024_5,8*(R) + 6); \
+        R1024(00,07,02,05,04,03,06,01,12,15,14,13,08,11,10,09,R1024_6,8*(R) + 7); \
+        R1024(00,15,02,11,06,13,04,09,14,01,08,05,10,03,12,07,R1024_7,8*(R) + 8); \
+        I1024(2*(R)+1);
+
+        R1024_8_rounds( 0);
+
+#define R1024_Unroll_R(NN) ((SKEIN_UNROLL_1024 == 0 && SKEIN1024_ROUNDS_TOTAL/8 > (NN)) || (SKEIN_UNROLL_1024 > (NN)))
+
+  #if   R1024_Unroll_R( 1)
+        R1024_8_rounds( 1);
+  #endif
+  #if   R1024_Unroll_R( 2)
+        R1024_8_rounds( 2);
+  #endif
+  #if   R1024_Unroll_R( 3)
+        R1024_8_rounds( 3);
+  #endif
+  #if   R1024_Unroll_R( 4)
+        R1024_8_rounds( 4);
+  #endif
+  #if   R1024_Unroll_R( 5)
+        R1024_8_rounds( 5);
+  #endif
+  #if   R1024_Unroll_R( 6)
+        R1024_8_rounds( 6);
+  #endif
+  #if   R1024_Unroll_R( 7)
+        R1024_8_rounds( 7);
+  #endif
+  #if   R1024_Unroll_R( 8)
+        R1024_8_rounds( 8);
+  #endif
+  #if   R1024_Unroll_R( 9)
+        R1024_8_rounds( 9);
+  #endif
+  #if   R1024_Unroll_R(10)
+        R1024_8_rounds(10);
+  #endif
+  #if   R1024_Unroll_R(11)
+        R1024_8_rounds(11);
+  #endif
+  #if   R1024_Unroll_R(12)
+        R1024_8_rounds(12);
+  #endif
+  #if   R1024_Unroll_R(13)
+        R1024_8_rounds(13);
+  #endif
+  #if   R1024_Unroll_R(14)
+        R1024_8_rounds(14);
+  #endif
+  #if  (SKEIN_UNROLL_1024 > 14)
+#error  "need more unrolling in Skein_1024_Process_Block"
+  #endif
+        }
+        /* do the final "feedforward" xor, update context chaining vars */
+
+        ctx->X[ 0] = X00 ^ w[ 0];
+        ctx->X[ 1] = X01 ^ w[ 1];
+        ctx->X[ 2] = X02 ^ w[ 2];
+        ctx->X[ 3] = X03 ^ w[ 3];
+        ctx->X[ 4] = X04 ^ w[ 4];
+        ctx->X[ 5] = X05 ^ w[ 5];
+        ctx->X[ 6] = X06 ^ w[ 6];
+        ctx->X[ 7] = X07 ^ w[ 7];
+        ctx->X[ 8] = X08 ^ w[ 8];
+        ctx->X[ 9] = X09 ^ w[ 9];
+        ctx->X[10] = X10 ^ w[10];
+        ctx->X[11] = X11 ^ w[11];
+        ctx->X[12] = X12 ^ w[12];
+        ctx->X[13] = X13 ^ w[13];
+        ctx->X[14] = X14 ^ w[14];
+        ctx->X[15] = X15 ^ w[15];
+
+        Skein_Show_Round(BLK_BITS,&ctx->h,SKEIN_RND_FEED_FWD,ctx->X);
+        
+        ts[1] &= ~SKEIN_T1_FLAG_FIRST;
+        blkPtr += SKEIN1024_BLOCK_BYTES;
+        }
+    while (--blkCnt);
+    ctx->h.T[0] = ts[0];
+    ctx->h.T[1] = ts[1];
+    }
+
+#if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
+size_t Skein1024_Process_Block_CodeSize(void)
+    {
+    return ((u08b_t *) Skein1024_Process_Block_CodeSize) -
+           ((u08b_t *) Skein1024_Process_Block);
+    }
+uint_t Skein1024_Unroll_Cnt(void)
+    {
+    return SKEIN_UNROLL_1024;
+    }
+#endif
+#endif
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
new file mode 100644
index 000000000000..8b43586f46bc
--- /dev/null
+++ b/drivers/staging/skein/threefish1024Block.c
@@ -0,0 +1,1385 @@
+#include <threefishApi.h>
+#include <stdint.h>
+#include <string.h>
+
+
+void threefishEncrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+        {
+
+    uint64_t b0 = input[0], b1 = input[1],
+      b2 = input[2], b3 = input[3],
+      b4 = input[4], b5 = input[5],
+      b6 = input[6], b7 = input[7],
+      b8 = input[8], b9 = input[9],
+      b10 = input[10], b11 = input[11],
+      b12 = input[12], b13 = input[13],
+      b14 = input[14], b15 = input[15];
+    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+      k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+      k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+      k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+      k8 = keyCtx->key[8], k9 = keyCtx->key[9],
+      k10 = keyCtx->key[10], k11 = keyCtx->key[11],
+      k12 = keyCtx->key[12], k13 = keyCtx->key[13],
+      k14 = keyCtx->key[14], k15 = keyCtx->key[15],
+      k16 = keyCtx->key[16];
+    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+      t2 = keyCtx->tweak[2];
+
+            b1 += k1; b0 += b1 + k0; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k3; b2 += b3 + k2; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k5; b4 += b5 + k4; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k7; b6 += b7 + k6; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k9; b8 += b9 + k8; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k11; b10 += b11 + k10; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k13 + t0; b12 += b13 + k12; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k15; b14 += b15 + k14 + t1; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k2; b0 += b1 + k1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k4; b2 += b3 + k3; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k6; b4 += b5 + k5; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k8; b6 += b7 + k7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k10; b8 += b9 + k9; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k12; b10 += b11 + k11; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k14 + t1; b12 += b13 + k13; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k16 + 1; b14 += b15 + k15 + t2; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k3; b0 += b1 + k2; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k5; b2 += b3 + k4; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k7; b4 += b5 + k6; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k9; b6 += b7 + k8; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k11; b8 += b9 + k10; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k13; b10 += b11 + k12; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k15 + t2; b12 += b13 + k14; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k0 + 2; b14 += b15 + k16 + t0; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k4; b0 += b1 + k3; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k6; b2 += b3 + k5; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k8; b4 += b5 + k7; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k10; b6 += b7 + k9; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k12; b8 += b9 + k11; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k14; b10 += b11 + k13; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k16 + t0; b12 += b13 + k15; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k1 + 3; b14 += b15 + k0 + t1; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k5; b0 += b1 + k4; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k7; b2 += b3 + k6; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k9; b4 += b5 + k8; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k11; b6 += b7 + k10; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k13; b8 += b9 + k12; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k15; b10 += b11 + k14; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k0 + t1; b12 += b13 + k16; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k2 + 4; b14 += b15 + k1 + t2; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k6; b0 += b1 + k5; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k8; b2 += b3 + k7; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k10; b4 += b5 + k9; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k12; b6 += b7 + k11; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k14; b8 += b9 + k13; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k16; b10 += b11 + k15; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k1 + t2; b12 += b13 + k0; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k3 + 5; b14 += b15 + k2 + t0; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k7; b0 += b1 + k6; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k9; b2 += b3 + k8; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k11; b4 += b5 + k10; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k13; b6 += b7 + k12; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k15; b8 += b9 + k14; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k0; b10 += b11 + k16; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k2 + t0; b12 += b13 + k1; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k4 + 6; b14 += b15 + k3 + t1; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k8; b0 += b1 + k7; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k10; b2 += b3 + k9; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k12; b4 += b5 + k11; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k14; b6 += b7 + k13; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k16; b8 += b9 + k15; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k1; b10 += b11 + k0; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k3 + t1; b12 += b13 + k2; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k5 + 7; b14 += b15 + k4 + t2; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k9; b0 += b1 + k8; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k11; b2 += b3 + k10; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k13; b4 += b5 + k12; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k15; b6 += b7 + k14; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k0; b8 += b9 + k16; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k2; b10 += b11 + k1; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k4 + t2; b12 += b13 + k3; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k6 + 8; b14 += b15 + k5 + t0; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k10; b0 += b1 + k9; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k12; b2 += b3 + k11; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k14; b4 += b5 + k13; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k16; b6 += b7 + k15; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k1; b8 += b9 + k0; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k3; b10 += b11 + k2; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k5 + t0; b12 += b13 + k4; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k7 + 9; b14 += b15 + k6 + t1; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k11; b0 += b1 + k10; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k13; b2 += b3 + k12; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k15; b4 += b5 + k14; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k0; b6 += b7 + k16; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k2; b8 += b9 + k1; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k4; b10 += b11 + k3; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k6 + t1; b12 += b13 + k5; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k8 + 10; b14 += b15 + k7 + t2; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k12; b0 += b1 + k11; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k14; b2 += b3 + k13; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k16; b4 += b5 + k15; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k1; b6 += b7 + k0; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k3; b8 += b9 + k2; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k5; b10 += b11 + k4; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k7 + t2; b12 += b13 + k6; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k9 + 11; b14 += b15 + k8 + t0; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k13; b0 += b1 + k12; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k15; b2 += b3 + k14; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k0; b4 += b5 + k16; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k2; b6 += b7 + k1; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k4; b8 += b9 + k3; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k6; b10 += b11 + k5; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k8 + t0; b12 += b13 + k7; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k10 + 12; b14 += b15 + k9 + t1; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k14; b0 += b1 + k13; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k16; b2 += b3 + k15; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k1; b4 += b5 + k0; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k3; b6 += b7 + k2; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k5; b8 += b9 + k4; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k7; b10 += b11 + k6; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k9 + t1; b12 += b13 + k8; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k11 + 13; b14 += b15 + k10 + t2; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k15; b0 += b1 + k14; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k0; b2 += b3 + k16; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k2; b4 += b5 + k1; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k4; b6 += b7 + k3; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k6; b8 += b9 + k5; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k8; b10 += b11 + k7; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k10 + t2; b12 += b13 + k9; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k12 + 14; b14 += b15 + k11 + t0; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k16; b0 += b1 + k15; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k1; b2 += b3 + k0; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k3; b4 += b5 + k2; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k5; b6 += b7 + k4; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k7; b8 += b9 + k6; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k9; b10 += b11 + k8; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k11 + t0; b12 += b13 + k10; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k13 + 15; b14 += b15 + k12 + t1; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k0; b0 += b1 + k16; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k2; b2 += b3 + k1; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k4; b4 += b5 + k3; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k6; b6 += b7 + k5; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k8; b8 += b9 + k7; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k10; b10 += b11 + k9; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k12 + t1; b12 += b13 + k11; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k14 + 16; b14 += b15 + k13 + t2; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k1; b0 += b1 + k0; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k3; b2 += b3 + k2; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k5; b4 += b5 + k4; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k7; b6 += b7 + k6; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k9; b8 += b9 + k8; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k11; b10 += b11 + k10; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k13 + t2; b12 += b13 + k12; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k15 + 17; b14 += b15 + k14 + t0; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+            b1 += k2; b0 += b1 + k1; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
+            b3 += k4; b2 += b3 + k3; b3 = ((b3 << 13) | (b3 >> (64 - 13))) ^ b2;
+            b5 += k6; b4 += b5 + k5; b5 = ((b5 << 8) | (b5 >> (64 - 8))) ^ b4;
+            b7 += k8; b6 += b7 + k7; b7 = ((b7 << 47) | (b7 >> (64 - 47))) ^ b6;
+            b9 += k10; b8 += b9 + k9; b9 = ((b9 << 8) | (b9 >> (64 - 8))) ^ b8;
+            b11 += k12; b10 += b11 + k11; b11 = ((b11 << 17) | (b11 >> (64 - 17))) ^ b10;
+            b13 += k14 + t0; b12 += b13 + k13; b13 = ((b13 << 22) | (b13 >> (64 - 22))) ^ b12;
+            b15 += k16 + 18; b14 += b15 + k15 + t1; b15 = ((b15 << 37) | (b15 >> (64 - 37))) ^ b14;
+            b0 += b9; b9 = ((b9 << 38) | (b9 >> (64 - 38))) ^ b0;
+            b2 += b13; b13 = ((b13 << 19) | (b13 >> (64 - 19))) ^ b2;
+            b6 += b11; b11 = ((b11 << 10) | (b11 >> (64 - 10))) ^ b6;
+            b4 += b15; b15 = ((b15 << 55) | (b15 >> (64 - 55))) ^ b4;
+            b10 += b7; b7 = ((b7 << 49) | (b7 >> (64 - 49))) ^ b10;
+            b12 += b3; b3 = ((b3 << 18) | (b3 >> (64 - 18))) ^ b12;
+            b14 += b5; b5 = ((b5 << 23) | (b5 >> (64 - 23))) ^ b14;
+            b8 += b1; b1 = ((b1 << 52) | (b1 >> (64 - 52))) ^ b8;
+            b0 += b7; b7 = ((b7 << 33) | (b7 >> (64 - 33))) ^ b0;
+            b2 += b5; b5 = ((b5 << 4) | (b5 >> (64 - 4))) ^ b2;
+            b4 += b3; b3 = ((b3 << 51) | (b3 >> (64 - 51))) ^ b4;
+            b6 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b6;
+            b12 += b15; b15 = ((b15 << 34) | (b15 >> (64 - 34))) ^ b12;
+            b14 += b13; b13 = ((b13 << 41) | (b13 >> (64 - 41))) ^ b14;
+            b8 += b11; b11 = ((b11 << 59) | (b11 >> (64 - 59))) ^ b8;
+            b10 += b9; b9 = ((b9 << 17) | (b9 >> (64 - 17))) ^ b10;
+            b0 += b15; b15 = ((b15 << 5) | (b15 >> (64 - 5))) ^ b0;
+            b2 += b11; b11 = ((b11 << 20) | (b11 >> (64 - 20))) ^ b2;
+            b6 += b13; b13 = ((b13 << 48) | (b13 >> (64 - 48))) ^ b6;
+            b4 += b9; b9 = ((b9 << 41) | (b9 >> (64 - 41))) ^ b4;
+            b14 += b1; b1 = ((b1 << 47) | (b1 >> (64 - 47))) ^ b14;
+            b8 += b5; b5 = ((b5 << 28) | (b5 >> (64 - 28))) ^ b8;
+            b10 += b3; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b10;
+            b12 += b7; b7 = ((b7 << 25) | (b7 >> (64 - 25))) ^ b12;
+            b1 += k3; b0 += b1 + k2; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b0;
+            b3 += k5; b2 += b3 + k4; b3 = ((b3 << 9) | (b3 >> (64 - 9))) ^ b2;
+            b5 += k7; b4 += b5 + k6; b5 = ((b5 << 37) | (b5 >> (64 - 37))) ^ b4;
+            b7 += k9; b6 += b7 + k8; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b6;
+            b9 += k11; b8 += b9 + k10; b9 = ((b9 << 12) | (b9 >> (64 - 12))) ^ b8;
+            b11 += k13; b10 += b11 + k12; b11 = ((b11 << 47) | (b11 >> (64 - 47))) ^ b10;
+            b13 += k15 + t1; b12 += b13 + k14; b13 = ((b13 << 44) | (b13 >> (64 - 44))) ^ b12;
+            b15 += k0 + 19; b14 += b15 + k16 + t2; b15 = ((b15 << 30) | (b15 >> (64 - 30))) ^ b14;
+            b0 += b9; b9 = ((b9 << 16) | (b9 >> (64 - 16))) ^ b0;
+            b2 += b13; b13 = ((b13 << 34) | (b13 >> (64 - 34))) ^ b2;
+            b6 += b11; b11 = ((b11 << 56) | (b11 >> (64 - 56))) ^ b6;
+            b4 += b15; b15 = ((b15 << 51) | (b15 >> (64 - 51))) ^ b4;
+            b10 += b7; b7 = ((b7 << 4) | (b7 >> (64 - 4))) ^ b10;
+            b12 += b3; b3 = ((b3 << 53) | (b3 >> (64 - 53))) ^ b12;
+            b14 += b5; b5 = ((b5 << 42) | (b5 >> (64 - 42))) ^ b14;
+            b8 += b1; b1 = ((b1 << 41) | (b1 >> (64 - 41))) ^ b8;
+            b0 += b7; b7 = ((b7 << 31) | (b7 >> (64 - 31))) ^ b0;
+            b2 += b5; b5 = ((b5 << 44) | (b5 >> (64 - 44))) ^ b2;
+            b4 += b3; b3 = ((b3 << 47) | (b3 >> (64 - 47))) ^ b4;
+            b6 += b1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b6;
+            b12 += b15; b15 = ((b15 << 19) | (b15 >> (64 - 19))) ^ b12;
+            b14 += b13; b13 = ((b13 << 42) | (b13 >> (64 - 42))) ^ b14;
+            b8 += b11; b11 = ((b11 << 44) | (b11 >> (64 - 44))) ^ b8;
+            b10 += b9; b9 = ((b9 << 25) | (b9 >> (64 - 25))) ^ b10;
+            b0 += b15; b15 = ((b15 << 9) | (b15 >> (64 - 9))) ^ b0;
+            b2 += b11; b11 = ((b11 << 48) | (b11 >> (64 - 48))) ^ b2;
+            b6 += b13; b13 = ((b13 << 35) | (b13 >> (64 - 35))) ^ b6;
+            b4 += b9; b9 = ((b9 << 52) | (b9 >> (64 - 52))) ^ b4;
+            b14 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b14;
+            b8 += b5; b5 = ((b5 << 31) | (b5 >> (64 - 31))) ^ b8;
+            b10 += b3; b3 = ((b3 << 37) | (b3 >> (64 - 37))) ^ b10;
+            b12 += b7; b7 = ((b7 << 20) | (b7 >> (64 - 20))) ^ b12;
+
+            output[0] = b0 + k3;
+            output[1] = b1 + k4;
+            output[2] = b2 + k5;
+            output[3] = b3 + k6;
+            output[4] = b4 + k7;
+            output[5] = b5 + k8;
+            output[6] = b6 + k9;
+            output[7] = b7 + k10;
+            output[8] = b8 + k11;
+            output[9] = b9 + k12;
+            output[10] = b10 + k13;
+            output[11] = b11 + k14;
+            output[12] = b12 + k15;
+            output[13] = b13 + k16 + t2;
+            output[14] = b14 + k0 + t0;
+            output[15] = b15 + k1 + 20;
+        }
+
+void threefishDecrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+{
+
+    uint64_t b0 = input[0], b1 = input[1],
+      b2 = input[2], b3 = input[3],
+      b4 = input[4], b5 = input[5],
+      b6 = input[6], b7 = input[7],
+      b8 = input[8], b9 = input[9],
+      b10 = input[10], b11 = input[11],
+      b12 = input[12], b13 = input[13],
+      b14 = input[14], b15 = input[15];
+    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+      k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+      k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+      k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+      k8 = keyCtx->key[8], k9 = keyCtx->key[9],
+      k10 = keyCtx->key[10], k11 = keyCtx->key[11],
+      k12 = keyCtx->key[12], k13 = keyCtx->key[13],
+      k14 = keyCtx->key[14], k15 = keyCtx->key[15],
+      k16 = keyCtx->key[16];
+    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+      t2 = keyCtx->tweak[2];
+    uint64_t tmp;
+
+            b0 -= k3;
+            b1 -= k4;
+            b2 -= k5;
+            b3 -= k6;
+            b4 -= k7;
+            b5 -= k8;
+            b6 -= k9;
+            b7 -= k10;
+            b8 -= k11;
+            b9 -= k12;
+            b10 -= k13;
+            b11 -= k14;
+            b12 -= k15;
+            b13 -= k16 + t2;
+            b14 -= k0 + t0;
+            b15 -= k1 + 20;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k16 + t2; b15 -= k0 + 19;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k14; b13 -= k15 + t1;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k12; b11 -= k13;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k10; b9 -= k11;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k8; b7 -= k9;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k6; b5 -= k7;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k4; b3 -= k5;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k2; b1 -= k3;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k15 + t1; b15 -= k16 + 18;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k13; b13 -= k14 + t0;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k11; b11 -= k12;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k9; b9 -= k10;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k7; b7 -= k8;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k5; b5 -= k6;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k3; b3 -= k4;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k1; b1 -= k2;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k14 + t0; b15 -= k15 + 17;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k12; b13 -= k13 + t2;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k10; b11 -= k11;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k8; b9 -= k9;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k6; b7 -= k7;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k4; b5 -= k5;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k2; b3 -= k3;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k0; b1 -= k1;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k13 + t2; b15 -= k14 + 16;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k11; b13 -= k12 + t1;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k9; b11 -= k10;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k7; b9 -= k8;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k5; b7 -= k6;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k3; b5 -= k4;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k1; b3 -= k2;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k16; b1 -= k0;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k12 + t1; b15 -= k13 + 15;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k10; b13 -= k11 + t0;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k8; b11 -= k9;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k6; b9 -= k7;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k4; b7 -= k5;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k2; b5 -= k3;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k0; b3 -= k1;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k15; b1 -= k16;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k11 + t0; b15 -= k12 + 14;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k9; b13 -= k10 + t2;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k7; b11 -= k8;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k5; b9 -= k6;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k3; b7 -= k4;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k1; b5 -= k2;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k16; b3 -= k0;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k14; b1 -= k15;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k10 + t2; b15 -= k11 + 13;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k8; b13 -= k9 + t1;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k6; b11 -= k7;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k4; b9 -= k5;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k2; b7 -= k3;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k0; b5 -= k1;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k15; b3 -= k16;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k13; b1 -= k14;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k9 + t1; b15 -= k10 + 12;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k7; b13 -= k8 + t0;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k5; b11 -= k6;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k3; b9 -= k4;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k1; b7 -= k2;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k16; b5 -= k0;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k14; b3 -= k15;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k12; b1 -= k13;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k8 + t0; b15 -= k9 + 11;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k6; b13 -= k7 + t2;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k4; b11 -= k5;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k2; b9 -= k3;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k0; b7 -= k1;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k15; b5 -= k16;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k13; b3 -= k14;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k11; b1 -= k12;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k7 + t2; b15 -= k8 + 10;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k5; b13 -= k6 + t1;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k3; b11 -= k4;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k1; b9 -= k2;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k16; b7 -= k0;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k14; b5 -= k15;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k12; b3 -= k13;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k10; b1 -= k11;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k6 + t1; b15 -= k7 + 9;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k4; b13 -= k5 + t0;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k2; b11 -= k3;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k0; b9 -= k1;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k15; b7 -= k16;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k13; b5 -= k14;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k11; b3 -= k12;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k9; b1 -= k10;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k5 + t0; b15 -= k6 + 8;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k3; b13 -= k4 + t2;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k1; b11 -= k2;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k16; b9 -= k0;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k14; b7 -= k15;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k12; b5 -= k13;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k10; b3 -= k11;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k8; b1 -= k9;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k4 + t2; b15 -= k5 + 7;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k2; b13 -= k3 + t1;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k0; b11 -= k1;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k15; b9 -= k16;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k13; b7 -= k14;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k11; b5 -= k12;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k9; b3 -= k10;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k7; b1 -= k8;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k3 + t1; b15 -= k4 + 6;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k1; b13 -= k2 + t0;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k16; b11 -= k0;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k14; b9 -= k15;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k12; b7 -= k13;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k10; b5 -= k11;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k8; b3 -= k9;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k6; b1 -= k7;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k2 + t0; b15 -= k3 + 5;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k0; b13 -= k1 + t2;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k15; b11 -= k16;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k13; b9 -= k14;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k11; b7 -= k12;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k9; b5 -= k10;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k7; b3 -= k8;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k5; b1 -= k6;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k1 + t2; b15 -= k2 + 4;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k16; b13 -= k0 + t1;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k14; b11 -= k15;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k12; b9 -= k13;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k10; b7 -= k11;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k8; b5 -= k9;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k6; b3 -= k7;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k4; b1 -= k5;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k0 + t1; b15 -= k1 + 3;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k15; b13 -= k16 + t0;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k13; b11 -= k14;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k11; b9 -= k12;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k9; b7 -= k10;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k7; b5 -= k8;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k5; b3 -= k6;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k3; b1 -= k4;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k16 + t0; b15 -= k0 + 2;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k14; b13 -= k15 + t2;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k12; b11 -= k13;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k10; b9 -= k11;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k8; b7 -= k9;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k6; b5 -= k7;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k4; b3 -= k5;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k2; b1 -= k3;
+            tmp = b7 ^ b12; b7 = (tmp >> 20) | (tmp << (64 - 20)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 37) | (tmp << (64 - 37)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 31) | (tmp << (64 - 31)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 52) | (tmp << (64 - 52)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 35) | (tmp << (64 - 35)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 48) | (tmp << (64 - 48)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 25) | (tmp << (64 - 25)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 44) | (tmp << (64 - 44)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 19) | (tmp << (64 - 19)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 46) | (tmp << (64 - 46)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 47) | (tmp << (64 - 47)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 44) | (tmp << (64 - 44)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 31) | (tmp << (64 - 31)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 41) | (tmp << (64 - 41)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 42) | (tmp << (64 - 42)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 53) | (tmp << (64 - 53)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 4) | (tmp << (64 - 4)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 56) | (tmp << (64 - 56)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 34) | (tmp << (64 - 34)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 16) | (tmp << (64 - 16)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 30) | (tmp << (64 - 30)); b14 -= b15 + k15 + t2; b15 -= k16 + 1;
+            tmp = b13 ^ b12; b13 = (tmp >> 44) | (tmp << (64 - 44)); b12 -= b13 + k13; b13 -= k14 + t1;
+            tmp = b11 ^ b10; b11 = (tmp >> 47) | (tmp << (64 - 47)); b10 -= b11 + k11; b11 -= k12;
+            tmp = b9 ^ b8; b9 = (tmp >> 12) | (tmp << (64 - 12)); b8 -= b9 + k9; b9 -= k10;
+            tmp = b7 ^ b6; b7 = (tmp >> 31) | (tmp << (64 - 31)); b6 -= b7 + k7; b7 -= k8;
+            tmp = b5 ^ b4; b5 = (tmp >> 37) | (tmp << (64 - 37)); b4 -= b5 + k5; b5 -= k6;
+            tmp = b3 ^ b2; b3 = (tmp >> 9) | (tmp << (64 - 9)); b2 -= b3 + k3; b3 -= k4;
+            tmp = b1 ^ b0; b1 = (tmp >> 41) | (tmp << (64 - 41)); b0 -= b1 + k1; b1 -= k2;
+            tmp = b7 ^ b12; b7 = (tmp >> 25) | (tmp << (64 - 25)); b12 -= b7;
+            tmp = b3 ^ b10; b3 = (tmp >> 16) | (tmp << (64 - 16)); b10 -= b3;
+            tmp = b5 ^ b8; b5 = (tmp >> 28) | (tmp << (64 - 28)); b8 -= b5;
+            tmp = b1 ^ b14; b1 = (tmp >> 47) | (tmp << (64 - 47)); b14 -= b1;
+            tmp = b9 ^ b4; b9 = (tmp >> 41) | (tmp << (64 - 41)); b4 -= b9;
+            tmp = b13 ^ b6; b13 = (tmp >> 48) | (tmp << (64 - 48)); b6 -= b13;
+            tmp = b11 ^ b2; b11 = (tmp >> 20) | (tmp << (64 - 20)); b2 -= b11;
+            tmp = b15 ^ b0; b15 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b15;
+            tmp = b9 ^ b10; b9 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b9;
+            tmp = b11 ^ b8; b11 = (tmp >> 59) | (tmp << (64 - 59)); b8 -= b11;
+            tmp = b13 ^ b14; b13 = (tmp >> 41) | (tmp << (64 - 41)); b14 -= b13;
+            tmp = b15 ^ b12; b15 = (tmp >> 34) | (tmp << (64 - 34)); b12 -= b15;
+            tmp = b1 ^ b6; b1 = (tmp >> 13) | (tmp << (64 - 13)); b6 -= b1;
+            tmp = b3 ^ b4; b3 = (tmp >> 51) | (tmp << (64 - 51)); b4 -= b3;
+            tmp = b5 ^ b2; b5 = (tmp >> 4) | (tmp << (64 - 4)); b2 -= b5;
+            tmp = b7 ^ b0; b7 = (tmp >> 33) | (tmp << (64 - 33)); b0 -= b7;
+            tmp = b1 ^ b8; b1 = (tmp >> 52) | (tmp << (64 - 52)); b8 -= b1;
+            tmp = b5 ^ b14; b5 = (tmp >> 23) | (tmp << (64 - 23)); b14 -= b5;
+            tmp = b3 ^ b12; b3 = (tmp >> 18) | (tmp << (64 - 18)); b12 -= b3;
+            tmp = b7 ^ b10; b7 = (tmp >> 49) | (tmp << (64 - 49)); b10 -= b7;
+            tmp = b15 ^ b4; b15 = (tmp >> 55) | (tmp << (64 - 55)); b4 -= b15;
+            tmp = b11 ^ b6; b11 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b11;
+            tmp = b13 ^ b2; b13 = (tmp >> 19) | (tmp << (64 - 19)); b2 -= b13;
+            tmp = b9 ^ b0; b9 = (tmp >> 38) | (tmp << (64 - 38)); b0 -= b9;
+            tmp = b15 ^ b14; b15 = (tmp >> 37) | (tmp << (64 - 37)); b14 -= b15 + k14 + t1; b15 -= k15;
+            tmp = b13 ^ b12; b13 = (tmp >> 22) | (tmp << (64 - 22)); b12 -= b13 + k12; b13 -= k13 + t0;
+            tmp = b11 ^ b10; b11 = (tmp >> 17) | (tmp << (64 - 17)); b10 -= b11 + k10; b11 -= k11;
+            tmp = b9 ^ b8; b9 = (tmp >> 8) | (tmp << (64 - 8)); b8 -= b9 + k8; b9 -= k9;
+            tmp = b7 ^ b6; b7 = (tmp >> 47) | (tmp << (64 - 47)); b6 -= b7 + k6; b7 -= k7;
+            tmp = b5 ^ b4; b5 = (tmp >> 8) | (tmp << (64 - 8)); b4 -= b5 + k4; b5 -= k5;
+            tmp = b3 ^ b2; b3 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b3 + k2; b3 -= k3;
+            tmp = b1 ^ b0; b1 = (tmp >> 24) | (tmp << (64 - 24)); b0 -= b1 + k0; b1 -= k1;
+
+            output[15] = b15;
+            output[14] = b14;
+            output[13] = b13;
+            output[12] = b12;
+            output[11] = b11;
+            output[10] = b10;
+            output[9] = b9;
+            output[8] = b8;
+            output[7] = b7;
+            output[6] = b6;
+            output[5] = b5;
+            output[4] = b4;
+            output[3] = b3;
+            output[2] = b2;
+            output[1] = b1;
+            output[0] = b0;
+}
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
new file mode 100644
index 000000000000..db2b81978c91
--- /dev/null
+++ b/drivers/staging/skein/threefish256Block.c
@@ -0,0 +1,349 @@
+#include <threefishApi.h>
+#include <stdint.h>
+#include <string.h>
+
+
+void threefishEncrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+  {
+
+    uint64_t b0 = input[0], b1 = input[1],
+      b2 = input[2], b3 = input[3];
+    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+      k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+      k4 = keyCtx->key[4];
+    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+      t2 = keyCtx->tweak[2];
+
+    b1 += k1 + t0; b0 += b1 + k0; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k3; b2 += b3 + k2 + t1; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k2 + t1; b0 += b1 + k1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k4 + 1; b2 += b3 + k3 + t2; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    b1 += k3 + t2; b0 += b1 + k2; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k0 + 2; b2 += b3 + k4 + t0; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k4 + t0; b0 += b1 + k3; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k1 + 3; b2 += b3 + k0 + t1; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    b1 += k0 + t1; b0 += b1 + k4; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k2 + 4; b2 += b3 + k1 + t2; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k1 + t2; b0 += b1 + k0; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k3 + 5; b2 += b3 + k2 + t0; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    b1 += k2 + t0; b0 += b1 + k1; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k4 + 6; b2 += b3 + k3 + t1; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k3 + t1; b0 += b1 + k2; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k0 + 7; b2 += b3 + k4 + t2; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    b1 += k4 + t2; b0 += b1 + k3; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k1 + 8; b2 += b3 + k0 + t0; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k0 + t0; b0 += b1 + k4; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k2 + 9; b2 += b3 + k1 + t1; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    b1 += k1 + t1; b0 += b1 + k0; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k3 + 10; b2 += b3 + k2 + t2; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k2 + t2; b0 += b1 + k1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k4 + 11; b2 += b3 + k3 + t0; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    b1 += k3 + t0; b0 += b1 + k2; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k0 + 12; b2 += b3 + k4 + t1; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k4 + t1; b0 += b1 + k3; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k1 + 13; b2 += b3 + k0 + t2; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    b1 += k0 + t2; b0 += b1 + k4; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k2 + 14; b2 += b3 + k1 + t0; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k1 + t0; b0 += b1 + k0; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k3 + 15; b2 += b3 + k2 + t1; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    b1 += k2 + t1; b0 += b1 + k1; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
+    b3 += k4 + 16; b2 += b3 + k3 + t2; b3 = ((b3 << 16) | (b3 >> (64 - 16))) ^ b2;
+    b0 += b3; b3 = ((b3 << 52) | (b3 >> (64 - 52))) ^ b0;
+    b2 += b1; b1 = ((b1 << 57) | (b1 >> (64 - 57))) ^ b2;
+    b0 += b1; b1 = ((b1 << 23) | (b1 >> (64 - 23))) ^ b0;
+    b2 += b3; b3 = ((b3 << 40) | (b3 >> (64 - 40))) ^ b2;
+    b0 += b3; b3 = ((b3 << 5) | (b3 >> (64 - 5))) ^ b0;
+    b2 += b1; b1 = ((b1 << 37) | (b1 >> (64 - 37))) ^ b2;
+    b1 += k3 + t2; b0 += b1 + k2; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b0;
+    b3 += k0 + 17; b2 += b3 + k4 + t0; b3 = ((b3 << 33) | (b3 >> (64 - 33))) ^ b2;
+    b0 += b3; b3 = ((b3 << 46) | (b3 >> (64 - 46))) ^ b0;
+    b2 += b1; b1 = ((b1 << 12) | (b1 >> (64 - 12))) ^ b2;
+    b0 += b1; b1 = ((b1 << 58) | (b1 >> (64 - 58))) ^ b0;
+    b2 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b2;
+    b0 += b3; b3 = ((b3 << 32) | (b3 >> (64 - 32))) ^ b0;
+    b2 += b1; b1 = ((b1 << 32) | (b1 >> (64 - 32))) ^ b2;
+
+    output[0] = b0 + k3;
+    output[1] = b1 + k4 + t0;
+    output[2] = b2 + k0 + t1;
+    output[3] = b3 + k1 + 18;
+  }
+
+void threefishDecrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+  {
+    uint64_t b0 = input[0], b1 = input[1],
+      b2 = input[2], b3 = input[3];
+    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+      k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+      k4 = keyCtx->key[4];
+    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+      t2 = keyCtx->tweak[2];
+
+    uint64_t tmp;
+
+    b0 -= k3;
+    b1 -= k4 + t0;
+    b2 -= k0 + t1;
+    b3 -= k1 + 18;
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k2; b1 -= k3 + t2;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k4 + t0; b3 -= k0 + 17;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k1; b1 -= k2 + t1;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k3 + t2; b3 -= k4 + 16;
+
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k0; b1 -= k1 + t0;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k2 + t1; b3 -= k3 + 15;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k4; b1 -= k0 + t2;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k1 + t0; b3 -= k2 + 14;
+
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k3; b1 -= k4 + t1;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k0 + t2; b3 -= k1 + 13;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k2; b1 -= k3 + t0;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k4 + t1; b3 -= k0 + 12;
+
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k1; b1 -= k2 + t2;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k3 + t0; b3 -= k4 + 11;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k0; b1 -= k1 + t1;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k2 + t2; b3 -= k3 + 10;
+
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k4; b1 -= k0 + t0;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k1 + t1; b3 -= k2 + 9;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k3; b1 -= k4 + t2;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k0 + t0; b3 -= k1 + 8;
+
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k2; b1 -= k3 + t1;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k4 + t2; b3 -= k0 + 7;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k1; b1 -= k2 + t0;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k3 + t1; b3 -= k4 + 6;
+
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k0; b1 -= k1 + t2;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k2 + t0; b3 -= k3 + 5;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k4; b1 -= k0 + t1;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k1 + t2; b3 -= k2 + 4;
+
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k3; b1 -= k4 + t0;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k0 + t1; b3 -= k1 + 3;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k2; b1 -= k3 + t2;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k4 + t0; b3 -= k0 + 2;
+
+    tmp = b3 ^ b0; b3 = (tmp >> 32) | (tmp << (64 - 32)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 32) | (tmp << (64 - 32)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 58) | (tmp << (64 - 58)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 22) | (tmp << (64 - 22)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 12) | (tmp << (64 - 12)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 25) | (tmp << (64 - 25)); b0 -= b1 + k1; b1 -= k2 + t1;
+    tmp = b3 ^ b2; b3 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b3 + k3 + t2; b3 -= k4 + 1;
+    tmp = b3 ^ b0; b3 = (tmp >> 5) | (tmp << (64 - 5)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 37) | (tmp << (64 - 37)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 23) | (tmp << (64 - 23)); b0 -= b1;
+    tmp = b3 ^ b2; b3 = (tmp >> 40) | (tmp << (64 - 40)); b2 -= b3;
+    tmp = b3 ^ b0; b3 = (tmp >> 52) | (tmp << (64 - 52)); b0 -= b3;
+    tmp = b1 ^ b2; b1 = (tmp >> 57) | (tmp << (64 - 57)); b2 -= b1;
+    tmp = b1 ^ b0; b1 = (tmp >> 14) | (tmp << (64 - 14)); b0 -= b1 + k0; b1 -= k1 + t0;
+    tmp = b3 ^ b2; b3 = (tmp >> 16) | (tmp << (64 - 16)); b2 -= b3 + k2 + t1; b3 -= k3;
+
+    output[0] = b0;
+    output[1] = b1;
+    output[2] = b2;
+    output[3] = b3;
+  }
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
new file mode 100644
index 000000000000..4fe708fea066
--- /dev/null
+++ b/drivers/staging/skein/threefish512Block.c
@@ -0,0 +1,643 @@
+#include <threefishApi.h>
+#include <stdint.h>
+#include <string.h>
+
+
+void threefishEncrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+    {
+
+    uint64_t b0 = input[0], b1 = input[1],
+      b2 = input[2], b3 = input[3],
+      b4 = input[4], b5 = input[5],
+      b6 = input[6], b7 = input[7];
+    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+      k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+      k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+      k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+      k8 = keyCtx->key[8];
+    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+      t2 = keyCtx->tweak[2];
+
+        b1 += k1; b0 += b1 + k0; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k3; b2 += b3 + k2; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k5 + t0; b4 += b5 + k4; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k7; b6 += b7 + k6 + t1; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k2; b0 += b1 + k1; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k4; b2 += b3 + k3; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k6 + t1; b4 += b5 + k5; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k8 + 1; b6 += b7 + k7 + t2; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+        b1 += k3; b0 += b1 + k2; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k5; b2 += b3 + k4; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k7 + t2; b4 += b5 + k6; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k0 + 2; b6 += b7 + k8 + t0; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k4; b0 += b1 + k3; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k6; b2 += b3 + k5; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k8 + t0; b4 += b5 + k7; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k1 + 3; b6 += b7 + k0 + t1; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+        b1 += k5; b0 += b1 + k4; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k7; b2 += b3 + k6; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k0 + t1; b4 += b5 + k8; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k2 + 4; b6 += b7 + k1 + t2; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k6; b0 += b1 + k5; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k8; b2 += b3 + k7; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k1 + t2; b4 += b5 + k0; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k3 + 5; b6 += b7 + k2 + t0; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+        b1 += k7; b0 += b1 + k6; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k0; b2 += b3 + k8; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k2 + t0; b4 += b5 + k1; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k4 + 6; b6 += b7 + k3 + t1; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k8; b0 += b1 + k7; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k1; b2 += b3 + k0; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k3 + t1; b4 += b5 + k2; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k5 + 7; b6 += b7 + k4 + t2; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+        b1 += k0; b0 += b1 + k8; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k2; b2 += b3 + k1; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k4 + t2; b4 += b5 + k3; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k6 + 8; b6 += b7 + k5 + t0; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k1; b0 += b1 + k0; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k3; b2 += b3 + k2; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k5 + t0; b4 += b5 + k4; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k7 + 9; b6 += b7 + k6 + t1; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+        b1 += k2; b0 += b1 + k1; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k4; b2 += b3 + k3; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k6 + t1; b4 += b5 + k5; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k8 + 10; b6 += b7 + k7 + t2; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k3; b0 += b1 + k2; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k5; b2 += b3 + k4; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k7 + t2; b4 += b5 + k6; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k0 + 11; b6 += b7 + k8 + t0; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+        b1 += k4; b0 += b1 + k3; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k6; b2 += b3 + k5; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k8 + t0; b4 += b5 + k7; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k1 + 12; b6 += b7 + k0 + t1; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k5; b0 += b1 + k4; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k7; b2 += b3 + k6; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k0 + t1; b4 += b5 + k8; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k2 + 13; b6 += b7 + k1 + t2; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+        b1 += k6; b0 += b1 + k5; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k8; b2 += b3 + k7; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k1 + t2; b4 += b5 + k0; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k3 + 14; b6 += b7 + k2 + t0; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k7; b0 += b1 + k6; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k0; b2 += b3 + k8; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k2 + t0; b4 += b5 + k1; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k4 + 15; b6 += b7 + k3 + t1; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+        b1 += k8; b0 += b1 + k7; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
+        b3 += k1; b2 += b3 + k0; b3 = ((b3 << 36) | (b3 >> (64 - 36))) ^ b2;
+        b5 += k3 + t1; b4 += b5 + k2; b5 = ((b5 << 19) | (b5 >> (64 - 19))) ^ b4;
+        b7 += k5 + 16; b6 += b7 + k4 + t2; b7 = ((b7 << 37) | (b7 >> (64 - 37))) ^ b6;
+        b2 += b1; b1 = ((b1 << 33) | (b1 >> (64 - 33))) ^ b2;
+        b4 += b7; b7 = ((b7 << 27) | (b7 >> (64 - 27))) ^ b4;
+        b6 += b5; b5 = ((b5 << 14) | (b5 >> (64 - 14))) ^ b6;
+        b0 += b3; b3 = ((b3 << 42) | (b3 >> (64 - 42))) ^ b0;
+        b4 += b1; b1 = ((b1 << 17) | (b1 >> (64 - 17))) ^ b4;
+        b6 += b3; b3 = ((b3 << 49) | (b3 >> (64 - 49))) ^ b6;
+        b0 += b5; b5 = ((b5 << 36) | (b5 >> (64 - 36))) ^ b0;
+        b2 += b7; b7 = ((b7 << 39) | (b7 >> (64 - 39))) ^ b2;
+        b6 += b1; b1 = ((b1 << 44) | (b1 >> (64 - 44))) ^ b6;
+        b0 += b7; b7 = ((b7 << 9) | (b7 >> (64 - 9))) ^ b0;
+        b2 += b5; b5 = ((b5 << 54) | (b5 >> (64 - 54))) ^ b2;
+        b4 += b3; b3 = ((b3 << 56) | (b3 >> (64 - 56))) ^ b4;
+        b1 += k0; b0 += b1 + k8; b1 = ((b1 << 39) | (b1 >> (64 - 39))) ^ b0;
+        b3 += k2; b2 += b3 + k1; b3 = ((b3 << 30) | (b3 >> (64 - 30))) ^ b2;
+        b5 += k4 + t2; b4 += b5 + k3; b5 = ((b5 << 34) | (b5 >> (64 - 34))) ^ b4;
+        b7 += k6 + 17; b6 += b7 + k5 + t0; b7 = ((b7 << 24) | (b7 >> (64 - 24))) ^ b6;
+        b2 += b1; b1 = ((b1 << 13) | (b1 >> (64 - 13))) ^ b2;
+        b4 += b7; b7 = ((b7 << 50) | (b7 >> (64 - 50))) ^ b4;
+        b6 += b5; b5 = ((b5 << 10) | (b5 >> (64 - 10))) ^ b6;
+        b0 += b3; b3 = ((b3 << 17) | (b3 >> (64 - 17))) ^ b0;
+        b4 += b1; b1 = ((b1 << 25) | (b1 >> (64 - 25))) ^ b4;
+        b6 += b3; b3 = ((b3 << 29) | (b3 >> (64 - 29))) ^ b6;
+        b0 += b5; b5 = ((b5 << 39) | (b5 >> (64 - 39))) ^ b0;
+        b2 += b7; b7 = ((b7 << 43) | (b7 >> (64 - 43))) ^ b2;
+        b6 += b1; b1 = ((b1 << 8) | (b1 >> (64 - 8))) ^ b6;
+        b0 += b7; b7 = ((b7 << 35) | (b7 >> (64 - 35))) ^ b0;
+        b2 += b5; b5 = ((b5 << 56) | (b5 >> (64 - 56))) ^ b2;
+        b4 += b3; b3 = ((b3 << 22) | (b3 >> (64 - 22))) ^ b4;
+
+        output[0] = b0 + k0;
+        output[1] = b1 + k1;
+        output[2] = b2 + k2;
+        output[3] = b3 + k3;
+        output[4] = b4 + k4;
+        output[5] = b5 + k5 + t0;
+        output[6] = b6 + k6 + t1;
+        output[7] = b7 + k7 + 18;
+    }
+
+void threefishDecrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+    {
+
+    uint64_t b0 = input[0], b1 = input[1],
+      b2 = input[2], b3 = input[3],
+      b4 = input[4], b5 = input[5],
+      b6 = input[6], b7 = input[7];
+    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+      k2 = keyCtx->key[2], k3 = keyCtx->key[3],
+      k4 = keyCtx->key[4], k5 = keyCtx->key[5],
+      k6 = keyCtx->key[6], k7 = keyCtx->key[7],
+      k8 = keyCtx->key[8];
+    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+      t2 = keyCtx->tweak[2];
+
+      uint64_t tmp;
+
+        b0 -= k0;
+        b1 -= k1;
+        b2 -= k2;
+        b3 -= k3;
+        b4 -= k4;
+        b5 -= k5 + t0;
+        b6 -= k6 + t1;
+        b7 -= k7 + 18;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k5 + t0; b7 -= k6 + 17;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k3; b5 -= k4 + t2;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k1; b3 -= k2;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k8; b1 -= k0;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k4 + t2; b7 -= k5 + 16;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k2; b5 -= k3 + t1;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k0; b3 -= k1;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k7; b1 -= k8;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k3 + t1; b7 -= k4 + 15;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k1; b5 -= k2 + t0;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k8; b3 -= k0;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k6; b1 -= k7;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k2 + t0; b7 -= k3 + 14;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k0; b5 -= k1 + t2;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k7; b3 -= k8;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k5; b1 -= k6;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k1 + t2; b7 -= k2 + 13;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k8; b5 -= k0 + t1;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k6; b3 -= k7;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k4; b1 -= k5;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k0 + t1; b7 -= k1 + 12;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k7; b5 -= k8 + t0;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k5; b3 -= k6;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k3; b1 -= k4;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k8 + t0; b7 -= k0 + 11;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k6; b5 -= k7 + t2;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k4; b3 -= k5;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k2; b1 -= k3;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k7 + t2; b7 -= k8 + 10;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k5; b5 -= k6 + t1;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k3; b3 -= k4;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k1; b1 -= k2;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k6 + t1; b7 -= k7 + 9;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k4; b5 -= k5 + t0;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k2; b3 -= k3;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k0; b1 -= k1;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k5 + t0; b7 -= k6 + 8;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k3; b5 -= k4 + t2;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k1; b3 -= k2;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k8; b1 -= k0;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k4 + t2; b7 -= k5 + 7;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k2; b5 -= k3 + t1;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k0; b3 -= k1;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k7; b1 -= k8;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k3 + t1; b7 -= k4 + 6;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k1; b5 -= k2 + t0;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k8; b3 -= k0;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k6; b1 -= k7;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k2 + t0; b7 -= k3 + 5;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k0; b5 -= k1 + t2;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k7; b3 -= k8;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k5; b1 -= k6;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k1 + t2; b7 -= k2 + 4;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k8; b5 -= k0 + t1;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k6; b3 -= k7;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k4; b1 -= k5;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k0 + t1; b7 -= k1 + 3;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k7; b5 -= k8 + t0;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k5; b3 -= k6;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k3; b1 -= k4;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k8 + t0; b7 -= k0 + 2;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k6; b5 -= k7 + t2;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k4; b3 -= k5;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k2; b1 -= k3;
+        tmp = b3 ^ b4; b3 = (tmp >> 22) | (tmp << (64 - 22)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 56) | (tmp << (64 - 56)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 35) | (tmp << (64 - 35)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 8) | (tmp << (64 - 8)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 43) | (tmp << (64 - 43)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 29) | (tmp << (64 - 29)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 25) | (tmp << (64 - 25)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 17) | (tmp << (64 - 17)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 10) | (tmp << (64 - 10)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 50) | (tmp << (64 - 50)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 13) | (tmp << (64 - 13)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 24) | (tmp << (64 - 24)); b6 -= b7 + k7 + t2; b7 -= k8 + 1;
+        tmp = b5 ^ b4; b5 = (tmp >> 34) | (tmp << (64 - 34)); b4 -= b5 + k5; b5 -= k6 + t1;
+        tmp = b3 ^ b2; b3 = (tmp >> 30) | (tmp << (64 - 30)); b2 -= b3 + k3; b3 -= k4;
+        tmp = b1 ^ b0; b1 = (tmp >> 39) | (tmp << (64 - 39)); b0 -= b1 + k1; b1 -= k2;
+        tmp = b3 ^ b4; b3 = (tmp >> 56) | (tmp << (64 - 56)); b4 -= b3;
+        tmp = b5 ^ b2; b5 = (tmp >> 54) | (tmp << (64 - 54)); b2 -= b5;
+        tmp = b7 ^ b0; b7 = (tmp >> 9) | (tmp << (64 - 9)); b0 -= b7;
+        tmp = b1 ^ b6; b1 = (tmp >> 44) | (tmp << (64 - 44)); b6 -= b1;
+        tmp = b7 ^ b2; b7 = (tmp >> 39) | (tmp << (64 - 39)); b2 -= b7;
+        tmp = b5 ^ b0; b5 = (tmp >> 36) | (tmp << (64 - 36)); b0 -= b5;
+        tmp = b3 ^ b6; b3 = (tmp >> 49) | (tmp << (64 - 49)); b6 -= b3;
+        tmp = b1 ^ b4; b1 = (tmp >> 17) | (tmp << (64 - 17)); b4 -= b1;
+        tmp = b3 ^ b0; b3 = (tmp >> 42) | (tmp << (64 - 42)); b0 -= b3;
+        tmp = b5 ^ b6; b5 = (tmp >> 14) | (tmp << (64 - 14)); b6 -= b5;
+        tmp = b7 ^ b4; b7 = (tmp >> 27) | (tmp << (64 - 27)); b4 -= b7;
+        tmp = b1 ^ b2; b1 = (tmp >> 33) | (tmp << (64 - 33)); b2 -= b1;
+        tmp = b7 ^ b6; b7 = (tmp >> 37) | (tmp << (64 - 37)); b6 -= b7 + k6 + t1; b7 -= k7;
+        tmp = b5 ^ b4; b5 = (tmp >> 19) | (tmp << (64 - 19)); b4 -= b5 + k4; b5 -= k5 + t0;
+        tmp = b3 ^ b2; b3 = (tmp >> 36) | (tmp << (64 - 36)); b2 -= b3 + k2; b3 -= k3;
+        tmp = b1 ^ b0; b1 = (tmp >> 46) | (tmp << (64 - 46)); b0 -= b1 + k0; b1 -= k1;
+
+    output[0] = b0;
+    output[1] = b1;
+    output[2] = b2;
+    output[3] = b3;
+
+        output[7] = b7;
+        output[6] = b6;
+        output[5] = b5;
+        output[4] = b4;
+}
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
new file mode 100644
index 000000000000..5afa0338aef4
--- /dev/null
+++ b/drivers/staging/skein/threefishApi.c
@@ -0,0 +1,79 @@
+
+
+#include <threefishApi.h>
+#include <stdlib.h>
+#include <string.h>
+
+void threefishSetKey(ThreefishKey_t* keyCtx, ThreefishSize_t stateSize,
+                     uint64_t* keyData, uint64_t* tweak)
+{
+    int keyWords = stateSize / 64;
+    int i;
+    uint64_t parity = KeyScheduleConst;
+
+    keyCtx->tweak[0] = tweak[0];
+    keyCtx->tweak[1] = tweak[1];
+    keyCtx->tweak[2] = tweak[0] ^ tweak[1];
+
+    for (i = 0; i < keyWords; i++) {
+        keyCtx->key[i] = keyData[i];
+        parity ^= keyData[i];
+    }
+    keyCtx->key[i] = parity;
+    keyCtx->stateSize = stateSize;
+}
+
+void threefishEncryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in,
+                                uint8_t* out)
+{
+    u64b_t plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
+    u64b_t cipher[SKEIN_MAX_STATE_WORDS];
+    
+    Skein_Get64_LSB_First(plain, in, keyCtx->stateSize / 64);   /* bytes to words */
+    threefishEncryptBlockWords(keyCtx, plain, cipher);
+    Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);  /* words to bytes */
+}
+
+void threefishEncryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in,
+                                uint64_t* out)
+{
+    switch (keyCtx->stateSize) {
+        case Threefish256:
+            threefishEncrypt256(keyCtx, in, out);
+            break;
+        case Threefish512:
+            threefishEncrypt512(keyCtx, in, out);
+            break;
+        case Threefish1024:
+            threefishEncrypt1024(keyCtx, in, out);
+            break;
+    }
+}
+
+void threefishDecryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in,
+                                uint8_t* out)
+{
+    u64b_t plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
+    u64b_t cipher[SKEIN_MAX_STATE_WORDS];
+    
+    Skein_Get64_LSB_First(cipher, in, keyCtx->stateSize / 64);  /* bytes to words */
+    threefishDecryptBlockWords(keyCtx, cipher, plain);
+    Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);   /* words to bytes */
+}
+
+void threefishDecryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in,
+                                uint64_t* out)
+{
+    switch (keyCtx->stateSize) {
+        case Threefish256:
+            threefishDecrypt256(keyCtx, in, out);
+            break;
+        case Threefish512:
+            threefishDecrypt512(keyCtx, in, out);
+            break;
+        case Threefish1024:
+            threefishDecrypt1024(keyCtx, in, out);
+            break;
+    }
+}
+
-- 
1.9.1
