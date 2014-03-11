From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 08/22] staging: crypto: skein: remove all typedef {struct,enum}
Date: Tue, 11 Mar 2014 21:32:40 +0000
Message-ID: <334e8ff01c1abca425dcf15cfb2c114845ec1ddd.1394570068.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51888 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755761AbaCKVzm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:42 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein.h        | 58 ++++++++++++++--------------
 drivers/staging/skein/include/skeinApi.h     | 32 +++++++--------
 drivers/staging/skein/include/threefishApi.h | 32 +++++++--------
 drivers/staging/skein/skein.c                | 42 ++++++++++----------
 drivers/staging/skein/skeinApi.c             | 16 ++++----
 drivers/staging/skein/skeinBlockNo3F.c       | 12 +++---
 drivers/staging/skein/skein_block.c          |  6 +--
 drivers/staging/skein/threefish1024Block.c   |  4 +-
 drivers/staging/skein/threefish256Block.c    |  4 +-
 drivers/staging/skein/threefish512Block.c    |  4 +-
 drivers/staging/skein/threefishApi.c         | 10 ++---
 11 files changed, 110 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 12c5c8d612b0..77b712e73253 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -63,46 +63,46 @@ enum
 #define  SKEIN_512_BLOCK_BYTES ( 8*SKEIN_512_STATE_WORDS)
 #define  SKEIN1024_BLOCK_BYTES ( 8*SKEIN1024_STATE_WORDS)
 
-typedef struct
+struct skein_ctx_hdr
     {
     size_t  hashBitLen;                      /* size of hash result, in bits */
     size_t  bCnt;                            /* current byte count in buffer b[] */
     u64  T[SKEIN_MODIFIER_WORDS];         /* tweak words: T[0]=byte cnt, T[1]=flags */
-    } Skein_Ctxt_Hdr_t;
+    };
 
-typedef struct                               /*  256-bit Skein hash context structure */
+struct skein_256_ctx                               /*  256-bit Skein hash context structure */
     {
-    Skein_Ctxt_Hdr_t h;                      /* common header context variables */
+    struct skein_ctx_hdr h;                      /* common header context variables */
     u64  X[SKEIN_256_STATE_WORDS];        /* chaining variables */
     u8  b[SKEIN_256_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
-    } Skein_256_Ctxt_t;
+    };
 
-typedef struct                               /*  512-bit Skein hash context structure */
+struct skein_512_ctx                             /*  512-bit Skein hash context structure */
     {
-    Skein_Ctxt_Hdr_t h;                      /* common header context variables */
+    struct skein_ctx_hdr h;                      /* common header context variables */
     u64  X[SKEIN_512_STATE_WORDS];        /* chaining variables */
     u8  b[SKEIN_512_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
-    } Skein_512_Ctxt_t;
+    };
 
-typedef struct                               /* 1024-bit Skein hash context structure */
+struct skein1024_ctx                              /* 1024-bit Skein hash context structure */
     {
-    Skein_Ctxt_Hdr_t h;                      /* common header context variables */
+    struct skein_ctx_hdr h;                      /* common header context variables */
     u64  X[SKEIN1024_STATE_WORDS];        /* chaining variables */
     u8  b[SKEIN1024_BLOCK_BYTES];        /* partial block buffer (8-byte aligned) */
-    } Skein1024_Ctxt_t;
+    };
 
 /*   Skein APIs for (incremental) "straight hashing" */
-int  Skein_256_Init  (Skein_256_Ctxt_t *ctx, size_t hashBitLen);
-int  Skein_512_Init  (Skein_512_Ctxt_t *ctx, size_t hashBitLen);
-int  Skein1024_Init  (Skein1024_Ctxt_t *ctx, size_t hashBitLen);
+int  Skein_256_Init  (struct skein_256_ctx *ctx, size_t hashBitLen);
+int  Skein_512_Init  (struct skein_512_ctx *ctx, size_t hashBitLen);
+int  Skein1024_Init  (struct skein1024_ctx *ctx, size_t hashBitLen);
 
-int  Skein_256_Update(Skein_256_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt);
-int  Skein_512_Update(Skein_512_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt);
-int  Skein1024_Update(Skein1024_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt);
+int  Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt);
+int  Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt);
+int  Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt);
 
-int  Skein_256_Final (Skein_256_Ctxt_t *ctx, u8 * hashVal);
-int  Skein_512_Final (Skein_512_Ctxt_t *ctx, u8 * hashVal);
-int  Skein1024_Final (Skein1024_Ctxt_t *ctx, u8 * hashVal);
+int  Skein_256_Final (struct skein_256_ctx *ctx, u8 * hashVal);
+int  Skein_512_Final (struct skein_512_ctx *ctx, u8 * hashVal);
+int  Skein1024_Final (struct skein1024_ctx *ctx, u8 * hashVal);
 
 /*
 **   Skein APIs for "extended" initialization: MAC keys, tree hashing.
@@ -118,26 +118,26 @@ int  Skein1024_Final (Skein1024_Ctxt_t *ctx, u8 * hashVal);
 **              to precompute the MAC IV, then a copy of the context saved and
 **              reused for each new MAC computation.
 **/
-int  Skein_256_InitExt(Skein_256_Ctxt_t *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
-int  Skein_512_InitExt(Skein_512_Ctxt_t *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
-int  Skein1024_InitExt(Skein1024_Ctxt_t *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
+int  Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen, u64 treeInfo, const u8 *key, size_t keyBytes);
 
 /*
 **   Skein APIs for MAC and tree hash:
 **      Final_Pad:  pad, do final block, but no OUTPUT type
 **      Output:     do just the output stage
 */
-int  Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u8 * hashVal);
-int  Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u8 * hashVal);
-int  Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u8 * hashVal);
+int  Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 * hashVal);
+int  Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 * hashVal);
+int  Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 * hashVal);
 
 #ifndef SKEIN_TREE_HASH
 #define SKEIN_TREE_HASH (1)
 #endif
 #if  SKEIN_TREE_HASH
-int  Skein_256_Output   (Skein_256_Ctxt_t *ctx, u8 * hashVal);
-int  Skein_512_Output   (Skein_512_Ctxt_t *ctx, u8 * hashVal);
-int  Skein1024_Output   (Skein1024_Ctxt_t *ctx, u8 * hashVal);
+int  Skein_256_Output   (struct skein_256_ctx *ctx, u8 * hashVal);
+int  Skein_512_Output   (struct skein_512_ctx *ctx, u8 * hashVal);
+int  Skein1024_Output   (struct skein1024_ctx *ctx, u8 * hashVal);
 #endif
 
 /*****************************************************************
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index fb4a7c8e7f7a..548c639431de 100755
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -47,7 +47,7 @@ OTHER DEALINGS IN THE SOFTWARE.
  * #include <skeinApi.h>
  * 
  * ...
- * SkeinCtx_t ctx;             // a Skein hash or MAC context
+ * struct skein_ctx ctx;             // a Skein hash or MAC context
  * 
  * // prepare context, here for a Skein with a state size of 512 bits.
  * skeinCtxPrepare(&ctx, Skein512);
@@ -84,11 +84,11 @@ OTHER DEALINGS IN THE SOFTWARE.
     /**
      * Which Skein size to use
      */
-    typedef enum SkeinSize {
+    enum skein_size {
         Skein256 = 256,     /*!< Skein with 256 bit state */
         Skein512 = 512,     /*!< Skein with 512 bit state */
         Skein1024 = 1024    /*!< Skein with 1024 bit state */
-    } SkeinSize_t;
+    };
 
     /**
      * Context for Skein.
@@ -98,16 +98,16 @@ OTHER DEALINGS IN THE SOFTWARE.
      * variables. If Skein implementation changes this, then adapt these
      * structures as well.
      */
-    typedef struct SkeinCtx {
+    struct skein_ctx {
         u64 skeinSize;
         u64  XSave[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
         union {
-            Skein_Ctxt_Hdr_t h;
-            Skein_256_Ctxt_t s256;
-            Skein_512_Ctxt_t s512;
-            Skein1024_Ctxt_t s1024;
+            struct skein_ctx_hdr h;
+            struct skein_256_ctx s256;
+            struct skein_512_ctx s512;
+            struct skein1024_ctx s1024;
         } m;
-    } SkeinCtx_t;
+    };
 
     /**
      * Prepare a Skein context.
@@ -123,7 +123,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @return
      *     SKEIN_SUCESS of SKEIN_FAIL
      */
-    int skeinCtxPrepare(SkeinCtx_t* ctx, SkeinSize_t size);
+    int skeinCtxPrepare(struct skein_ctx* ctx, enum skein_size size);
 
     /**
      * Initialize a Skein context.
@@ -139,7 +139,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      *     SKEIN_SUCESS of SKEIN_FAIL
      * @see skeinReset
      */
-    int skeinInit(SkeinCtx_t* ctx, size_t hashBitLen);
+    int skeinInit(struct skein_ctx* ctx, size_t hashBitLen);
 
     /**
      * Resets a Skein context for further use.
@@ -151,7 +151,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @param ctx
      *     Pointer to a pre-initialized Skein MAC context
      */
-    void skeinReset(SkeinCtx_t* ctx);
+    void skeinReset(struct skein_ctx* ctx);
     
     /**
      * Initializes a Skein context for MAC usage.
@@ -173,7 +173,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @return
      *     SKEIN_SUCESS of SKEIN_FAIL
      */
-    int skeinMacInit(SkeinCtx_t* ctx, const uint8_t *key, size_t keyLen,
+    int skeinMacInit(struct skein_ctx* ctx, const uint8_t *key, size_t keyLen,
                      size_t hashBitLen);
 
     /**
@@ -188,7 +188,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @return
      *     Success or error code.
      */
-    int skeinUpdate(SkeinCtx_t *ctx, const uint8_t *msg,
+    int skeinUpdate(struct skein_ctx *ctx, const uint8_t *msg,
                     size_t msgByteCnt);
 
     /**
@@ -204,7 +204,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @param msgBitCnt
      *     Length of the message in @b bits.
      */
-    int skeinUpdateBits(SkeinCtx_t *ctx, const uint8_t *msg,
+    int skeinUpdateBits(struct skein_ctx *ctx, const uint8_t *msg,
                         size_t msgBitCnt);
 
     /**
@@ -222,7 +222,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      *     Success or error code.
      * @see skeinReset
      */
-    int skeinFinal(SkeinCtx_t* ctx, uint8_t* hash);
+    int skeinFinal(struct skein_ctx* ctx, uint8_t* hash);
 
 /**
  * @}
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 0123a575b606..4c1cd81f30c4 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -18,7 +18,7 @@
  * 
 @code
     // Threefish cipher context data
-    ThreefishKey_t keyCtx;
+    struct threefish_key keyCtx;
 
     // Initialize the context
     threefishSetKey(&keyCtx, Threefish512, key, tweak);
@@ -36,11 +36,11 @@
     /**
      * Which Threefish size to use
      */
-    typedef enum ThreefishSize {
+    enum threefish_size {
         Threefish256 = 256,     /*!< Skein with 256 bit state */
         Threefish512 = 512,     /*!< Skein with 512 bit state */
         Threefish1024 = 1024    /*!< Skein with 1024 bit state */
-    } ThreefishSize_t;
+    };
     
     /**
      * Context for Threefish key and tweak words.
@@ -50,11 +50,11 @@
      * variables. If Skein implementation changes this, the adapt these
      * structures as well.
      */
-    typedef struct ThreefishKey {
+    struct threefish_key {
         u64 stateSize;
         u64 key[SKEIN_MAX_STATE_WORDS+1];   /* max number of key words*/
         u64 tweak[3];
-    } ThreefishKey_t;
+    };
 
     /**
      * Set Threefish key and tweak data.
@@ -72,7 +72,7 @@
      * @param tweak
      *     Pointer to the two tweak words (word has 64 bits).
      */
-    void threefishSetKey(ThreefishKey_t* keyCtx, ThreefishSize_t stateSize, uint64_t* keyData, uint64_t* tweak);
+    void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize, uint64_t* keyData, uint64_t* tweak);
     
     /**
      * Encrypt Threefisch block (bytes).
@@ -89,7 +89,7 @@
      * @param out
      *     Pointer to cipher buffer.
      */
-    void threefishEncryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in, uint8_t* out);
+    void threefishEncryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in, uint8_t* out);
     
     /**
      * Encrypt Threefisch block (words).
@@ -108,7 +108,7 @@
      * @param out
      *     Pointer to cipher buffer.
      */
-    void threefishEncryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in, uint64_t* out);
+    void threefishEncryptBlockWords(struct threefish_key* keyCtx, uint64_t* in, uint64_t* out);
 
     /**
      * Decrypt Threefisch block (bytes).
@@ -125,7 +125,7 @@
      * @param out
      *     Pointer to plaintext buffer.
      */
-    void threefishDecryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in, uint8_t* out);
+    void threefishDecryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in, uint8_t* out);
 
     /**
      * Decrypt Threefisch block (words).
@@ -144,14 +144,14 @@
      * @param out
      *     Pointer to plaintext buffer.
      */
-    void threefishDecryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in, uint64_t* out);
+    void threefishDecryptBlockWords(struct threefish_key* keyCtx, uint64_t* in, uint64_t* out);
 
-    void threefishEncrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishEncrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishEncrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishDecrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishDecrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishDecrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishEncrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishEncrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishEncrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishDecrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishDecrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishDecrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
 /**
  * @}
  */
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index b225642efa4a..2bed7c163316 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -16,9 +16,9 @@
 
 /*****************************************************************/
 /* External function to process blkCnt (nonzero) full block(s) of data. */
-void    Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
-void    Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
-void    Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein_256_Process_Block(struct skein_256_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein_512_Process_Block(struct skein_512_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
+void    Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd);
 
 /*****************************************************************/
 /*     256-bit Skein                                             */
@@ -26,7 +26,7 @@ void    Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u8 *blkPtr,size_t bl
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int Skein_256_Init(Skein_256_Ctxt_t *ctx, size_t hashBitLen)
+int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 {
     union
     {
@@ -76,7 +76,7 @@ int Skein_256_Init(Skein_256_Ctxt_t *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein_256_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_256_InitExt(Skein_256_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
+int Skein_256_InitExt(struct skein_256_ctx *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
@@ -126,7 +126,7 @@ int Skein_256_InitExt(Skein_256_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, cons
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein_256_Update(Skein_256_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
+int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCnt)
 {
     size_t n;
 
@@ -174,7 +174,7 @@ int Skein_256_Update(Skein_256_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein_256_Final(Skein_256_Ctxt_t *ctx, u8 *hashVal)
+int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
     u64 X[SKEIN_256_STATE_WORDS];
@@ -213,7 +213,7 @@ int Skein_256_Final(Skein_256_Ctxt_t *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int Skein_512_Init(Skein_512_Ctxt_t *ctx, size_t hashBitLen)
+int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 {
     union
     {
@@ -264,7 +264,7 @@ int Skein_512_Init(Skein_512_Ctxt_t *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein_512_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_512_InitExt(Skein_512_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
+int Skein_512_InitExt(struct skein_512_ctx *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
@@ -314,7 +314,7 @@ int Skein_512_InitExt(Skein_512_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, cons
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein_512_Update(Skein_512_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
+int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt)
 {
     size_t n;
 
@@ -362,7 +362,7 @@ int Skein_512_Update(Skein_512_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein_512_Final(Skein_512_Ctxt_t *ctx, u8 *hashVal)
+int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
     u64 X[SKEIN_512_STATE_WORDS];
@@ -401,7 +401,7 @@ int Skein_512_Final(Skein_512_Ctxt_t *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int Skein1024_Init(Skein1024_Ctxt_t *ctx, size_t hashBitLen)
+int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 {
     union
     {
@@ -449,7 +449,7 @@ int Skein1024_Init(Skein1024_Ctxt_t *ctx, size_t hashBitLen)
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to Skein1024_Init() when keyBytes == 0 && treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein1024_InitExt(Skein1024_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
+int Skein1024_InitExt(struct skein1024_ctx *ctx,size_t hashBitLen,u64 treeInfo, const u8 *key, size_t keyBytes)
 {
     union
     {
@@ -499,7 +499,7 @@ int Skein1024_InitExt(Skein1024_Ctxt_t *ctx,size_t hashBitLen,u64 treeInfo, cons
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein1024_Update(Skein1024_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
+int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt)
 {
     size_t n;
 
@@ -547,7 +547,7 @@ int Skein1024_Update(Skein1024_Ctxt_t *ctx, const u8 *msg, size_t msgByteCnt)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein1024_Final(Skein1024_Ctxt_t *ctx, u8 *hashVal)
+int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
     u64 X[SKEIN1024_STATE_WORDS];
@@ -585,7 +585,7 @@ int Skein1024_Final(Skein1024_Ctxt_t *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u8 *hashVal)
+int Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal)
 {
     Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
@@ -601,7 +601,7 @@ int Skein_256_Final_Pad(Skein_256_Ctxt_t *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u8 *hashVal)
+int Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal)
 {
     Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
@@ -617,7 +617,7 @@ int Skein_512_Final_Pad(Skein_512_Ctxt_t *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u8 *hashVal)
+int Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal)
 {
     Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES,SKEIN_FAIL);    /* catch uninitialized context */
 
@@ -634,7 +634,7 @@ int Skein1024_Final_Pad(Skein1024_Ctxt_t *ctx, u8 *hashVal)
 #if SKEIN_TREE_HASH
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein_256_Output(Skein_256_Ctxt_t *ctx, u8 *hashVal)
+int Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
     u64 X[SKEIN_256_STATE_WORDS];
@@ -663,7 +663,7 @@ int Skein_256_Output(Skein_256_Ctxt_t *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein_512_Output(Skein_512_Ctxt_t *ctx, u8 *hashVal)
+int Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
     u64 X[SKEIN_512_STATE_WORDS];
@@ -692,7 +692,7 @@ int Skein_512_Output(Skein_512_Ctxt_t *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein1024_Output(Skein1024_Ctxt_t *ctx, u8 *hashVal)
+int Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal)
 {
     size_t i,n,byteCnt;
     u64 X[SKEIN1024_STATE_WORDS];
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index ef021086bc61..ce5c5ae575e7 100755
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -27,17 +27,17 @@ OTHER DEALINGS IN THE SOFTWARE.
 #include <linux/string.h>
 #include <skeinApi.h>
 
-int skeinCtxPrepare(SkeinCtx_t* ctx, SkeinSize_t size)
+int skeinCtxPrepare(struct skein_ctx* ctx, enum skein_size size)
 {
     Skein_Assert(ctx && size, SKEIN_FAIL);
 
-    memset(ctx ,0, sizeof(SkeinCtx_t));
+    memset(ctx ,0, sizeof(struct skein_ctx));
     ctx->skeinSize = size;
 
     return SKEIN_SUCCESS;
 }
 
-int skeinInit(SkeinCtx_t* ctx, size_t hashBitLen)
+int skeinInit(struct skein_ctx* ctx, size_t hashBitLen)
 {
     int ret = SKEIN_FAIL;
     size_t Xlen = 0;
@@ -78,7 +78,7 @@ int skeinInit(SkeinCtx_t* ctx, size_t hashBitLen)
     return ret;
 }
 
-int skeinMacInit(SkeinCtx_t* ctx, const uint8_t *key, size_t keyLen,
+int skeinMacInit(struct skein_ctx* ctx, const uint8_t *key, size_t keyLen,
                  size_t hashBitLen)
 {
     int ret = SKEIN_FAIL;
@@ -119,7 +119,7 @@ int skeinMacInit(SkeinCtx_t* ctx, const uint8_t *key, size_t keyLen,
     return ret;
 }
 
-void skeinReset(SkeinCtx_t* ctx)
+void skeinReset(struct skein_ctx* ctx)
 {
     size_t Xlen = 0;
     u64*  X = NULL;
@@ -138,7 +138,7 @@ void skeinReset(SkeinCtx_t* ctx)
     Skein_Start_New_Type(&ctx->m, MSG);
 }
 
-int skeinUpdate(SkeinCtx_t *ctx, const uint8_t *msg,
+int skeinUpdate(struct skein_ctx *ctx, const uint8_t *msg,
                 size_t msgByteCnt)
 {
     int ret = SKEIN_FAIL;
@@ -159,7 +159,7 @@ int skeinUpdate(SkeinCtx_t *ctx, const uint8_t *msg,
 
 }
 
-int skeinUpdateBits(SkeinCtx_t *ctx, const uint8_t *msg,
+int skeinUpdateBits(struct skein_ctx *ctx, const uint8_t *msg,
                     size_t msgBitCnt)
 {
     /*
@@ -199,7 +199,7 @@ int skeinUpdateBits(SkeinCtx_t *ctx, const uint8_t *msg,
     return SKEIN_SUCCESS;
 }
 
-int skeinFinal(SkeinCtx_t* ctx, uint8_t* hash)
+int skeinFinal(struct skein_ctx* ctx, uint8_t* hash)
 {
     int ret = SKEIN_FAIL;
     Skein_Assert(ctx, SKEIN_FAIL);
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 56c56b8ebd7e..02e68dbab0d4 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -5,10 +5,10 @@
 
 
 /*****************************  Skein_256 ******************************/
-void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx, const u8 *blkPtr,
+void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
                              size_t blkCnt, size_t byteCntAdd)
 {
-    ThreefishKey_t key;
+    struct threefish_key key;
     u64 tweak[2];
     int i;
     u64  w[SKEIN_256_STATE_WORDS];           /* local copy of input block */
@@ -55,10 +55,10 @@ void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx, const u8 *blkPtr,
     ctx->h.T[1] = tweak[1];
 }
 
-void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx, const u8 *blkPtr,
+void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
                              size_t blkCnt, size_t byteCntAdd)
 {
-    ThreefishKey_t key;
+    struct threefish_key key;
     u64 tweak[2];
     int i;
     u64 words[3];
@@ -109,10 +109,10 @@ void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx, const u8 *blkPtr,
     ctx->h.T[1] = tweak[1];
 }
 
-void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx, const u8 *blkPtr,
+void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
                               size_t blkCnt, size_t byteCntAdd)
 {
-    ThreefishKey_t key;
+    struct threefish_key key;
     u64 tweak[2];
     int i;
     u64 words[3];
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 98e884292044..179bde121380 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -39,7 +39,7 @@
 
 /*****************************  Skein_256 ******************************/
 #if !(SKEIN_USE_ASM & 256)
-void Skein_256_Process_Block(Skein_256_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein_256_Process_Block(struct skein_256_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
     { /* do it in C */
     enum
         {
@@ -224,7 +224,7 @@ unsigned int Skein_256_Unroll_Cnt(void)
 
 /*****************************  Skein_512 ******************************/
 #if !(SKEIN_USE_ASM & 512)
-void Skein_512_Process_Block(Skein_512_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein_512_Process_Block(struct skein_512_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
     { /* do it in C */
     enum
         {
@@ -432,7 +432,7 @@ unsigned int Skein_512_Unroll_Cnt(void)
 
 /*****************************  Skein1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
-void Skein1024_Process_Block(Skein1024_Ctxt_t *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
+void Skein1024_Process_Block(struct skein1024_ctx *ctx,const u8 *blkPtr,size_t blkCnt,size_t byteCntAdd)
     { /* do it in C, always looping (unrolled is bigger AND slower!) */
     enum
         {
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
index 58a8c26a1f6f..738ec523406b 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish1024Block.c
@@ -2,7 +2,7 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+void threefishEncrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
         {
 
     uint64_t b0 = input[0], b1 = input[1],
@@ -684,7 +684,7 @@ void threefishEncrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* out
             output[15] = b15 + k1 + 20;
         }
 
-void threefishDecrypt1024(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+void threefishDecrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
 {
 
     uint64_t b0 = input[0], b1 = input[1],
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
index a7e06f905186..b81cb3a65b04 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish256Block.c
@@ -2,7 +2,7 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+void threefishEncrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
   {
 
     uint64_t b0 = input[0], b1 = input[1],
@@ -172,7 +172,7 @@ void threefishEncrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* outp
     output[3] = b3 + k1 + 18;
   }
 
-void threefishDecrypt256(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+void threefishDecrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
   {
     uint64_t b0 = input[0], b1 = input[1],
       b2 = input[2], b3 = input[3];
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
index 3cbfcd9af5c9..7eed6aeb3742 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish512Block.c
@@ -2,7 +2,7 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+void threefishEncrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
     {
 
     uint64_t b0 = input[0], b1 = input[1],
@@ -316,7 +316,7 @@ void threefishEncrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* outp
         output[7] = b7 + k7 + 18;
     }
 
-void threefishDecrypt512(ThreefishKey_t* keyCtx, uint64_t* input, uint64_t* output)
+void threefishDecrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
     {
 
     uint64_t b0 = input[0], b1 = input[1],
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index ed19ee9e3425..5cd3eb9bd9f2 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -3,7 +3,7 @@
 #include <linux/string.h>
 #include <threefishApi.h>
 
-void threefishSetKey(ThreefishKey_t* keyCtx, ThreefishSize_t stateSize,
+void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize,
                      uint64_t* keyData, uint64_t* tweak)
 {
     int keyWords = stateSize / 64;
@@ -22,7 +22,7 @@ void threefishSetKey(ThreefishKey_t* keyCtx, ThreefishSize_t stateSize,
     keyCtx->stateSize = stateSize;
 }
 
-void threefishEncryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in,
+void threefishEncryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in,
                                 uint8_t* out)
 {
     u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
@@ -33,7 +33,7 @@ void threefishEncryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in,
     Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);  /* words to bytes */
 }
 
-void threefishEncryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in,
+void threefishEncryptBlockWords(struct threefish_key* keyCtx, uint64_t* in,
                                 uint64_t* out)
 {
     switch (keyCtx->stateSize) {
@@ -49,7 +49,7 @@ void threefishEncryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in,
     }
 }
 
-void threefishDecryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in,
+void threefishDecryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in,
                                 uint8_t* out)
 {
     u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
@@ -60,7 +60,7 @@ void threefishDecryptBlockBytes(ThreefishKey_t* keyCtx, uint8_t* in,
     Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);   /* words to bytes */
 }
 
-void threefishDecryptBlockWords(ThreefishKey_t* keyCtx, uint64_t* in,
+void threefishDecryptBlockWords(struct threefish_key* keyCtx, uint64_t* in,
                                 uint64_t* out)
 {
     switch (keyCtx->stateSize) {
-- 
1.9.0
