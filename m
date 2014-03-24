From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 13/21] staging: crypto: skein: remove trailing whitespace
Date: Mon, 24 Mar 2014 01:49:10 +0000
Message-ID: <f2ef44f292ff3a5e7525f9bb29cb6135eca3d297.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30432 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaCXBto (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:44 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/include/skein.h        | 16 +++++-----
 drivers/staging/skein/include/skeinApi.h     | 44 ++++++++++++++--------------
 drivers/staging/skein/include/threefishApi.h | 40 ++++++++++++-------------
 drivers/staging/skein/skeinBlockNo3F.c       |  6 ++--
 drivers/staging/skein/skein_block.c          | 20 ++++++-------
 5 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 906bcee41c39..dd9a210cf5dd 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -9,7 +9,7 @@
 ** This algorithm and source code is released to the public domain.
 **
 ***************************************************************************
-** 
+**
 ** The following compile-time switches may be defined to control some
 ** tradeoffs between speed, code size, error checking, and security.
 **
@@ -20,8 +20,8 @@
 **                            [default: no callouts (no overhead)]
 **
 **  SKEIN_ERR_CHECK        -- how error checking is handled inside Skein
-**                            code. If not defined, most error checking 
-**                            is disabled (for performance). Otherwise, 
+**                            code. If not defined, most error checking
+**                            is disabled (for performance). Otherwise,
 **                            the switch value is interpreted as:
 **                                0: use assert()      to flag errors
 **                                1: return SKEIN_FAIL to flag errors
@@ -109,12 +109,12 @@ int  Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal);
 **   After an InitExt() call, just use Update/Final calls as with Init().
 **
 **   Notes: Same parameters as _Init() calls, plus treeInfo/key/keyBytes.
-**          When keyBytes == 0 and treeInfo == SKEIN_SEQUENTIAL, 
+**          When keyBytes == 0 and treeInfo == SKEIN_SEQUENTIAL,
 **              the results of InitExt() are identical to calling Init().
 **          The function Init() may be called once to "precompute" the IV for
 **              a given hashBitLen value, then by saving a copy of the context
 **              the IV computation may be avoided in later calls.
-**          Similarly, the function InitExt() may be called once per MAC key 
+**          Similarly, the function InitExt() may be called once per MAC key
 **              to precompute the MAC IV, then a copy of the context saved and
 **              reused for each new MAC computation.
 **/
@@ -142,7 +142,7 @@ int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 
 /*****************************************************************
 ** "Internal" Skein definitions
-**    -- not needed for sequential hashing API, but will be 
+**    -- not needed for sequential hashing API, but will be
 **           helpful for other uses of Skein (e.g., tree hash mode).
 **    -- included here so that they can be shared between
 **           reference and optimized code.
@@ -269,8 +269,8 @@ int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
 /*****************************************************************
 ** Skein block function constants (shared across Ref and Opt code)
 ******************************************************************/
-enum    
-	{   
+enum
+	{
 	    /* Skein_256 round rotation constants */
 	R_256_0_0 = 14, R_256_0_1 = 16,
 	R_256_1_0 = 52, R_256_1_1 = 57,
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index 0d7d59eff460..ace931a67c23 100644
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -36,46 +36,46 @@ OTHER DEALINGS IN THE SOFTWARE.
  * of Skein. The design and the way to use the functions follow the openSSL
  * design but at the same time take care of some Skein specific behaviour
  * and possibilities.
- * 
+ *
  * The functions enable applications to create a normal Skein hashes and
  * message authentication codes (MAC).
- * 
+ *
  * Using these functions is simple and straight forward:
- * 
+ *
  * @code
- * 
+ *
  * #include <skeinApi.h>
- * 
+ *
  * ...
  * struct skein_ctx ctx;             // a Skein hash or MAC context
- * 
+ *
  * // prepare context, here for a Skein with a state size of 512 bits.
  * skeinCtxPrepare(&ctx, Skein512);
- * 
+ *
  * // Initialize the context to set the requested hash length in bits
  * // here request a output hash size of 31 bits (Skein supports variable
  * // output sizes even very strange sizes)
  * skeinInit(&ctx, 31);
- * 
+ *
  * // Now update Skein with any number of message bits. A function that
  * // takes a number of bytes is also available.
  * skeinUpdateBits(&ctx, message, msgLength);
- * 
+ *
  * // Now get the result of the Skein hash. The output buffer must be
  * // large enough to hold the request number of output bits. The application
  * // may now extract the bits.
  * skeinFinal(&ctx, result);
  * ...
  * @endcode
- * 
+ *
  * An application may use @c skeinReset to reset a Skein context and use
  * it for creation of another hash with the same Skein state size and output
  * bit length. In this case the API implementation restores some internal
  * internal state data and saves a full Skein initialization round.
- * 
- * To create a MAC the application just uses @c skeinMacInit instead of 
+ *
+ * To create a MAC the application just uses @c skeinMacInit instead of
  * @c skeinInit. All other functions calls remain the same.
- * 
+ *
  */
 
 #include <linux/types.h>
@@ -111,7 +111,7 @@ struct skein_ctx {
 
 /**
  * Prepare a Skein context.
- * 
+ *
  * An application must call this function before it can use the Skein
  * context. The functions clears memory and initializes size dependent
  * variables.
@@ -128,7 +128,7 @@ int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size);
 /**
  * Initialize a Skein context.
  *
- * Initializes the context with this data and saves the resulting Skein 
+ * Initializes the context with this data and saves the resulting Skein
  * state variables for further use.
  *
  * @param ctx
@@ -143,11 +143,11 @@ int skeinInit(struct skein_ctx *ctx, size_t hashBitLen);
 
 /**
  * Resets a Skein context for further use.
- * 
- * Restores the saved chaining variables to reset the Skein context. 
- * Thus applications can reuse the same setup to  process several 
+ *
+ * Restores the saved chaining variables to reset the Skein context.
+ * Thus applications can reuse the same setup to  process several
  * messages. This saves a complete Skein initialization cycle.
- * 
+ *
  * @param ctx
  *     Pointer to a pre-initialized Skein MAC context
  */
@@ -155,8 +155,8 @@ void skeinReset(struct skein_ctx *ctx);
 
 /**
  * Initializes a Skein context for MAC usage.
- * 
- * Initializes the context with this data and saves the resulting Skein 
+ *
+ * Initializes the context with this data and saves the resulting Skein
  * state variables for further use.
  *
  * Applications call the normal Skein functions to update the MAC and
@@ -209,7 +209,7 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
 
 /**
  * Finalize Skein and return the hash.
- * 
+ *
  * Before an application can reuse a Skein setup the application must
  * reset the Skein context.
  *
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 199257e37813..5d92bbff8c9f 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -8,14 +8,14 @@
  * @{
  *
  * This API and the functions that implement this API simplify the usage
- * of the Threefish cipher. The design and the way to use the functions 
+ * of the Threefish cipher. The design and the way to use the functions
  * follow the openSSL design but at the same time take care of some Threefish
  * specific behaviour and possibilities.
  *
  * These are the low level functions that deal with Threefisch blocks only.
- * Implementations for cipher modes such as ECB, CFB, or CBC may use these 
+ * Implementations for cipher modes such as ECB, CFB, or CBC may use these
  * functions.
- * 
+ *
 @code
     // Threefish cipher context data
     struct threefish_key keyCtx;
@@ -44,7 +44,7 @@ enum threefish_size {
 
 /**
  * Context for Threefish key and tweak words.
- * 
+ *
  * This structure was setup with some know-how of the internal
  * Skein structures, in particular ordering of header and size dependent
  * variables. If Skein implementation changes this, the adapt these
@@ -58,10 +58,10 @@ struct threefish_key {
 
 /**
  * Set Threefish key and tweak data.
- * 
+ *
  * This function sets the key and tweak data for the Threefish cipher of
  * the given size. The key data must have the same length (number of bits)
- * as the state size 
+ * as the state size
  *
  * @param keyCtx
  *     Pointer to a Threefish key structure.
@@ -76,12 +76,12 @@ void threefishSetKey(struct threefish_key *keyCtx, enum threefish_size stateSize
 
 /**
  * Encrypt Threefisch block (bytes).
- * 
- * The buffer must have at least the same length (number of bits) aas the 
+ *
+ * The buffer must have at least the same length (number of bits) aas the
  * state size for this key. The function uses the first @c stateSize bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
- * 
+ *
  * @param keyCtx
  *     Pointer to a Threefish key structure.
  * @param in
@@ -93,14 +93,14 @@ void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
 
 /**
  * Encrypt Threefisch block (words).
- * 
- * The buffer must have at least the same length (number of bits) aas the 
+ *
+ * The buffer must have at least the same length (number of bits) aas the
  * state size for this key. The function uses the first @c stateSize bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
- * 
+ *
  * The wordsize ist set to 64 bits.
- * 
+ *
  * @param keyCtx
  *     Pointer to a Threefish key structure.
  * @param in
@@ -112,12 +112,12 @@ void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in, u64 *out)
 
 /**
  * Decrypt Threefisch block (bytes).
- * 
- * The buffer must have at least the same length (number of bits) aas the 
+ *
+ * The buffer must have at least the same length (number of bits) aas the
  * state size for this key. The function uses the first @c stateSize bits
  * of the input buffer, decrypts them and stores the result in the output
  * buffer
- * 
+ *
  * @param keyCtx
  *     Pointer to a Threefish key structure.
  * @param in
@@ -129,14 +129,14 @@ void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
 
 /**
  * Decrypt Threefisch block (words).
- * 
- * The buffer must have at least the same length (number of bits) aas the 
+ *
+ * The buffer must have at least the same length (number of bits) aas the
  * state size for this key. The function uses the first @c stateSize bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
- * 
+ *
  * The wordsize ist set to 64 bits.
- * 
+ *
  * @param keyCtx
  *     Pointer to a Threefish key structure.
  * @param in
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 3c2878c966e1..376cd63d8f83 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -29,7 +29,7 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 			carry += words[i];
 			words[i] = carry;
 			carry >>= 32;
-		}        
+		}
 		tweak[0] = words[0] & 0xffffffffL;
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
@@ -79,7 +79,7 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 			carry += words[i];
 			words[i] = carry;
 			carry >>= 32;
-		}        
+		}
 		tweak[0] = words[0] & 0xffffffffL;
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
@@ -133,7 +133,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 			carry += words[i];
 			words[i] = carry;
 			carry >>= 32;
-		}        
+		}
 		tweak[0] = words[0] & 0xffffffffL;
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index bb36860fafdf..d315f547feae 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -28,7 +28,7 @@
 #define BLK_BITS        (WCNT*64)               /* some useful definitions for code here */
 #define KW_TWK_BASE     (0)
 #define KW_KEY_BASE     (3)
-#define ks              (kw + KW_KEY_BASE)                
+#define ks              (kw + KW_KEY_BASE)
 #define ts              (kw + KW_TWK_BASE)
 
 #ifdef SKEIN_DEBUG
@@ -76,7 +76,7 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 		ts[0] += byteCntAdd;                    /* update processed length */
 
 		/* precompute the key schedule for this block */
-		ks[0] = ctx->X[0];     
+		ks[0] = ctx->X[0];
 		ks[1] = ctx->X[1];
 		ks[2] = ctx->X[2];
 		ks[3] = ctx->X[3];
@@ -103,7 +103,7 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
 	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
 
-#if SKEIN_UNROLL_256 == 0                       
+#if SKEIN_UNROLL_256 == 0
 #define R256(p0, p1, p2, p3, ROT, rNum)           /* fully unrolled */   \
 	Round256(p0, p1, p2, p3, ROT, rNum)                                  \
 	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
@@ -129,8 +129,8 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr, size_t
 	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
 
 	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)  /* loop thru it */
-#endif  
-		{    
+#endif
+		{
 #define R256_8_rounds(R)                  \
 		R256(0, 1, 2, 3, R_256_0, 8 * (R) + 1);  \
 		R256(0, 3, 2, 1, R_256_1, 8 * (R) + 2);  \
@@ -270,7 +270,7 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t
 		ks[5] = ctx->X[5];
 		ks[6] = ctx->X[6];
 		ks[7] = ctx->X[7];
-		ks[8] = ks[0] ^ ks[1] ^ ks[2] ^ ks[3] ^ 
+		ks[8] = ks[0] ^ ks[1] ^ ks[2] ^ ks[3] ^
 			ks[4] ^ ks[5] ^ ks[6] ^ ks[7] ^ SKEIN_KS_PARITY;
 
 		ts[2] = ts[0] ^ ts[1];
@@ -298,7 +298,7 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr, size_t
 		X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4; \
 		X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6; \
 
-#if SKEIN_UNROLL_512 == 0                       
+#if SKEIN_UNROLL_512 == 0
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)      /* unrolled */  \
 		Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum)                      \
 		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
@@ -529,7 +529,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t
 		X##pC += X##pD; X##pD = RotL_64(X##pD, ROT##_6); X##pD ^= X##pC;   \
 		X##pE += X##pF; X##pF = RotL_64(X##pF, ROT##_7); X##pF ^= X##pE;   \
 
-#if SKEIN_UNROLL_1024 == 0                      
+#if SKEIN_UNROLL_1024 == 0
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
 		Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
 		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, Xptr);
@@ -551,7 +551,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t
 		X13   += ks[((R) + 14) % 17] + ts[((R) + 1) % 3];                   \
 		X14   += ks[((R) + 15) % 17] + ts[((R) + 2) % 3];                   \
 		X15   += ks[((R) + 16) % 17] +     (R) + 1;                         \
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); 
+		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
 #else                                       /* looping version */
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
 		Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, ROT, rn) \
@@ -579,7 +579,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, size_t
 		Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
 
 		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)    /* loop thru it */
-#endif  
+#endif
 		{
 #define R1024_8_rounds(R)    /* do 8 full rounds */                               \
 			R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, R1024_0, 8*(R) + 1); \
-- 
1.9.1
