From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 02/21] staging: crypto: skein: allow building statically
Date: Mon, 24 Mar 2014 01:48:59 +0000
Message-ID: <11504767f9086985f8d4ef6ae53ad9c357d54c71.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32920 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750993AbaCXBth (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:37 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These are the minimum changes required to get the code to build
statically in the kernel.  It's necessary to do this first so that we
can empirically determine that future cleanup patches aren't changing
the generated object code.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
Changes since RFC:

 - rebased onto staging-next caused conflicts in Kconfig and Makefile, fixed.


 drivers/staging/Kconfig                      |  2 +
 drivers/staging/Makefile                     |  1 +
 drivers/staging/skein/CMakeLists.txt         | 27 -------------
 drivers/staging/skein/Kconfig                | 32 ++++++++++++++++
 drivers/staging/skein/Makefile               | 13 +++++++
 drivers/staging/skein/include/brg_types.h    | 57 ----------------------------
 drivers/staging/skein/include/skein.h        | 10 -----
 drivers/staging/skein/include/skeinApi.h     |  2 +-
 drivers/staging/skein/include/skein_port.h   | 16 +-------
 drivers/staging/skein/include/threefishApi.h |  2 +-
 drivers/staging/skein/skein.c                |  2 +-
 drivers/staging/skein/skeinApi.c             |  4 +-
 drivers/staging/skein/skeinBlockNo3F.c       |  2 +-
 drivers/staging/skein/skein_block.c          |  2 +-
 drivers/staging/skein/threefish1024Block.c   |  3 +-
 drivers/staging/skein/threefish256Block.c    |  3 +-
 drivers/staging/skein/threefish512Block.c    |  3 +-
 drivers/staging/skein/threefishApi.c         |  3 +-
 18 files changed, 59 insertions(+), 125 deletions(-)
 delete mode 100755 drivers/staging/skein/CMakeLists.txt
 create mode 100644 drivers/staging/skein/Kconfig
 create mode 100644 drivers/staging/skein/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 47cf17543008..b78f669b7ed8 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -144,6 +144,8 @@ source "drivers/staging/gs_fpgaboot/Kconfig"
 
 source "drivers/staging/nokia_h4p/Kconfig"
 
+source "drivers/staging/skein/Kconfig"
+
 source "drivers/staging/unisys/Kconfig"
 
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index d12f6189db46..eec54a9f53e8 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -64,4 +64,5 @@ obj-$(CONFIG_DGAP)			+= dgap/
 obj-$(CONFIG_MTD_SPINAND_MT29F)	+= mt29f_spinand/
 obj-$(CONFIG_GS_FPGABOOT)	+= gs_fpgaboot/
 obj-$(CONFIG_BT_NOKIA_H4P)	+= nokia_h4p/
+obj-$(CONFIG_CRYPTO_SKEIN) += skein/
 obj-$(CONFIG_UNISYSSPAR)	+= unisys/
diff --git a/drivers/staging/skein/CMakeLists.txt b/drivers/staging/skein/CMakeLists.txt
deleted file mode 100755
index 604aaa394cb1..000000000000
--- a/drivers/staging/skein/CMakeLists.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-cmake_minimum_required (VERSION 2.6)
-
-include_directories (${CMAKE_CURRENT_SOURCE_DIR}/include)
-
-# set(skeinBlock_src skein_block.c)
-set(skeinBlock_src skeinBlockNo3F.c)
-
-set(skein_src 
-    ${skeinBlock_src}
-    skein.c
-    skeinApi.c
-    )
-
-set(threefish_src
-    threefishApi.c
-    threefish256Block.c
-    threefish512Block.c
-    threefish1024Block.c
-    )
-set(s3f_src ${skein_src} ${threefish_src})
-
-add_library(skein3fish SHARED ${s3f_src})
-set_target_properties(skein3fish PROPERTIES VERSION ${VERSION} SOVERSION ${SOVERSION})
-target_link_libraries(skein3fish ${LIBS})
-
-install(TARGETS skein3fish DESTINATION ${LIBDIRNAME})
-
diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
new file mode 100644
index 000000000000..8f5a72a90ced
--- /dev/null
+++ b/drivers/staging/skein/Kconfig
@@ -0,0 +1,32 @@
+config CRYPTO_SKEIN
+	bool "Skein digest algorithm"
+	depends on (X86 || UML_X86) && 64BIT
+	select CRYPTO_THREEFISH
+	select CRYPTO_HASH
+	help
+	  Skein secure hash algorithm is one of 5 finalists from the NIST SHA3
+	  competition.
+
+	  Skein is optimized for modern, 64bit processors and is highly
+	  customizable.  See:
+
+	  http://www.skein-hash.info/sites/default/files/skein1.3.pdf
+
+	  for more information.  This module depends on the threefish block
+	  cipher module.
+
+config CRYPTO_THREEFISH
+	bool "Threefish tweakable block cipher"
+	depends on (X86 || UML_X86) && 64BIT
+	select CRYPTO_ALGAPI
+	help
+	  Threefish cipher algorithm is the tweakable block cipher underneath
+	  the Skein family of secure hash algorithms.  Skein is one of 5
+	  finalists from the NIST SHA3 competition.
+
+	  Skein is optimized for modern, 64bit processors and is highly
+	  customizable.  See:
+
+	  http://www.skein-hash.info/sites/default/files/skein1.3.pdf
+
+	  for more information.
diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
new file mode 100644
index 000000000000..2bb386e1e58c
--- /dev/null
+++ b/drivers/staging/skein/Makefile
@@ -0,0 +1,13 @@
+#
+# Makefile for the skein secure hash algorithm
+#
+subdir-ccflags-y := -I$(src)/include/
+
+obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
+				skeinApi.o \
+				skein_block.o
+
+obj-$(CONFIG_CRYPTO_THREEFISH) += threefish1024Block.o \
+				  threefish256Block.o \
+				  threefish512Block.o \
+				  threefishApi.o
diff --git a/drivers/staging/skein/include/brg_types.h b/drivers/staging/skein/include/brg_types.h
index 6db737d71b9e..3d9fe0df5238 100644
--- a/drivers/staging/skein/include/brg_types.h
+++ b/drivers/staging/skein/include/brg_types.h
@@ -46,83 +46,26 @@
 extern "C" {
 #endif
 
-#include <limits.h>
-
 #ifndef BRG_UI8
 #  define BRG_UI8
-#  if UCHAR_MAX == 255u
      typedef unsigned char uint_8t;
-#  else
-#    error Please define uint_8t as an 8-bit unsigned integer type in brg_types.h
-#  endif
 #endif
 
 #ifndef BRG_UI16
 #  define BRG_UI16
-#  if USHRT_MAX == 65535u
      typedef unsigned short uint_16t;
-#  else
-#    error Please define uint_16t as a 16-bit unsigned short type in brg_types.h
-#  endif
 #endif
 
 #ifndef BRG_UI32
 #  define BRG_UI32
-#  if UINT_MAX == 4294967295u
 #    define li_32(h) 0x##h##u
      typedef unsigned int uint_32t;
-#  elif ULONG_MAX == 4294967295u
-#    define li_32(h) 0x##h##ul
-     typedef unsigned long uint_32t;
-#  elif defined( _CRAY )
-#    error This code needs 32-bit data types, which Cray machines do not provide
-#  else
-#    error Please define uint_32t as a 32-bit unsigned integer type in brg_types.h
-#  endif
 #endif
 
 #ifndef BRG_UI64
-#  if defined( __BORLANDC__ ) && !defined( __MSDOS__ )
-#    define BRG_UI64
-#    define li_64(h) 0x##h##ui64
-     typedef unsigned __int64 uint_64t;
-#  elif defined( _MSC_VER ) && ( _MSC_VER < 1300 )    /* 1300 == VC++ 7.0 */
-#    define BRG_UI64
-#    define li_64(h) 0x##h##ui64
-     typedef unsigned __int64 uint_64t;
-#  elif defined( __sun ) && defined(ULONG_MAX) && ULONG_MAX == 0xfffffffful
-#    define BRG_UI64
-#    define li_64(h) 0x##h##ull
-     typedef unsigned long long uint_64t;
-#  elif defined( UINT_MAX ) && UINT_MAX > 4294967295u
-#    if UINT_MAX == 18446744073709551615u
-#      define BRG_UI64
-#      define li_64(h) 0x##h##u
-       typedef unsigned int uint_64t;
-#    endif
-#  elif defined( ULONG_MAX ) && ULONG_MAX > 4294967295u
-#    if ULONG_MAX == 18446744073709551615ul
-#      define BRG_UI64
-#      define li_64(h) 0x##h##ul
-       typedef unsigned long uint_64t;
-#    endif
-#  elif defined( ULLONG_MAX ) && ULLONG_MAX > 4294967295u
-#    if ULLONG_MAX == 18446744073709551615ull
-#      define BRG_UI64
-#      define li_64(h) 0x##h##ull
-       typedef unsigned long long uint_64t;
-#    endif
-#  elif defined( ULONG_LONG_MAX ) && ULONG_LONG_MAX > 4294967295u
-#    if ULONG_LONG_MAX == 18446744073709551615ull
 #      define BRG_UI64
 #      define li_64(h) 0x##h##ull
        typedef unsigned long long uint_64t;
-#    endif
-#  elif defined(__GNUC__)  /* DLW: avoid mingw problem with -ansi */
-#      define BRG_UI64
-#      define li_64(h) 0x##h##ull
-       typedef unsigned long long uint_64t;
-#  endif
 #endif
 
 #if defined( NEED_UINT_64T ) && !defined( BRG_UI64 )
diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index cb613fa09d9e..315cdcd14413 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -261,18 +261,8 @@ int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
 #define Skein_Show_Key(bits,ctx,key,keyBytes)
 #endif
 
-#ifndef SKEIN_ERR_CHECK        /* run-time checks (e.g., bad params, uninitialized context)? */
 #define Skein_Assert(x,retCode)/* default: ignore all Asserts, for performance */
 #define Skein_assert(x)
-#elif   defined(SKEIN_ASSERT)
-#include <assert.h>     
-#define Skein_Assert(x,retCode) assert(x) 
-#define Skein_assert(x)         assert(x) 
-#else
-#include <assert.h>     
-#define Skein_Assert(x,retCode) { if (!(x)) return retCode; } /*  caller  error */
-#define Skein_assert(x)         assert(x)                     /* internal error */
-#endif
 
 /*****************************************************************
 ** Skein block function constants (shared across Ref and Opt code)
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index 19c3225460fc..734d27b79f01 100755
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -78,8 +78,8 @@ OTHER DEALINGS IN THE SOFTWARE.
  * 
  */
 
+#include <linux/types.h>
 #include <skein.h>
-#include <stdint.h>
 
 #ifdef __cplusplus
 extern "C"
diff --git a/drivers/staging/skein/include/skein_port.h b/drivers/staging/skein/include/skein_port.h
index 18d892553c8d..1c68070358ce 100644
--- a/drivers/staging/skein/include/skein_port.h
+++ b/drivers/staging/skein/include/skein_port.h
@@ -44,24 +44,10 @@ typedef uint_64t        u64b_t;             /* 64-bit unsigned integer */
  * platform-specific code instead (e.g., for big-endian CPUs).
  *
  */
-#ifndef SKEIN_NEED_SWAP /* compile-time "override" for endianness? */
-
-#include <brg_endian.h>              /* get endianness selection */
-#if   PLATFORM_BYTE_ORDER == IS_BIG_ENDIAN
-    /* here for big-endian CPUs */
-#define SKEIN_NEED_SWAP   (1)
-#elif PLATFORM_BYTE_ORDER == IS_LITTLE_ENDIAN
-    /* here for x86 and x86-64 CPUs (and other detected little-endian CPUs) */
 #define SKEIN_NEED_SWAP   (0)
-#if   PLATFORM_MUST_ALIGN == 0              /* ok to use "fast" versions? */
+/* below two prototype assume we are handed aligned data */
 #define Skein_Put64_LSB_First(dst08,src64,bCnt) memcpy(dst08,src64,bCnt)
 #define Skein_Get64_LSB_First(dst64,src08,wCnt) memcpy(dst64,src08,8*(wCnt))
-#endif
-#else
-#error "Skein needs endianness setting!"
-#endif
-
-#endif /* ifndef SKEIN_NEED_SWAP */
 
 /*
  ******************************************************************
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 85afd72fe987..dae270cf71d3 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -28,8 +28,8 @@
 @endcode
  */
 
+#include <linux/types.h>
 #include <skein.h>
-#include <stdint.h>
 
 #define KeyScheduleConst 0x1BD11BDAA9FC1A22L
 
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index f0b176ac1dc7..3fae6fdf7c75 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -10,7 +10,7 @@
 
 #define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
 
-#include <string.h>       /* get the memcpy/memset functions */
+#include <linux/string.h>       /* get the memcpy/memset functions */
 #include <skein.h> /* get the Skein API definitions   */
 #include <skein_iv.h>    /* get precomputed IVs */
 
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index 7b963758d32c..579b92efbf65 100755
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -24,10 +24,8 @@ OTHER DEALINGS IN THE SOFTWARE.
 
 */
 
-#define SKEIN_ERR_CHECK 1
+#include <linux/string.h>
 #include <skeinApi.h>
-#include <string.h>
-#include <stdio.h>
 
 int skeinCtxPrepare(SkeinCtx_t* ctx, SkeinSize_t size)
 {
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 4ad6c50360e7..6a19ceb17d0f 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -1,5 +1,5 @@
 
-#include <string.h>
+#include <linux/string.h>
 #include <skein.h>
 #include <threefishApi.h>
 
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 86724a2443b5..b5be41af6d17 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -14,7 +14,7 @@
 **
 ************************************************************************/
 
-#include <string.h>
+#include <linux/string.h>
 #include <skein.h>
 
 #ifndef SKEIN_USE_ASM
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
index 8b43586f46bc..58a8c26a1f6f 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish1024Block.c
@@ -1,6 +1,5 @@
+#include <linux/string.h>
 #include <threefishApi.h>
-#include <stdint.h>
-#include <string.h>
 
 
 void threefishEncrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
index db2b81978c91..a7e06f905186 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish256Block.c
@@ -1,6 +1,5 @@
+#include <linux/string.h>
 #include <threefishApi.h>
-#include <stdint.h>
-#include <string.h>
 
 
 void threefishEncrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
index 4fe708fea066..3cbfcd9af5c9 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish512Block.c
@@ -1,6 +1,5 @@
+#include <linux/string.h>
 #include <threefishApi.h>
-#include <stdint.h>
-#include <string.h>
 
 
 void threefishEncrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index 5afa0338aef4..968d3d21fe61 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -1,8 +1,7 @@
 
 
+#include <linux/string.h>
 #include <threefishApi.h>
-#include <stdlib.h>
-#include <string.h>
 
 void threefishSetKey(ThreefishKey_t* keyCtx, ThreefishSize_t stateSize,
                      uint64_t* keyData, uint64_t* tweak)
-- 
1.9.1
