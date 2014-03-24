From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 04/21] staging: crypto: skein: remove skein_port.h
Date: Mon, 24 Mar 2014 01:49:01 +0000
Message-ID: <4c8fb9d69eca716cce3f957dd8462d4e888210e7.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32941 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751405AbaCXBti (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:38 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein.h      |  14 +++-
 drivers/staging/skein/include/skein_port.h | 108 -----------------------------
 drivers/staging/skein/skein.c              |  21 ------
 3 files changed, 13 insertions(+), 130 deletions(-)
 delete mode 100644 drivers/staging/skein/include/skein_port.h

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 315cdcd14413..211aca1b1036 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -33,7 +33,19 @@ extern "C"
 #endif
 
 #include <stddef.h>                          /* get size_t definition */
-#include <skein_port.h>               /* get platform-specific definitions */
+
+typedef unsigned int    uint_t;             /* native unsigned integer */
+typedef uint8_t         u08b_t;             /*  8-bit unsigned integer */
+typedef uint64_t        u64b_t;             /* 64-bit unsigned integer */
+
+#ifndef RotL_64
+#define RotL_64(x,N)    (((x) << (N)) | ((x) >> (64-(N))))
+#endif
+
+/* below two prototype assume we are handed aligned data */
+#define Skein_Put64_LSB_First(dst08,src64,bCnt) memcpy(dst08,src64,bCnt)
+#define Skein_Get64_LSB_First(dst64,src08,wCnt) memcpy(dst64,src08,8*(wCnt))
+#define Skein_Swap64(w64)  (w64)
 
 enum
     {
diff --git a/drivers/staging/skein/include/skein_port.h b/drivers/staging/skein/include/skein_port.h
deleted file mode 100644
index e78c976dccc5..000000000000
--- a/drivers/staging/skein/include/skein_port.h
+++ /dev/null
@@ -1,108 +0,0 @@
-#ifndef _SKEIN_PORT_H_
-#define _SKEIN_PORT_H_
-/*******************************************************************
-**
-** Platform-specific definitions for Skein hash function.
-**
-** Source code author: Doug Whiting, 2008.
-**
-** This algorithm and source code is released to the public domain.
-**
-** Many thanks to Brian Gladman for his portable header files.
-**
-** To port Skein to an "unsupported" platform, change the definitions
-** in this file appropriately.
-** 
-********************************************************************/
-
-typedef unsigned int    uint_t;             /* native unsigned integer */
-typedef uint8_t         u08b_t;             /*  8-bit unsigned integer */
-typedef uint64_t        u64b_t;             /* 64-bit unsigned integer */
-
-#ifndef RotL_64
-#define RotL_64(x,N)    (((x) << (N)) | ((x) >> (64-(N))))
-#endif
-
-/*
- * Skein is "natively" little-endian (unlike SHA-xxx), for optimal
- * performance on x86 CPUs.  The Skein code requires the following
- * definitions for dealing with endianness:
- *
- *    SKEIN_NEED_SWAP:  0 for little-endian, 1 for big-endian
- *    Skein_Put64_LSB_First
- *    Skein_Get64_LSB_First
- *    Skein_Swap64
- *
- * If SKEIN_NEED_SWAP is defined at compile time, it is used here
- * along with the portable versions of Put64/Get64/Swap64, which 
- * are slow in general.
- *
- * Otherwise, an "auto-detect" of endianness is attempted below.
- * If the default handling doesn't work well, the user may insert
- * platform-specific code instead (e.g., for big-endian CPUs).
- *
- */
-#define SKEIN_NEED_SWAP   (0)
-/* below two prototype assume we are handed aligned data */
-#define Skein_Put64_LSB_First(dst08,src64,bCnt) memcpy(dst08,src64,bCnt)
-#define Skein_Get64_LSB_First(dst64,src08,wCnt) memcpy(dst64,src08,8*(wCnt))
-
-/*
- ******************************************************************
- *      Provide any definitions still needed.
- ******************************************************************
- */
-#ifndef Skein_Swap64  /* swap for big-endian, nop for little-endian */
-#if     SKEIN_NEED_SWAP
-#define Skein_Swap64(w64)                       \
-  ( (( ((u64b_t)(w64))       & 0xFF) << 56) |   \
-    (((((u64b_t)(w64)) >> 8) & 0xFF) << 48) |   \
-    (((((u64b_t)(w64)) >>16) & 0xFF) << 40) |   \
-    (((((u64b_t)(w64)) >>24) & 0xFF) << 32) |   \
-    (((((u64b_t)(w64)) >>32) & 0xFF) << 24) |   \
-    (((((u64b_t)(w64)) >>40) & 0xFF) << 16) |   \
-    (((((u64b_t)(w64)) >>48) & 0xFF) <<  8) |   \
-    (((((u64b_t)(w64)) >>56) & 0xFF)      ) )
-#else
-#define Skein_Swap64(w64)  (w64)
-#endif
-#endif  /* ifndef Skein_Swap64 */
-
-
-#ifndef Skein_Put64_LSB_First
-void    Skein_Put64_LSB_First(u08b_t *dst,const u64b_t *src,size_t bCnt)
-#ifdef  SKEIN_PORT_CODE /* instantiate the function code here? */
-    { /* this version is fully portable (big-endian or little-endian), but slow */
-    size_t n;
-
-    for (n=0;n<bCnt;n++)
-        dst[n] = (u08b_t) (src[n>>3] >> (8*(n&7)));
-    }
-#else
-    ;    /* output only the function prototype */
-#endif
-#endif   /* ifndef Skein_Put64_LSB_First */
-
-
-#ifndef Skein_Get64_LSB_First
-void    Skein_Get64_LSB_First(u64b_t *dst,const u08b_t *src,size_t wCnt)
-#ifdef  SKEIN_PORT_CODE /* instantiate the function code here? */
-    { /* this version is fully portable (big-endian or little-endian), but slow */
-    size_t n;
-
-    for (n=0;n<8*wCnt;n+=8)
-        dst[n/8] = (((u64b_t) src[n  ])      ) +
-                   (((u64b_t) src[n+1]) <<  8) +
-                   (((u64b_t) src[n+2]) << 16) +
-                   (((u64b_t) src[n+3]) << 24) +
-                   (((u64b_t) src[n+4]) << 32) +
-                   (((u64b_t) src[n+5]) << 40) +
-                   (((u64b_t) src[n+6]) << 48) +
-                   (((u64b_t) src[n+7]) << 56) ;
-    }
-#else
-    ;    /* output only the function prototype */
-#endif
-#endif   /* ifndef Skein_Get64_LSB_First */
-
-#endif   /* ifndef _SKEIN_PORT_H_ */
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 3fae6fdf7c75..44468b6701ab 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -102,13 +102,6 @@ int Skein_256_InitExt(Skein_256_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, c
         Skein_256_Update(ctx,key,keyBytes);     /* hash the key */
         Skein_256_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
         memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
-#if SKEIN_NEED_SWAP
-        {
-            uint_t i;
-            for (i=0;i<SKEIN_256_STATE_WORDS;i++)   /* convert key bytes to context words */
-                ctx->X[i] = Skein_Swap64(ctx->X[i]);
-        }
-#endif
     }
     /* build/process the config block, type == CONFIG (could be precomputed for each key) */
     ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
@@ -297,13 +290,6 @@ int Skein_512_InitExt(Skein_512_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, c
         Skein_512_Update(ctx,key,keyBytes);     /* hash the key */
         Skein_512_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
         memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
-#if SKEIN_NEED_SWAP
-        {
-            uint_t i;
-            for (i=0;i<SKEIN_512_STATE_WORDS;i++)   /* convert key bytes to context words */
-                ctx->X[i] = Skein_Swap64(ctx->X[i]);
-        }
-#endif
     }
     /* build/process the config block, type == CONFIG (could be precomputed for each key) */
     ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
@@ -489,13 +475,6 @@ int Skein1024_InitExt(Skein1024_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, c
         Skein1024_Update(ctx,key,keyBytes);     /* hash the key */
         Skein1024_Final_Pad(ctx,cfg.b);         /* put result into cfg.b[] */
         memcpy(ctx->X,cfg.b,sizeof(cfg.b));     /* copy over into ctx->X[] */
-#if SKEIN_NEED_SWAP
-        {
-            uint_t i;
-            for (i=0;i<SKEIN1024_STATE_WORDS;i++)   /* convert key bytes to context words */
-                ctx->X[i] = Skein_Swap64(ctx->X[i]);
-        }
-#endif
     }
     /* build/process the config block, type == CONFIG (could be precomputed for each key) */
     ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
-- 
1.9.1
