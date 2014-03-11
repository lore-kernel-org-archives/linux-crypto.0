From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 09/22] staging: crypto: skein: use u8, u64 vice uint*_t
Date: Tue, 11 Mar 2014 21:32:41 +0000
Message-ID: <0a1edb93a5c4029f75ec25d1a665874b88e7d0af.1394570068.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22389 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbaCKVzm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:42 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skeinApi.h     |  8 ++++----
 drivers/staging/skein/include/threefishApi.h | 22 +++++++++++-----------
 drivers/staging/skein/skeinApi.c             | 22 +++++++++++-----------
 drivers/staging/skein/threefish1024Block.c   | 18 +++++++++---------
 drivers/staging/skein/threefish256Block.c    | 18 +++++++++---------
 drivers/staging/skein/threefish512Block.c    | 18 +++++++++---------
 drivers/staging/skein/threefishApi.c         | 20 ++++++++++----------
 7 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index 548c639431de..4ad294f7945d 100755
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -173,7 +173,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @return
      *     SKEIN_SUCESS of SKEIN_FAIL
      */
-    int skeinMacInit(struct skein_ctx* ctx, const uint8_t *key, size_t keyLen,
+    int skeinMacInit(struct skein_ctx* ctx, const u8 *key, size_t keyLen,
                      size_t hashBitLen);
 
     /**
@@ -188,7 +188,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @return
      *     Success or error code.
      */
-    int skeinUpdate(struct skein_ctx *ctx, const uint8_t *msg,
+    int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
                     size_t msgByteCnt);
 
     /**
@@ -204,7 +204,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      * @param msgBitCnt
      *     Length of the message in @b bits.
      */
-    int skeinUpdateBits(struct skein_ctx *ctx, const uint8_t *msg,
+    int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
                         size_t msgBitCnt);
 
     /**
@@ -222,7 +222,7 @@ OTHER DEALINGS IN THE SOFTWARE.
      *     Success or error code.
      * @see skeinReset
      */
-    int skeinFinal(struct skein_ctx* ctx, uint8_t* hash);
+    int skeinFinal(struct skein_ctx* ctx, u8* hash);
 
 /**
  * @}
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 4c1cd81f30c4..194e313b6b62 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -72,7 +72,7 @@
      * @param tweak
      *     Pointer to the two tweak words (word has 64 bits).
      */
-    void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize, uint64_t* keyData, uint64_t* tweak);
+    void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize, u64* keyData, u64* tweak);
     
     /**
      * Encrypt Threefisch block (bytes).
@@ -89,7 +89,7 @@
      * @param out
      *     Pointer to cipher buffer.
      */
-    void threefishEncryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in, uint8_t* out);
+    void threefishEncryptBlockBytes(struct threefish_key* keyCtx, u8* in, u8* out);
     
     /**
      * Encrypt Threefisch block (words).
@@ -108,7 +108,7 @@
      * @param out
      *     Pointer to cipher buffer.
      */
-    void threefishEncryptBlockWords(struct threefish_key* keyCtx, uint64_t* in, uint64_t* out);
+    void threefishEncryptBlockWords(struct threefish_key* keyCtx, u64* in, u64* out);
 
     /**
      * Decrypt Threefisch block (bytes).
@@ -125,7 +125,7 @@
      * @param out
      *     Pointer to plaintext buffer.
      */
-    void threefishDecryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in, uint8_t* out);
+    void threefishDecryptBlockBytes(struct threefish_key* keyCtx, u8* in, u8* out);
 
     /**
      * Decrypt Threefisch block (words).
@@ -144,14 +144,14 @@
      * @param out
      *     Pointer to plaintext buffer.
      */
-    void threefishDecryptBlockWords(struct threefish_key* keyCtx, uint64_t* in, uint64_t* out);
+    void threefishDecryptBlockWords(struct threefish_key* keyCtx, u64* in, u64* out);
 
-    void threefishEncrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishEncrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishEncrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishDecrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishDecrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
-    void threefishDecrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output);
+    void threefishEncrypt256(struct threefish_key* keyCtx, u64* input, u64* output);
+    void threefishEncrypt512(struct threefish_key* keyCtx, u64* input, u64* output);
+    void threefishEncrypt1024(struct threefish_key* keyCtx, u64* input, u64* output);
+    void threefishDecrypt256(struct threefish_key* keyCtx, u64* input, u64* output);
+    void threefishDecrypt512(struct threefish_key* keyCtx, u64* input, u64* output);
+    void threefishDecrypt1024(struct threefish_key* keyCtx, u64* input, u64* output);
 /**
  * @}
  */
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index ce5c5ae575e7..6bd2da0eaa5f 100755
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -42,7 +42,7 @@ int skeinInit(struct skein_ctx* ctx, size_t hashBitLen)
     int ret = SKEIN_FAIL;
     size_t Xlen = 0;
     u64*  X = NULL;
-    uint64_t treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
+    u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
     Skein_Assert(ctx, SKEIN_FAIL);
     /*
@@ -78,13 +78,13 @@ int skeinInit(struct skein_ctx* ctx, size_t hashBitLen)
     return ret;
 }
 
-int skeinMacInit(struct skein_ctx* ctx, const uint8_t *key, size_t keyLen,
+int skeinMacInit(struct skein_ctx* ctx, const u8 *key, size_t keyLen,
                  size_t hashBitLen)
 {
     int ret = SKEIN_FAIL;
     u64*  X = NULL;
     size_t Xlen = 0;
-    uint64_t treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
+    u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
     Skein_Assert(ctx, SKEIN_FAIL);
 
@@ -138,7 +138,7 @@ void skeinReset(struct skein_ctx* ctx)
     Skein_Start_New_Type(&ctx->m, MSG);
 }
 
-int skeinUpdate(struct skein_ctx *ctx, const uint8_t *msg,
+int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
                 size_t msgByteCnt)
 {
     int ret = SKEIN_FAIL;
@@ -159,7 +159,7 @@ int skeinUpdate(struct skein_ctx *ctx, const uint8_t *msg,
 
 }
 
-int skeinUpdateBits(struct skein_ctx *ctx, const uint8_t *msg,
+int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
                     size_t msgBitCnt)
 {
     /*
@@ -168,8 +168,8 @@ int skeinUpdateBits(struct skein_ctx *ctx, const uint8_t *msg,
      * arithmetic.
      */
     size_t length;
-    uint8_t mask;
-    uint8_t* up;
+    u8 mask;
+    u8* up;
 
     /* only the final Update() call is allowed do partial bytes, else assert an error */
     Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 || msgBitCnt == 0, SKEIN_FAIL);
@@ -186,20 +186,20 @@ int skeinUpdateBits(struct skein_ctx *ctx, const uint8_t *msg,
      * Skein's real partial block buffer.
      * If this layout ever changes we have to adapt this as well.
      */
-    up = (uint8_t*)ctx->m.s256.X + ctx->skeinSize / 8;
+    up = (u8*)ctx->m.s256.X + ctx->skeinSize / 8;
 
     Skein_Set_Bit_Pad_Flag(ctx->m.h);                       /* set tweak flag for the skeinFinal call */
 
     /* now "pad" the final partial byte the way NIST likes */
     length = ctx->m.h.bCnt;                                 /* get the bCnt value (same location for all block sizes) */
     Skein_assert(length != 0);                              /* internal sanity check: there IS a partial byte in the buffer! */
-    mask = (uint8_t) (1u << (7 - (msgBitCnt & 7)));         /* partial byte bit mask */
-    up[length-1]  = (uint8_t)((up[length-1] & (0-mask))|mask);   /* apply bit padding on final byte (in the buffer) */
+    mask = (u8) (1u << (7 - (msgBitCnt & 7)));         /* partial byte bit mask */
+    up[length-1]  = (u8)((up[length-1] & (0-mask))|mask);   /* apply bit padding on final byte (in the buffer) */
 
     return SKEIN_SUCCESS;
 }
 
-int skeinFinal(struct skein_ctx* ctx, uint8_t* hash)
+int skeinFinal(struct skein_ctx* ctx, u8* hash)
 {
     int ret = SKEIN_FAIL;
     Skein_Assert(ctx, SKEIN_FAIL);
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
index 738ec523406b..9e821fcdb067 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish1024Block.c
@@ -2,10 +2,10 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
+void threefishEncrypt1024(struct threefish_key* keyCtx, u64* input, u64* output)
         {
 
-    uint64_t b0 = input[0], b1 = input[1],
+    u64 b0 = input[0], b1 = input[1],
       b2 = input[2], b3 = input[3],
       b4 = input[4], b5 = input[5],
       b6 = input[6], b7 = input[7],
@@ -13,7 +13,7 @@ void threefishEncrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_
       b10 = input[10], b11 = input[11],
       b12 = input[12], b13 = input[13],
       b14 = input[14], b15 = input[15];
-    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+    u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
       k2 = keyCtx->key[2], k3 = keyCtx->key[3],
       k4 = keyCtx->key[4], k5 = keyCtx->key[5],
       k6 = keyCtx->key[6], k7 = keyCtx->key[7],
@@ -22,7 +22,7 @@ void threefishEncrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_
       k12 = keyCtx->key[12], k13 = keyCtx->key[13],
       k14 = keyCtx->key[14], k15 = keyCtx->key[15],
       k16 = keyCtx->key[16];
-    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+    u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
       t2 = keyCtx->tweak[2];
 
             b1 += k1; b0 += b1 + k0; b1 = ((b1 << 24) | (b1 >> (64 - 24))) ^ b0;
@@ -684,10 +684,10 @@ void threefishEncrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_
             output[15] = b15 + k1 + 20;
         }
 
-void threefishDecrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
+void threefishDecrypt1024(struct threefish_key* keyCtx, u64* input, u64* output)
 {
 
-    uint64_t b0 = input[0], b1 = input[1],
+    u64 b0 = input[0], b1 = input[1],
       b2 = input[2], b3 = input[3],
       b4 = input[4], b5 = input[5],
       b6 = input[6], b7 = input[7],
@@ -695,7 +695,7 @@ void threefishDecrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_
       b10 = input[10], b11 = input[11],
       b12 = input[12], b13 = input[13],
       b14 = input[14], b15 = input[15];
-    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+    u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
       k2 = keyCtx->key[2], k3 = keyCtx->key[3],
       k4 = keyCtx->key[4], k5 = keyCtx->key[5],
       k6 = keyCtx->key[6], k7 = keyCtx->key[7],
@@ -704,9 +704,9 @@ void threefishDecrypt1024(struct threefish_key* keyCtx, uint64_t* input, uint64_
       k12 = keyCtx->key[12], k13 = keyCtx->key[13],
       k14 = keyCtx->key[14], k15 = keyCtx->key[15],
       k16 = keyCtx->key[16];
-    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+    u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
       t2 = keyCtx->tweak[2];
-    uint64_t tmp;
+    u64 tmp;
 
             b0 -= k3;
             b1 -= k4;
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
index b81cb3a65b04..68ac4c50f01e 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish256Block.c
@@ -2,15 +2,15 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
+void threefishEncrypt256(struct threefish_key* keyCtx, u64* input, u64* output)
   {
 
-    uint64_t b0 = input[0], b1 = input[1],
+    u64 b0 = input[0], b1 = input[1],
       b2 = input[2], b3 = input[3];
-    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+    u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
       k2 = keyCtx->key[2], k3 = keyCtx->key[3],
       k4 = keyCtx->key[4];
-    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+    u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
       t2 = keyCtx->tweak[2];
 
     b1 += k1 + t0; b0 += b1 + k0; b1 = ((b1 << 14) | (b1 >> (64 - 14))) ^ b0;
@@ -172,17 +172,17 @@ void threefishEncrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t
     output[3] = b3 + k1 + 18;
   }
 
-void threefishDecrypt256(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
+void threefishDecrypt256(struct threefish_key* keyCtx, u64* input, u64* output)
   {
-    uint64_t b0 = input[0], b1 = input[1],
+    u64 b0 = input[0], b1 = input[1],
       b2 = input[2], b3 = input[3];
-    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+    u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
       k2 = keyCtx->key[2], k3 = keyCtx->key[3],
       k4 = keyCtx->key[4];
-    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+    u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
       t2 = keyCtx->tweak[2];
 
-    uint64_t tmp;
+    u64 tmp;
 
     b0 -= k3;
     b1 -= k4 + t0;
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
index 7eed6aeb3742..e94bb93722df 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish512Block.c
@@ -2,19 +2,19 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
+void threefishEncrypt512(struct threefish_key* keyCtx, u64* input, u64* output)
     {
 
-    uint64_t b0 = input[0], b1 = input[1],
+    u64 b0 = input[0], b1 = input[1],
       b2 = input[2], b3 = input[3],
       b4 = input[4], b5 = input[5],
       b6 = input[6], b7 = input[7];
-    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+    u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
       k2 = keyCtx->key[2], k3 = keyCtx->key[3],
       k4 = keyCtx->key[4], k5 = keyCtx->key[5],
       k6 = keyCtx->key[6], k7 = keyCtx->key[7],
       k8 = keyCtx->key[8];
-    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+    u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
       t2 = keyCtx->tweak[2];
 
         b1 += k1; b0 += b1 + k0; b1 = ((b1 << 46) | (b1 >> (64 - 46))) ^ b0;
@@ -316,22 +316,22 @@ void threefishEncrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t
         output[7] = b7 + k7 + 18;
     }
 
-void threefishDecrypt512(struct threefish_key* keyCtx, uint64_t* input, uint64_t* output)
+void threefishDecrypt512(struct threefish_key* keyCtx, u64* input, u64* output)
     {
 
-    uint64_t b0 = input[0], b1 = input[1],
+    u64 b0 = input[0], b1 = input[1],
       b2 = input[2], b3 = input[3],
       b4 = input[4], b5 = input[5],
       b6 = input[6], b7 = input[7];
-    uint64_t k0 = keyCtx->key[0], k1 = keyCtx->key[1],
+    u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
       k2 = keyCtx->key[2], k3 = keyCtx->key[3],
       k4 = keyCtx->key[4], k5 = keyCtx->key[5],
       k6 = keyCtx->key[6], k7 = keyCtx->key[7],
       k8 = keyCtx->key[8];
-    uint64_t t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
+    u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
       t2 = keyCtx->tweak[2];
 
-      uint64_t tmp;
+      u64 tmp;
 
         b0 -= k0;
         b1 -= k1;
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index 5cd3eb9bd9f2..37f96215159d 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -4,11 +4,11 @@
 #include <threefishApi.h>
 
 void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize,
-                     uint64_t* keyData, uint64_t* tweak)
+                     u64* keyData, u64* tweak)
 {
     int keyWords = stateSize / 64;
     int i;
-    uint64_t parity = KeyScheduleConst;
+    u64 parity = KeyScheduleConst;
 
     keyCtx->tweak[0] = tweak[0];
     keyCtx->tweak[1] = tweak[1];
@@ -22,8 +22,8 @@ void threefishSetKey(struct threefish_key* keyCtx, enum threefish_size stateSize
     keyCtx->stateSize = stateSize;
 }
 
-void threefishEncryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in,
-                                uint8_t* out)
+void threefishEncryptBlockBytes(struct threefish_key* keyCtx, u8* in,
+                                u8* out)
 {
     u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
     u64 cipher[SKEIN_MAX_STATE_WORDS];
@@ -33,8 +33,8 @@ void threefishEncryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in,
     Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);  /* words to bytes */
 }
 
-void threefishEncryptBlockWords(struct threefish_key* keyCtx, uint64_t* in,
-                                uint64_t* out)
+void threefishEncryptBlockWords(struct threefish_key* keyCtx, u64* in,
+                                u64* out)
 {
     switch (keyCtx->stateSize) {
         case Threefish256:
@@ -49,8 +49,8 @@ void threefishEncryptBlockWords(struct threefish_key* keyCtx, uint64_t* in,
     }
 }
 
-void threefishDecryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in,
-                                uint8_t* out)
+void threefishDecryptBlockBytes(struct threefish_key* keyCtx, u8* in,
+                                u8* out)
 {
     u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
     u64 cipher[SKEIN_MAX_STATE_WORDS];
@@ -60,8 +60,8 @@ void threefishDecryptBlockBytes(struct threefish_key* keyCtx, uint8_t* in,
     Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);   /* words to bytes */
 }
 
-void threefishDecryptBlockWords(struct threefish_key* keyCtx, uint64_t* in,
-                                uint64_t* out)
+void threefishDecryptBlockWords(struct threefish_key* keyCtx, u64* in,
+                                u64* out)
 {
     switch (keyCtx->stateSize) {
         case Threefish256:
-- 
1.9.0
