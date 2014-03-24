From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 06/21] staging: crypto: skein: remove unneeded typedefs
Date: Mon, 24 Mar 2014 01:49:03 +0000
Message-ID: <522339d154b7d22f85a3301d9bbc49b1696e43cc.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30371 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaCXBtm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:42 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein.h        | 73 ++++++++++-----------
 drivers/staging/skein/include/skeinApi.h     |  4 +-
 drivers/staging/skein/include/skein_iv.h     | 26 ++++----
 drivers/staging/skein/include/threefishApi.h |  6 +-
 drivers/staging/skein/skein.c                | 96 ++++++++++++++--------------
 drivers/staging/skein/skeinApi.c             | 24 +++----
 drivers/staging/skein/skeinBlockNo3F.c       | 30 ++++-----
 drivers/staging/skein/skein_block.c          | 54 ++++++++--------
 drivers/staging/skein/threefishApi.c         |  8 +--
 9 files changed, 159 insertions(+), 162 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index b1e55b08d150..12c5c8d612b0 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -27,9 +27,6 @@
 **                                1: return SKEIN_FAIL to flag errors
 **
 ***************************************************************************/
-typedef unsigned int    uint_t;             /* native unsigned integer */
-typedef uint8_t         u08b_t;             /*  8-bit unsigned integer */
-typedef uint64_t        u64b_t;             /* 64-bit unsigned integer */
 
 #ifndef RotL_64
 #define RotL_64(x,N)    (((x) << (N)) | ((x) >> (64-(N))))
@@ -70,28 +67,28 @@ typedef struct
     {
     size_t  hashBitLen;                      /* size of hash result, in bits */
     size_t  bCnt;                            /* current byte count in buffer b[] */
-    u64b_t  T[SKEIN_MODIFIER_WORDS];         /* tweak words: T[0]=byte cnt, T[1]=flags */
+    u64  T[SKEIN_MODIFIER_WORDS];         /* tweak words: T[0]=byte cnt, T[1]=flags */
     } Skein_Ctxt_Hdr_t;
 
 typedef struct                               /*  256-bit Skein hash context structure */
     {
     Skein_Ctxt_Hdr_t h;                      /* common header context variables */
-    u64b_t  X[SKEIN_256_STATE_WORDS];        /* chaining variables */
-    u08b_t  b[SKEIN_256_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+    u64  X[SKEIN_256_STATE_WORDS];        /* chaining variables */
+    u8  b[SKEIN_256_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
     } Skein_256_Ctxt_t;
 
 typedef struct                               /*  512-bit Skein hash context structure */
     {
     Skein_Ctxt_Hdr_t h;                      /* common header context variables */
-    u64b_t  X[SKEIN_512_STATE_WORDS];        /* chaining variables */
-    u08b_t  b[SKEIN_512_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+    u64  X[SKEIN_512_STATE_WORDS];        /* chaining variables */
+    u8  b[SKEIN_512_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
     } Skein_512_Ctxt_t;
 
 typedef struct                               /* 1024-bit Skein hash context structure */
     {
     Skein_Ctxt_Hdr_t h;                      /* common header context variables */
-    u64b_t  X[SKEIN1024_STATE_WORDS];        /* chaining variables */
-    u08b_t  b[SKEIN1024_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
+    u64  X[SKEIN1024_STATE_WORDS];        /* chaining variables */
+    u8  b[SKEIN1024_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
     } Skein1024_Ctxt_t;
 
 /*   Skein APIs for (incremental) "straight hashing" */
@@ -99,13 +96,13 @@ int  Skein_256_Init  (Skein_256_Ctxt_t *ctx, size_t hashBitLen);
 int  Skein_512_Init  (Skein_512_Ctxt_t *ctx, size_t hashBitLen);
 int  Skein1024_Init  (Skein1024_Ctxt_t *ctx, size_t hashBitLen);
 
-int  Skein_256_Update(Skein_256_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt);
-int  Skein_512_Update(Skein_512_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt);
-int  Skein1024_Update(Skein1024_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt);
+int  Skein_256_Update(Skein_256_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt);
+int  Skein_512_Update(Skein_512_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt);
+int  Skein1024_Update(Skein1024_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt);
 
-int  Skein_256_Final (Skein_256_Ctxt_t *ctx, u08b_t * hashVal);
-int  Skein_512_Final (Skein_512_Ctxt_t *ctx, u08b_t * hashVal);
-int  Skein1024_Final (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein_256_Final (Skein_256_Ctxt_t *ctx, u8 * hashVal);
+int  Skein_512_Final (Skein_512_Ctxt_t *ctx, u8 * hashVal);
+int  Skein1024_Final (Skein1024_Ctxt_t *ctx, u8 * hashVal);
 
 /*
 **   Skein APIs for "extended" initialization: MAC keys, tree hashing.
@@ -121,26 +118,26 @@ int  Skein1024_Final (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
 **              to precompute the MAC IV, then a copy of the context saved and
 **              reused for each new MAC computation.
 **/
-int  Skein_256_InitExt(Skein_256_Ctxt_t *ctx, size_t hashBitLen, u64b_t treeInfo, const u08b_t *key, size_t keyBytes);
-int  Skein_512_InitExt(Skein_512_Ctxt_t *ctx, size_t hashBitLen, u64b_t treeInfo, const u08b_t *key, size_t keyBytes);
-int  Skein1024_InitExt(Skein1024_Ctxt_t *ctx, size_t hashBitLen, u64b_t treeInfo, const u08b_t *key, size_t keyBytes);
+int  Skein_256_InitExt(Skein_256_Ctxt_t *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein_512_InitExt(Skein_512_Ctxt_t *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein1024_InitExt(Skein1024_Ctxt_t *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
 
 /*
 **   Skein APIs for MAC and tree hash:
 **      Final_Pad:  pad, do final block, but no OUTPUT type
 **      Output:     do just the output stage
 */
-int  Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u08b_t * hashVal);
-int  Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u08b_t * hashVal);
-int  Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u8 * hashVal);
+int  Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u8 * hashVal);
+int  Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u8 * hashVal);
 
 #ifndef SKEIN_TREE_HASH
 #define SKEIN_TREE_HASH (1)
 #endif
 #if  SKEIN_TREE_HASH
-int  Skein_256_Output   (Skein_256_Ctxt_t *ctx, u08b_t * hashVal);
-int  Skein_512_Output   (Skein_512_Ctxt_t *ctx, u08b_t * hashVal);
-int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
+int  Skein_256_Output   (Skein_256_Ctxt_t *ctx, u8 * hashVal);
+int  Skein_512_Output   (Skein_512_Ctxt_t *ctx, u8 * hashVal);
+int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u8 * hashVal);
 #endif
 
 /*****************************************************************
@@ -161,13 +158,13 @@ int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
 #define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127)       /* bit  127     : final block flag         */
                                 
 /* tweak word T[1]: flag bit definition(s) */
-#define SKEIN_T1_FLAG_FIRST     (((u64b_t)  1 ) << SKEIN_T1_POS_FIRST)
-#define SKEIN_T1_FLAG_FINAL     (((u64b_t)  1 ) << SKEIN_T1_POS_FINAL)
-#define SKEIN_T1_FLAG_BIT_PAD   (((u64b_t)  1 ) << SKEIN_T1_POS_BIT_PAD)
+#define SKEIN_T1_FLAG_FIRST     (((u64)  1 ) << SKEIN_T1_POS_FIRST)
+#define SKEIN_T1_FLAG_FINAL     (((u64)  1 ) << SKEIN_T1_POS_FINAL)
+#define SKEIN_T1_FLAG_BIT_PAD   (((u64)  1 ) << SKEIN_T1_POS_BIT_PAD)
                                 
 /* tweak word T[1]: tree level bit field mask */
-#define SKEIN_T1_TREE_LVL_MASK  (((u64b_t)0x7F) << SKEIN_T1_POS_TREE_LVL)
-#define SKEIN_T1_TREE_LEVEL(n)  (((u64b_t) (n)) << SKEIN_T1_POS_TREE_LVL)
+#define SKEIN_T1_TREE_LVL_MASK  (((u64)0x7F) << SKEIN_T1_POS_TREE_LVL)
+#define SKEIN_T1_TREE_LEVEL(n)  (((u64) (n)) << SKEIN_T1_POS_TREE_LVL)
 
 /* tweak word T[1]: block type field */
 #define SKEIN_BLK_TYPE_KEY      ( 0)                    /* key, for MAC and KDF */
@@ -180,7 +177,7 @@ int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
 #define SKEIN_BLK_TYPE_OUT      (63)                    /* output stage */
 #define SKEIN_BLK_TYPE_MASK     (63)                    /* bit field mask */
 
-#define SKEIN_T1_BLK_TYPE(T)   (((u64b_t) (SKEIN_BLK_TYPE_##T)) << SKEIN_T1_POS_BLK_TYPE)
+#define SKEIN_T1_BLK_TYPE(T)   (((u64) (SKEIN_BLK_TYPE_##T)) << SKEIN_T1_POS_BLK_TYPE)
 #define SKEIN_T1_BLK_TYPE_KEY   SKEIN_T1_BLK_TYPE(KEY)  /* key, for MAC and KDF */
 #define SKEIN_T1_BLK_TYPE_CFG   SKEIN_T1_BLK_TYPE(CFG)  /* configuration block */
 #define SKEIN_T1_BLK_TYPE_PERS  SKEIN_T1_BLK_TYPE(PERS) /* personalization string */
@@ -200,7 +197,7 @@ int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
 #define SKEIN_ID_STRING_LE      (0x33414853)            /* "SHA3" (little-endian)*/
 #endif
 
-#define SKEIN_MK_64(hi32,lo32)  ((lo32) + (((u64b_t) (hi32)) << 32))
+#define SKEIN_MK_64(hi32,lo32)  ((lo32) + (((u64) (hi32)) << 32))
 #define SKEIN_SCHEMA_VER        SKEIN_MK_64(SKEIN_VERSION,SKEIN_ID_STRING_LE)
 #define SKEIN_KS_PARITY         SKEIN_MK_64(0x1BD11BDA,0xA9FC1A22)
 
@@ -211,14 +208,14 @@ int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u08b_t * hashVal);
 #define SKEIN_CFG_TREE_NODE_SIZE_POS  ( 8)
 #define SKEIN_CFG_TREE_MAX_LEVEL_POS  (16)
 
-#define SKEIN_CFG_TREE_LEAF_SIZE_MSK  (((u64b_t) 0xFF) << SKEIN_CFG_TREE_LEAF_SIZE_POS)
-#define SKEIN_CFG_TREE_NODE_SIZE_MSK  (((u64b_t) 0xFF) << SKEIN_CFG_TREE_NODE_SIZE_POS)
-#define SKEIN_CFG_TREE_MAX_LEVEL_MSK  (((u64b_t) 0xFF) << SKEIN_CFG_TREE_MAX_LEVEL_POS)
+#define SKEIN_CFG_TREE_LEAF_SIZE_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_LEAF_SIZE_POS)
+#define SKEIN_CFG_TREE_NODE_SIZE_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_NODE_SIZE_POS)
+#define SKEIN_CFG_TREE_MAX_LEVEL_MSK  (((u64) 0xFF) << SKEIN_CFG_TREE_MAX_LEVEL_POS)
 
 #define SKEIN_CFG_TREE_INFO(leaf,node,maxLvl)                   \
-    ( (((u64b_t)(leaf  )) << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
-      (((u64b_t)(node  )) << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
-      (((u64b_t)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS) )
+    ( (((u64)(leaf  )) << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
+      (((u64)(node  )) << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
+      (((u64)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS) )
 
 #define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0,0,0) /* use as treeInfo in InitExt() call for sequential processing */
 
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index f55c67e81f2b..fb4a7c8e7f7a 100755
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -99,8 +99,8 @@ OTHER DEALINGS IN THE SOFTWARE.
      * structures as well.
      */
     typedef struct SkeinCtx {
-        u64b_t skeinSize;
-        u64b_t  XSave[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
+        u64 skeinSize;
+        u64  XSave[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
         union {
             Skein_Ctxt_Hdr_t h;
             Skein_256_Ctxt_t s256;
diff --git a/drivers/staging/skein/include/skein_iv.h b/drivers/staging/skein/include/skein_iv.h
index 555ea619500b..94ac2f7cde76 100644
--- a/drivers/staging/skein/include/skein_iv.h
+++ b/drivers/staging/skein/include/skein_iv.h
@@ -20,7 +20,7 @@
 #define MK_64 SKEIN_MK_64
 
 /* blkSize =  256 bits. hashSize =  128 bits */
-const u64b_t SKEIN_256_IV_128[] =
+const u64 SKEIN_256_IV_128[] =
     {
     MK_64(0xE1111906,0x964D7260),
     MK_64(0x883DAAA7,0x7C8D811C),
@@ -29,7 +29,7 @@ const u64b_t SKEIN_256_IV_128[] =
     };
 
 /* blkSize =  256 bits. hashSize =  160 bits */
-const u64b_t SKEIN_256_IV_160[] =
+const u64 SKEIN_256_IV_160[] =
     {
     MK_64(0x14202314,0x72825E98),
     MK_64(0x2AC4E9A2,0x5A77E590),
@@ -38,7 +38,7 @@ const u64b_t SKEIN_256_IV_160[] =
     };
 
 /* blkSize =  256 bits. hashSize =  224 bits */
-const u64b_t SKEIN_256_IV_224[] =
+const u64 SKEIN_256_IV_224[] =
     {
     MK_64(0xC6098A8C,0x9AE5EA0B),
     MK_64(0x876D5686,0x08C5191C),
@@ -47,7 +47,7 @@ const u64b_t SKEIN_256_IV_224[] =
     };
 
 /* blkSize =  256 bits. hashSize =  256 bits */
-const u64b_t SKEIN_256_IV_256[] =
+const u64 SKEIN_256_IV_256[] =
     {
     MK_64(0xFC9DA860,0xD048B449),
     MK_64(0x2FCA6647,0x9FA7D833),
@@ -56,7 +56,7 @@ const u64b_t SKEIN_256_IV_256[] =
     };
 
 /* blkSize =  512 bits. hashSize =  128 bits */
-const u64b_t SKEIN_512_IV_128[] =
+const u64 SKEIN_512_IV_128[] =
     {
     MK_64(0xA8BC7BF3,0x6FBF9F52),
     MK_64(0x1E9872CE,0xBD1AF0AA),
@@ -69,7 +69,7 @@ const u64b_t SKEIN_512_IV_128[] =
     };
 
 /* blkSize =  512 bits. hashSize =  160 bits */
-const u64b_t SKEIN_512_IV_160[] =
+const u64 SKEIN_512_IV_160[] =
     {
     MK_64(0x28B81A2A,0xE013BD91),
     MK_64(0xC2F11668,0xB5BDF78F),
@@ -82,7 +82,7 @@ const u64b_t SKEIN_512_IV_160[] =
     };
 
 /* blkSize =  512 bits. hashSize =  224 bits */
-const u64b_t SKEIN_512_IV_224[] =
+const u64 SKEIN_512_IV_224[] =
     {
     MK_64(0xCCD06162,0x48677224),
     MK_64(0xCBA65CF3,0xA92339EF),
@@ -95,7 +95,7 @@ const u64b_t SKEIN_512_IV_224[] =
     };
 
 /* blkSize =  512 bits. hashSize =  256 bits */
-const u64b_t SKEIN_512_IV_256[] =
+const u64 SKEIN_512_IV_256[] =
     {
     MK_64(0xCCD044A1,0x2FDB3E13),
     MK_64(0xE8359030,0x1A79A9EB),
@@ -108,7 +108,7 @@ const u64b_t SKEIN_512_IV_256[] =
     };
 
 /* blkSize =  512 bits. hashSize =  384 bits */
-const u64b_t SKEIN_512_IV_384[] =
+const u64 SKEIN_512_IV_384[] =
     {
     MK_64(0xA3F6C6BF,0x3A75EF5F),
     MK_64(0xB0FEF9CC,0xFD84FAA4),
@@ -121,7 +121,7 @@ const u64b_t SKEIN_512_IV_384[] =
     };
 
 /* blkSize =  512 bits. hashSize =  512 bits */
-const u64b_t SKEIN_512_IV_512[] =
+const u64 SKEIN_512_IV_512[] =
     {
     MK_64(0x4903ADFF,0x749C51CE),
     MK_64(0x0D95DE39,0x9746DF03),
@@ -134,7 +134,7 @@ const u64b_t SKEIN_512_IV_512[] =
     };
 
 /* blkSize = 1024 bits. hashSize =  384 bits */
-const u64b_t SKEIN1024_IV_384[] =
+const u64 SKEIN1024_IV_384[] =
     {
     MK_64(0x5102B6B8,0xC1894A35),
     MK_64(0xFEEBC9E3,0xFE8AF11A),
@@ -155,7 +155,7 @@ const u64b_t SKEIN1024_IV_384[] =
     };
 
 /* blkSize = 1024 bits. hashSize =  512 bits */
-const u64b_t SKEIN1024_IV_512[] =
+const u64 SKEIN1024_IV_512[] =
     {
     MK_64(0xCAEC0E5D,0x7C1B1B18),
     MK_64(0xA01B0E04,0x5F03E802),
@@ -176,7 +176,7 @@ const u64b_t SKEIN1024_IV_512[] =
     };
 
 /* blkSize = 1024 bits. hashSize = 1024 bits */
-const u64b_t SKEIN1024_IV_1024[] =
+const u64 SKEIN1024_IV_1024[] =
     {
     MK_64(0xD593DA07,0x41E72355),
     MK_64(0x15B5E511,0xAC73E00C),
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index aaecfe822142..0123a575b606 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -51,9 +51,9 @@
      * structures as well.
      */
     typedef struct ThreefishKey {
-        u64b_t stateSize;
-        u64b_t key[SKEIN_MAX_STATE_WORDS+1];   /* max number of key words*/
-        u64b_t tweak[3];
+        u64 stateSize;
+        u64 key[SKEIN_MAX_STATE_WORDS+1];   /* max number of key words*/
+        u64 tweak[3];
     } ThreefishKey_t;
 
     /**
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 44468b6701ab..b225642efa4a 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -16,9 +16,9 @@
 
 /*****************************************************************/
 /* External function to process blkCnt (nonzero) full block(s) of data. */
-void    Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd);
-void    Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd);
-void    Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
 
 /*****************************************************************/
 /*     256-bit Skein                                             */
@@ -30,8 +30,8 @@ int Skein_256_Init(Skein_256_Ctxt_t *ctx, size_t hashBitLen)
 {
     union
     {
-        u08b_t  b[SKEIN_256_STATE_BYTES];
-        u64b_t  w[SKEIN_256_STATE_WORDS];
+        u8  b[SKEIN_256_STATE_BYTES];
+        u64  w[SKEIN_256_STATE_WORDS];
     } cfg;                              /* config block */
 
     Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
@@ -76,12 +76,12 @@ int Skein_256_Init(Skein_256_Ctxt_t *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein_256_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_256_InitExt(Skein_256_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, const u08b_t *key, size_t keyBytes)
+int Skein_256_InitExt(Skein_256_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
-        u08b_t  b[SKEIN_256_STATE_BYTES];
-        u64b_t  w[SKEIN_256_STATE_WORDS];
+        u8  b[SKEIN_256_STATE_BYTES];
+        u64  w[SKEIN_256_STATE_WORDS];
     } cfg;                              /* config block */
 
     Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
@@ -126,7 +126,7 @@ int Skein_256_InitExt(Skein_256_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, c
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein_256_Update(Skein_256_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt)
+int Skein_256_Update(Skein_256_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
 {
     size_t n;
 
@@ -174,10 +174,10 @@ int Skein_256_Update(Skein_256_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein_256_Final(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein_256_Final(Skein_256_Ctxt_t *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
-    u64b_t X[SKEIN_256_STATE_WORDS];
+    u64 X[SKEIN_256_STATE_WORDS];
     Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
@@ -194,9 +194,9 @@ int Skein_256_Final(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
     memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
     for (i=0;i*SKEIN_256_BLOCK_BYTES < byteCnt;i++)
     {
-        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
         Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein_256_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        Skein_256_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN_256_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN_256_BLOCK_BYTES)
             n  = SKEIN_256_BLOCK_BYTES;
@@ -217,8 +217,8 @@ int Skein_512_Init(Skein_512_Ctxt_t *ctx, size_t hashBitLen)
 {
     union
     {
-        u08b_t  b[SKEIN_512_STATE_BYTES];
-        u64b_t  w[SKEIN_512_STATE_WORDS];
+        u8  b[SKEIN_512_STATE_BYTES];
+        u64  w[SKEIN_512_STATE_WORDS];
     } cfg;                              /* config block */
 
     Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
@@ -264,12 +264,12 @@ int Skein_512_Init(Skein_512_Ctxt_t *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein_512_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_512_InitExt(Skein_512_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, const u08b_t *key, size_t keyBytes)
+int Skein_512_InitExt(Skein_512_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
-        u08b_t  b[SKEIN_512_STATE_BYTES];
-        u64b_t  w[SKEIN_512_STATE_WORDS];
+        u8  b[SKEIN_512_STATE_BYTES];
+        u64  w[SKEIN_512_STATE_WORDS];
     } cfg;                              /* config block */
 
     Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
@@ -314,7 +314,7 @@ int Skein_512_InitExt(Skein_512_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, c
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein_512_Update(Skein_512_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt)
+int Skein_512_Update(Skein_512_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
 {
     size_t n;
 
@@ -362,10 +362,10 @@ int Skein_512_Update(Skein_512_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein_512_Final(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein_512_Final(Skein_512_Ctxt_t *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
-    u64b_t X[SKEIN_512_STATE_WORDS];
+    u64 X[SKEIN_512_STATE_WORDS];
     Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
@@ -382,9 +382,9 @@ int Skein_512_Final(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
     memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
     for (i=0;i*SKEIN_512_BLOCK_BYTES < byteCnt;i++)
     {
-        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
         Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein_512_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        Skein_512_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN_512_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN_512_BLOCK_BYTES)
             n  = SKEIN_512_BLOCK_BYTES;
@@ -405,8 +405,8 @@ int Skein1024_Init(Skein1024_Ctxt_t *ctx, size_t hashBitLen)
 {
     union
     {
-        u08b_t  b[SKEIN1024_STATE_BYTES];
-        u64b_t  w[SKEIN1024_STATE_WORDS];
+        u8  b[SKEIN1024_STATE_BYTES];
+        u64  w[SKEIN1024_STATE_WORDS];
     } cfg;                              /* config block */
 
     Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
@@ -449,12 +449,12 @@ int Skein1024_Init(Skein1024_Ctxt_t *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein1024_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein1024_InitExt(Skein1024_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, const u08b_t *key, size_t keyBytes)
+int Skein1024_InitExt(Skein1024_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
-        u08b_t  b[SKEIN1024_STATE_BYTES];
-        u64b_t  w[SKEIN1024_STATE_WORDS];
+        u8  b[SKEIN1024_STATE_BYTES];
+        u64  w[SKEIN1024_STATE_WORDS];
     } cfg;                              /* config block */
 
     Skein_Assert(hashBitLen > 0,SKEIN_BAD_HASHLEN);
@@ -499,7 +499,7 @@ int Skein1024_InitExt(Skein1024_Ctxt_t *ctx,size_t hashBitLen,u64b_t treeInfo, c
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein1024_Update(Skein1024_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt)
+int Skein1024_Update(Skein1024_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
 {
     size_t n;
 
@@ -547,10 +547,10 @@ int Skein1024_Update(Skein1024_Ctxt_t *ctx, const u08b_t *msg, size_t msgByteCnt
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein1024_Final(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein1024_Final(Skein1024_Ctxt_t *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
-    u64b_t X[SKEIN1024_STATE_WORDS];
+    u64 X[SKEIN1024_STATE_WORDS];
     Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
     ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;                 /* tag as the final block */
@@ -567,9 +567,9 @@ int Skein1024_Final(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
     memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
     for (i=0;i*SKEIN1024_BLOCK_BYTES < byteCnt;i++)
     {
-        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
         Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein1024_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        Skein1024_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN1024_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN1024_BLOCK_BYTES)
             n  = SKEIN1024_BLOCK_BYTES;
@@ -585,7 +585,7 @@ int Skein1024_Final(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u8 *hashVal)
 {
     Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
@@ -601,7 +601,7 @@ int Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u8 *hashVal)
 {
     Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
@@ -617,7 +617,7 @@ int Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u8 *hashVal)
 {
     Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
@@ -634,10 +634,10 @@ int Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
 #if SKEIN_TREE_HASH
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein_256_Output(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein_256_Output(Skein_256_Ctxt_t *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
-    u64b_t X[SKEIN_256_STATE_WORDS];
+    u64 X[SKEIN_256_STATE_WORDS];
     Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
     /* now output the result */
@@ -648,9 +648,9 @@ int Skein_256_Output(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
     memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
     for (i=0;i*SKEIN_256_BLOCK_BYTES < byteCnt;i++)
     {
-        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
         Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein_256_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        Skein_256_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN_256_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN_256_BLOCK_BYTES)
             n  = SKEIN_256_BLOCK_BYTES;
@@ -663,10 +663,10 @@ int Skein_256_Output(Skein_256_Ctxt_t *ctx, u08b_t *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein_512_Output(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein_512_Output(Skein_512_Ctxt_t *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
-    u64b_t X[SKEIN_512_STATE_WORDS];
+    u64 X[SKEIN_512_STATE_WORDS];
     Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
     /* now output the result */
@@ -677,9 +677,9 @@ int Skein_512_Output(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
     memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
     for (i=0;i*SKEIN_512_BLOCK_BYTES < byteCnt;i++)
     {
-        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
         Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein_512_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        Skein_512_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN_512_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN_512_BLOCK_BYTES)
             n  = SKEIN_512_BLOCK_BYTES;
@@ -692,10 +692,10 @@ int Skein_512_Output(Skein_512_Ctxt_t *ctx, u08b_t *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein1024_Output(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
+int Skein1024_Output(Skein1024_Ctxt_t *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
-    u64b_t X[SKEIN1024_STATE_WORDS];
+    u64 X[SKEIN1024_STATE_WORDS];
     Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
     /* now output the result */
@@ -706,9 +706,9 @@ int Skein1024_Output(Skein1024_Ctxt_t *ctx, u08b_t *hashVal)
     memcpy(X,ctx->X,sizeof(X));       /* keep a local copy of counter mode "key" */
     for (i=0;i*SKEIN1024_BLOCK_BYTES < byteCnt;i++)
     {
-        ((u64b_t *)ctx->b)[0]= Skein_Swap64((u64b_t) i); /* build the counter block */
+        ((u64 *)ctx->b)[0]= Skein_Swap64((u64) i); /* build the counter block */
         Skein_Start_New_Type(ctx,OUT_FINAL);
-        Skein1024_Process_Block(ctx,ctx->b,1,sizeof(u64b_t)); /* run "counter mode" */
+        Skein1024_Process_Block(ctx,ctx->b,1,sizeof(u64)); /* run "counter mode" */
         n = byteCnt - i*SKEIN1024_BLOCK_BYTES;   /* number of output bytes left to go */
         if (n >= SKEIN1024_BLOCK_BYTES)
             n  = SKEIN1024_BLOCK_BYTES;
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index 579b92efbf65..ef021086bc61 100755
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -41,7 +41,7 @@ int skeinInit(SkeinCtx_t* ctx, size_t hashBitLen)
 {
     int ret = SKEIN_FAIL;
     size_t Xlen = 0;
-    u64b_t*  X = NULL;
+    u64*  X = NULL;
     uint64_t treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
     Skein_Assert(ctx, SKEIN_FAIL);
@@ -82,7 +82,7 @@ int skeinMacInit(SkeinCtx_t* ctx, const uint8_t *key, size_t keyLen,
                  size_t hashBitLen)
 {
     int ret = SKEIN_FAIL;
-    u64b_t*  X = NULL;
+    u64*  X = NULL;
     size_t Xlen = 0;
     uint64_t treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
@@ -97,18 +97,18 @@ int skeinMacInit(SkeinCtx_t* ctx, const uint8_t *key, size_t keyLen,
     case Skein256:
         ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
                                 treeInfo,
-                                (const u08b_t*)key, keyLen);
+                                (const u8*)key, keyLen);
 
         break;
     case Skein512:
         ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
                                 treeInfo,
-                                (const u08b_t*)key, keyLen);
+                                (const u8*)key, keyLen);
         break;
     case Skein1024:
         ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
                                 treeInfo,
-                                (const u08b_t*)key, keyLen);
+                                (const u8*)key, keyLen);
 
         break;
     }
@@ -122,7 +122,7 @@ int skeinMacInit(SkeinCtx_t* ctx, const uint8_t *key, size_t keyLen,
 void skeinReset(SkeinCtx_t* ctx)
 {
     size_t Xlen = 0;
-    u64b_t*  X = NULL;
+    u64*  X = NULL;
 
     /*
      * The following two lines rely of the fact that the real Skein contexts are
@@ -146,13 +146,13 @@ int skeinUpdate(SkeinCtx_t *ctx, const uint8_t *msg,
 
     switch (ctx->skeinSize) {
     case Skein256:
-        ret = Skein_256_Update(&ctx->m.s256, (const u08b_t*)msg, msgByteCnt);
+        ret = Skein_256_Update(&ctx->m.s256, (const u8*)msg, msgByteCnt);
         break;
     case Skein512:
-        ret = Skein_512_Update(&ctx->m.s512, (const u08b_t*)msg, msgByteCnt);
+        ret = Skein_512_Update(&ctx->m.s512, (const u8*)msg, msgByteCnt);
         break;
     case Skein1024:
-        ret = Skein1024_Update(&ctx->m.s1024, (const u08b_t*)msg, msgByteCnt);
+        ret = Skein1024_Update(&ctx->m.s1024, (const u8*)msg, msgByteCnt);
         break;
     }
     return ret;
@@ -206,13 +206,13 @@ int skeinFinal(SkeinCtx_t* ctx, uint8_t* hash)
 
     switch (ctx->skeinSize) {
     case Skein256:
-        ret = Skein_256_Final(&ctx->m.s256, (u08b_t*)hash);
+        ret = Skein_256_Final(&ctx->m.s256, (u8*)hash);
         break;
     case Skein512:
-        ret = Skein_512_Final(&ctx->m.s512, (u08b_t*)hash);
+        ret = Skein_512_Final(&ctx->m.s512, (u8*)hash);
         break;
     case Skein1024:
-        ret = Skein1024_Final(&ctx->m.s1024, (u08b_t*)hash);
+        ret = Skein1024_Final(&ctx->m.s1024, (u8*)hash);
         break;
     }
     return ret;
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 6a19ceb17d0f..56c56b8ebd7e 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -5,21 +5,21 @@
 
 
 /*****************************  Skein_256 ******************************/
-void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx, const u08b_t *blkPtr,
+void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx, const u8 *blkPtr,
                              size_t blkCnt, size_t byteCntAdd)
 {
     ThreefishKey_t key;
-    u64b_t tweak[2];
+    u64 tweak[2];
     int i;
-    u64b_t  w[SKEIN_256_STATE_WORDS];           /* local copy of input block */
-    u64b_t words[3];
+    u64  w[SKEIN_256_STATE_WORDS];           /* local copy of input block */
+    u64 words[3];
 
     Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
     tweak[0] = ctx->h.T[0];
     tweak[1] = ctx->h.T[1];
 
     do  {
-        u64b_t carry = byteCntAdd;
+        u64 carry = byteCntAdd;
 
         words[0] = tweak[0] & 0xffffffffL;
         words[1] = ((tweak[0] >> 32) & 0xffffffffL);
@@ -55,21 +55,21 @@ void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx, const u08b_t *blkPtr,
     ctx->h.T[1] = tweak[1];
 }
 
-void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx, const u08b_t *blkPtr,
+void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx, const u8 *blkPtr,
                              size_t blkCnt, size_t byteCntAdd)
 {
     ThreefishKey_t key;
-    u64b_t tweak[2];
+    u64 tweak[2];
     int i;
-    u64b_t words[3];
-    u64b_t  w[SKEIN_512_STATE_WORDS];           /* local copy of input block */
+    u64 words[3];
+    u64  w[SKEIN_512_STATE_WORDS];           /* local copy of input block */
 
     Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
     tweak[0] = ctx->h.T[0];
     tweak[1] = ctx->h.T[1];
 
     do  {
-        u64b_t carry = byteCntAdd;
+        u64 carry = byteCntAdd;
 
         words[0] = tweak[0] & 0xffffffffL;
         words[1] = ((tweak[0] >> 32) & 0xffffffffL);
@@ -109,21 +109,21 @@ void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx, const u08b_t *blkPtr,
     ctx->h.T[1] = tweak[1];
 }
 
-void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx, const u08b_t *blkPtr,
+void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx, const u8 *blkPtr,
                               size_t blkCnt, size_t byteCntAdd)
 {
     ThreefishKey_t key;
-    u64b_t tweak[2];
+    u64 tweak[2];
     int i;
-    u64b_t words[3];
-    u64b_t  w[SKEIN1024_STATE_WORDS];           /* local copy of input block */
+    u64 words[3];
+    u64  w[SKEIN1024_STATE_WORDS];           /* local copy of input block */
 
     Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
     tweak[0] = ctx->h.T[0];
     tweak[1] = ctx->h.T[1];
 
     do  {
-        u64b_t carry = byteCntAdd;
+        u64 carry = byteCntAdd;
 
         words[0] = tweak[0] & 0xffffffffL;
         words[1] = ((tweak[0] >> 32) & 0xffffffffL);
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index b5be41af6d17..98e884292044 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -39,7 +39,7 @@
 
 /*****************************  Skein_256 ******************************/
 #if !(SKEIN_USE_ASM & 256)
-void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
     { /* do it in C */
     enum
         {
@@ -59,14 +59,14 @@ void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u08b_t *blkPtr,size_t b
 #error "Invalid SKEIN_UNROLL_256"               /* sanity check on unroll count */
 #endif
     size_t  r;
-    u64b_t  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+    u64  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
 #else
-    u64b_t  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+    u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
 #endif
-    u64b_t  X0,X1,X2,X3;                        /* local copy of context vars, for speed */
-    u64b_t  w [WCNT];                           /* local copy of input block */
+    u64  X0,X1,X2,X3;                        /* local copy of context vars, for speed */
+    u64  w [WCNT];                           /* local copy of input block */
 #ifdef SKEIN_DEBUG
-    const u64b_t *Xptr[4];                      /* use for debugging (help compiler put Xn in registers) */
+    const u64 *Xptr[4];                      /* use for debugging (help compiler put Xn in registers) */
     Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
 #endif
     Skein_assert(blkCnt != 0);                  /* never call with blkCnt == 0! */
@@ -212,10 +212,10 @@ void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u08b_t *blkPtr,size_t b
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
 size_t Skein_256_Process_Block_CodeSize(void)
     {
-    return ((u08b_t *) Skein_256_Process_Block_CodeSize) -
-           ((u08b_t *) Skein_256_Process_Block);
+    return ((u8 *) Skein_256_Process_Block_CodeSize) -
+           ((u8 *) Skein_256_Process_Block);
     }
-uint_t Skein_256_Unroll_Cnt(void)
+unsigned int Skein_256_Unroll_Cnt(void)
     {
     return SKEIN_UNROLL_256;
     }
@@ -224,7 +224,7 @@ uint_t Skein_256_Unroll_Cnt(void)
 
 /*****************************  Skein_512 ******************************/
 #if !(SKEIN_USE_ASM & 512)
-void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
     { /* do it in C */
     enum
         {
@@ -244,14 +244,14 @@ void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u08b_t *blkPtr,size_t b
 #error "Invalid SKEIN_UNROLL_512"               /* sanity check on unroll count */
 #endif
     size_t  r;
-    u64b_t  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+    u64  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
 #else
-    u64b_t  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+    u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
 #endif
-    u64b_t  X0,X1,X2,X3,X4,X5,X6,X7;            /* local copy of vars, for speed */
-    u64b_t  w [WCNT];                           /* local copy of input block */
+    u64  X0,X1,X2,X3,X4,X5,X6,X7;            /* local copy of vars, for speed */
+    u64  w [WCNT];                           /* local copy of input block */
 #ifdef SKEIN_DEBUG
-    const u64b_t *Xptr[8];                      /* use for debugging (help compiler put Xn in registers) */
+    const u64 *Xptr[8];                      /* use for debugging (help compiler put Xn in registers) */
     Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
     Xptr[4] = &X4;  Xptr[5] = &X5;  Xptr[6] = &X6;  Xptr[7] = &X7;
 #endif
@@ -420,10 +420,10 @@ void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u08b_t *blkPtr,size_t b
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
 size_t Skein_512_Process_Block_CodeSize(void)
     {
-    return ((u08b_t *) Skein_512_Process_Block_CodeSize) -
-           ((u08b_t *) Skein_512_Process_Block);
+    return ((u8 *) Skein_512_Process_Block_CodeSize) -
+           ((u8 *) Skein_512_Process_Block);
     }
-uint_t Skein_512_Unroll_Cnt(void)
+unsigned int Skein_512_Unroll_Cnt(void)
     {
     return SKEIN_UNROLL_512;
     }
@@ -432,7 +432,7 @@ uint_t Skein_512_Unroll_Cnt(void)
 
 /*****************************  Skein1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
-void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u08b_t *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
     { /* do it in C, always looping (unrolled is bigger AND slower!) */
     enum
         {
@@ -452,16 +452,16 @@ void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u08b_t *blkPtr,size_t b
 #error "Invalid SKEIN_UNROLL_1024"              /* sanity check on unroll count */
 #endif
     size_t  r;
-    u64b_t  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
+    u64  kw[WCNT+4+RCNT*2];                  /* key schedule words : chaining vars + tweak + "rotation"*/
 #else
-    u64b_t  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
+    u64  kw[WCNT+4];                         /* key schedule words : chaining vars + tweak */
 #endif
 
-    u64b_t  X00,X01,X02,X03,X04,X05,X06,X07,    /* local copy of vars, for speed */
+    u64  X00,X01,X02,X03,X04,X05,X06,X07,    /* local copy of vars, for speed */
             X08,X09,X10,X11,X12,X13,X14,X15;
-    u64b_t  w [WCNT];                           /* local copy of input block */
+    u64  w [WCNT];                           /* local copy of input block */
 #ifdef SKEIN_DEBUG
-    const u64b_t *Xptr[16];                     /* use for debugging (help compiler put Xn in registers) */
+    const u64 *Xptr[16];                     /* use for debugging (help compiler put Xn in registers) */
     Xptr[ 0] = &X00;  Xptr[ 1] = &X01;  Xptr[ 2] = &X02;  Xptr[ 3] = &X03;
     Xptr[ 4] = &X04;  Xptr[ 5] = &X05;  Xptr[ 6] = &X06;  Xptr[ 7] = &X07;
     Xptr[ 8] = &X08;  Xptr[ 9] = &X09;  Xptr[10] = &X10;  Xptr[11] = &X11;
@@ -678,10 +678,10 @@ void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u08b_t *blkPtr,size_t b
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
 size_t Skein1024_Process_Block_CodeSize(void)
     {
-    return ((u08b_t *) Skein1024_Process_Block_CodeSize) -
-           ((u08b_t *) Skein1024_Process_Block);
+    return ((u8 *) Skein1024_Process_Block_CodeSize) -
+           ((u8 *) Skein1024_Process_Block);
     }
-uint_t Skein1024_Unroll_Cnt(void)
+unsigned int Skein1024_Unroll_Cnt(void)
     {
     return SKEIN_UNROLL_1024;
     }
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index 968d3d21fe61..ed19ee9e3425 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -25,8 +25,8 @@ void threefishSetKey(ThreefishKey_t* keyCtx, ThreefishSize_t stateSize,
 void threefishEncryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in,
                                 uint8_t* out)
 {
-    u64b_t plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
-    u64b_t cipher[SKEIN_MAX_STATE_WORDS];
+    u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
+    u64 cipher[SKEIN_MAX_STATE_WORDS];
     
     Skein_Get64_LSB_First(plain, in, keyCtx->stateSize / 64);   /* bytes to words */
     threefishEncryptBlockWords(keyCtx, plain, cipher);
@@ -52,8 +52,8 @@ void threefishEncryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in,
 void threefishDecryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in,
                                 uint8_t* out)
 {
-    u64b_t plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
-    u64b_t cipher[SKEIN_MAX_STATE_WORDS];
+    u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
+    u64 cipher[SKEIN_MAX_STATE_WORDS];
     
     Skein_Get64_LSB_First(cipher, in, keyCtx->stateSize / 64);  /* bytes to words */
     threefishDecryptBlockWords(keyCtx, cipher, plain);
-- 
1.9.1
