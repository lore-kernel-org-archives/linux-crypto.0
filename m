From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 09/21] staging: crypto: skein: fixup pointer whitespace
Date: Mon, 24 Mar 2014 01:49:06 +0000
Message-ID: <e58ad8d9d6ba701b34b13cf03df014db9a85194a.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33060 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751405AbaCXBtq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:46 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein.h        | 18 +++++++++---------
 drivers/staging/skein/include/skeinApi.h     | 10 +++++-----
 drivers/staging/skein/include/threefishApi.h | 22 +++++++++++-----------
 drivers/staging/skein/skeinApi.c             | 18 +++++++++---------
 drivers/staging/skein/threefish1024Block.c   |  4 ++--
 drivers/staging/skein/threefish256Block.c    |  4 ++--
 drivers/staging/skein/threefish512Block.c    |  4 ++--
 drivers/staging/skein/threefishApi.c         | 20 ++++++++++----------
 8 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 77b712e73253..b7cd6c0cef2f 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -100,9 +100,9 @@ int  Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg, size_t msgByteCn
 int  Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg, size_t msgByteCnt);
 int  Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg, size_t msgByteCnt);
 
-int  Skein_256_Final (struct skein_256_ctx *ctx, u8 * hashVal);
-int  Skein_512_Final (struct skein_512_ctx *ctx, u8 * hashVal);
-int  Skein1024_Final (struct skein1024_ctx *ctx, u8 * hashVal);
+int  Skein_256_Final (struct skein_256_ctx *ctx, u8 *hashVal);
+int  Skein_512_Final (struct skein_512_ctx *ctx, u8 *hashVal);
+int  Skein1024_Final (struct skein1024_ctx *ctx, u8 *hashVal);
 
 /*
 **   Skein APIs for "extended" initialization: MAC keys, tree hashing.
@@ -127,17 +127,17 @@ int  Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen, u64 treeInf
 **      Final_Pad:  pad, do final block, but no OUTPUT type
 **      Output:     do just the output stage
 */
-int  Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 * hashVal);
-int  Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 * hashVal);
-int  Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 * hashVal);
+int  Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal);
+int  Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal);
+int  Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal);
 
 #ifndef SKEIN_TREE_HASH
 #define SKEIN_TREE_HASH (1)
 #endif
 #if  SKEIN_TREE_HASH
-int  Skein_256_Output   (struct skein_256_ctx *ctx, u8 * hashVal);
-int  Skein_512_Output   (struct skein_512_ctx *ctx, u8 * hashVal);
-int  Skein1024_Output   (struct skein1024_ctx *ctx, u8 * hashVal);
+int  Skein_256_Output   (struct skein_256_ctx *ctx, u8 *hashVal);
+int  Skein_512_Output   (struct skein_512_ctx *ctx, u8 *hashVal);
+int  Skein1024_Output   (struct skein1024_ctx *ctx, u8 *hashVal);
 #endif
 
 /*****************************************************************
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index 4ad294f7945d..2c52797918cf 100755
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -123,7 +123,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @return
      *     SKEIN_SUCESS of SKEIN_FAIL
      */
-    int skeinCtxPrepare(struct skein_ctx* ctx, enum skein_size size);
+    int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size);
 
     /**
      * Initialize a Skein context.
@@ -139,7 +139,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      *     SKEIN_SUCESS of SKEIN_FAIL
      * @see skeinReset
      */
-    int skeinInit(struct skein_ctx* ctx, size_t hashBitLen);
+    int skeinInit(struct skein_ctx *ctx, size_t hashBitLen);
 
     /**
      * Resets a Skein context for further use.
@@ -151,7 +151,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @param ctx
      *     Pointer to a pre-initialized Skein MAC context
      */
-    void skeinReset(struct skein_ctx* ctx);
+    void skeinReset(struct skein_ctx *ctx);
     
     /**
      * Initializes a Skein context for MAC usage.
@@ -173,7 +173,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @return
      *     SKEIN_SUCESS of SKEIN_FAIL
      */
-    int skeinMacInit(struct skein_ctx* ctx, const u8 *key, size_t keyLen,
+    int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
                      size_t hashBitLen);
 
     /**
@@ -222,7 +222,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      *     Success or error code.
      * @see skeinReset
      */
-    int skeinFinal(struct skein_ctx* ctx, u8* hash);
+    int skeinFinal(struct skein_ctx *ctx, u8 *hash);
 
 /**
  * @}
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 194e313b6b62..1f9e6e14f50b 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -72,7 +72,7 @@
      * @param tweak
      *     Pointer to the two tweak words (word has 64 bits).
      */
-    void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize, u64* keyData, u64* tweak);
+    void threefishSetKey(struct threefish_key *keyCtx, enum threefish_size stateSize, u64 *keyData, u64 *tweak);
     
     /**
      * Encrypt Threefisch block (bytes).
@@ -89,7 +89,7 @@
      * @param out
      *     Pointer to cipher buffer.
      */
-    void threefishEncryptBlockBytes(struct threefish_key* keyCtx, u8* in, u8* out);
+    void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
     
     /**
      * Encrypt Threefisch block (words).
@@ -108,7 +108,7 @@
      * @param out
      *     Pointer to cipher buffer.
      */
-    void threefishEncryptBlockWords(struct threefish_key* keyCtx, u64* in, u64* out);
+    void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in, u64 *out);
 
     /**
      * Decrypt Threefisch block (bytes).
@@ -125,7 +125,7 @@
      * @param out
      *     Pointer to plaintext buffer.
      */
-    void threefishDecryptBlockBytes(struct threefish_key* keyCtx, u8* in, u8* out);
+    void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
 
     /**
      * Decrypt Threefisch block (words).
@@ -144,14 +144,14 @@
      * @param out
      *     Pointer to plaintext buffer.
      */
-    void threefishDecryptBlockWords(struct threefish_key* keyCtx, u64* in, u64* out);
+    void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in, u64 *out);
 
-    void threefishEncrypt256(struct threefish_key* keyCtx, u64* input, u64* output);
-    void threefishEncrypt512(struct threefish_key* keyCtx, u64* input, u64* output);
-    void threefishEncrypt1024(struct threefish_key* keyCtx, u64* input, u64* output);
-    void threefishDecrypt256(struct threefish_key* keyCtx, u64* input, u64* output);
-    void threefishDecrypt512(struct threefish_key* keyCtx, u64* input, u64* output);
-    void threefishDecrypt1024(struct threefish_key* keyCtx, u64* input, u64* output);
+    void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
+    void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
+    void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output);
+    void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
+    void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
+    void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output);
 /**
  * @}
  */
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index 6bd2da0eaa5f..df92806c4ec4 100755
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -27,7 +27,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 #include <linux/string.h>
 #include <skeinApi.h>
 
-int skeinCtxPrepare(struct skein_ctx* ctx, enum skein_size size)
+int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size)
 {
     Skein_Assert(ctx && size, SKEIN_FAIL);
 
@@ -37,11 +37,11 @@ int skeinCtxPrepare(struct skein_ctx* ctx, enum skein_size size)
     return SKEIN_SUCCESS;
 }
 
-int skeinInit(struct skein_ctx* ctx, size_t hashBitLen)
+int skeinInit(struct skein_ctx *ctx, size_t hashBitLen)
 {
     int ret = SKEIN_FAIL;
     size_t Xlen = 0;
-    u64*  X = NULL;
+    u64 *X = NULL;
     u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
     Skein_Assert(ctx, SKEIN_FAIL);
@@ -78,11 +78,11 @@ int skeinInit(struct skein_ctx* ctx, size_t hashBitLen)
     return ret;
 }
 
-int skeinMacInit(struct skein_ctx* ctx, const u8 *key, size_t keyLen,
+int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
                  size_t hashBitLen)
 {
     int ret = SKEIN_FAIL;
-    u64*  X = NULL;
+    u64 *X = NULL;
     size_t Xlen = 0;
     u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
@@ -119,10 +119,10 @@ int skeinMacInit(struct skein_ctx* ctx, const u8 *key, size_t keyLen,
     return ret;
 }
 
-void skeinReset(struct skein_ctx* ctx)
+void skeinReset(struct skein_ctx *ctx)
 {
     size_t Xlen = 0;
-    u64*  X = NULL;
+    u64 *X = NULL;
 
     /*
      * The following two lines rely of the fact that the real Skein contexts are
@@ -169,7 +169,7 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
      */
     size_t length;
     u8 mask;
-    u8* up;
+    u8 *up;
 
     /* only the final Update() call is allowed do partial bytes, else assert an error */
     Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 || msgBitCnt == 0, SKEIN_FAIL);
@@ -199,7 +199,7 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
     return SKEIN_SUCCESS;
 }
 
-int skeinFinal(struct skein_ctx* ctx, u8* hash)
+int skeinFinal(struct skein_ctx *ctx, u8 *hash)
 {
     int ret = SKEIN_FAIL;
     Skein_Assert(ctx, SKEIN_FAIL);
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
index 9e821fcdb067..e3be37ea8024 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish1024Block.c
@@ -2,7 +2,7 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt1024(struct threefish_key* keyCtx, u64* input, u64* output)
+void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
         {
 
     u64 b0 = input[0], b1 = input[1],
@@ -684,7 +684,7 @@ void threefishEncrypt1024(struct threefish_key* keyCtx, u64* input, u64* output)
             output[15] = b15 + k1 + 20;
         }
 
-void threefishDecrypt1024(struct threefish_key* keyCtx, u64* input, u64* output)
+void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
 {
 
     u64 b0 = input[0], b1 = input[1],
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
index 68ac4c50f01e..09ea5099bc76 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish256Block.c
@@ -2,7 +2,7 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt256(struct threefish_key* keyCtx, u64* input, u64* output)
+void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
   {
 
     u64 b0 = input[0], b1 = input[1],
@@ -172,7 +172,7 @@ void threefishEncrypt256(struct threefish_key* keyCtx, u64* input, u64* output)
     output[3] = b3 + k1 + 18;
   }
 
-void threefishDecrypt256(struct threefish_key* keyCtx, u64* input, u64* output)
+void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
   {
     u64 b0 = input[0], b1 = input[1],
       b2 = input[2], b3 = input[3];
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
index e94bb93722df..5262f5a8f21b 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish512Block.c
@@ -2,7 +2,7 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt512(struct threefish_key* keyCtx, u64* input, u64* output)
+void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
     {
 
     u64 b0 = input[0], b1 = input[1],
@@ -316,7 +316,7 @@ void threefishEncrypt512(struct threefish_key* keyCtx, u64* input, u64* output)
         output[7] = b7 + k7 + 18;
     }
 
-void threefishDecrypt512(struct threefish_key* keyCtx, u64* input, u64* output)
+void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
     {
 
     u64 b0 = input[0], b1 = input[1],
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index 37f96215159d..53f46f6cb9ca 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -3,8 +3,8 @@
 #include <linux/string.h>
 #include <threefishApi.h>
 
-void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize,
-                     u64* keyData, u64* tweak)
+void threefishSetKey(struct threefish_key *keyCtx, enum threefish_size stateSize,
+                     u64 *keyData, u64 *tweak)
 {
     int keyWords = stateSize / 64;
     int i;
@@ -22,8 +22,8 @@ void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize
     keyCtx->stateSize = stateSize;
 }
 
-void threefishEncryptBlockBytes(struct threefish_key* keyCtx, u8* in,
-                                u8* out)
+void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
+                                u8 *out)
 {
     u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
     u64 cipher[SKEIN_MAX_STATE_WORDS];
@@ -33,8 +33,8 @@ void threefishEncryptBlockBytes(struct threefish_key* keyCtx, u8* in,
     Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);  /* words to bytes */
 }
 
-void threefishEncryptBlockWords(struct threefish_key* keyCtx, u64* in,
-                                u64* out)
+void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
+                                u64 *out)
 {
     switch (keyCtx->stateSize) {
         case Threefish256:
@@ -49,8 +49,8 @@ void threefishEncryptBlockWords(struct threefish_key* keyCtx, u64* in,
     }
 }
 
-void threefishDecryptBlockBytes(struct threefish_key* keyCtx, u8* in,
-                                u8* out)
+void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
+                                u8 *out)
 {
     u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
     u64 cipher[SKEIN_MAX_STATE_WORDS];
@@ -60,8 +60,8 @@ void threefishDecryptBlockBytes(struct threefish_key* keyCtx, u8* in,
     Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);   /* words to bytes */
 }
 
-void threefishDecryptBlockWords(struct threefish_key* keyCtx, u64* in,
-                                u64* out)
+void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
+                                u64 *out)
 {
     switch (keyCtx->stateSize) {
         case Threefish256:
-- 
1.9.1
