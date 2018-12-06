Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbeLFW0h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Dec 2018 17:26:37 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>
Subject: [PATCH] crypto: adiantum - adjust some comments to match latest paper
Date: Thu,  6 Dec 2018 14:21:59 -0800
Message-Id: <20181206222159.17336-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The 2018-11-28 revision of the Adiantum paper has revised some notation:

- 'M' was replaced with 'L' (meaning "Left", for the left-hand part of
  the message) in the definition of Adiantum hashing, to avoid confusion
  with the full message
- ε-almost-∆-universal is now abbreviated as ε-∆U instead of εA∆U
- "block" is now used only to mean block cipher and Poly1305 blocks

Also, Adiantum hashing was moved from the appendix to the main paper.

To avoid confusion, update relevant comments in the code to match.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c   | 35 +++++++++++++++++++----------------
 crypto/nhpoly1305.c |  8 ++++----
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index ca27e0dc2958c..e62e34f5e389b 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -9,7 +9,7 @@
  * Adiantum is a tweakable, length-preserving encryption mode designed for fast
  * and secure disk encryption, especially on CPUs without dedicated crypto
  * instructions.  Adiantum encrypts each sector using the XChaCha12 stream
- * cipher, two passes of an ε-almost-∆-universal (εA∆U) hash function based on
+ * cipher, two passes of an ε-almost-∆-universal (ε-∆U) hash function based on
  * NH and Poly1305, and an invocation of the AES-256 block cipher on a single
  * 16-byte block.  See the paper for details:
  *
@@ -21,12 +21,12 @@
  *	- Stream cipher: XChaCha12 or XChaCha20
  *	- Block cipher: any with a 128-bit block size and 256-bit key
  *
- * This implementation doesn't currently allow other εA∆U hash functions, i.e.
+ * This implementation doesn't currently allow other ε-∆U hash functions, i.e.
  * HPolyC is not supported.  This is because Adiantum is ~20% faster than HPolyC
- * but still provably as secure, and also the εA∆U hash function of HBSH is
+ * but still provably as secure, and also the ε-∆U hash function of HBSH is
  * formally defined to take two inputs (tweak, message) which makes it difficult
  * to wrap with the crypto_shash API.  Rather, some details need to be handled
- * here.  Nevertheless, if needed in the future, support for other εA∆U hash
+ * here.  Nevertheless, if needed in the future, support for other ε-∆U hash
  * functions could be added here.
  */
 
@@ -41,7 +41,7 @@
 #include "internal.h"
 
 /*
- * Size of right-hand block of input data, in bytes; also the size of the block
+ * Size of right-hand part of input data, in bytes; also the size of the block
  * cipher's block size and the hash function's output.
  */
 #define BLOCKCIPHER_BLOCK_SIZE		16
@@ -77,7 +77,7 @@ struct adiantum_tfm_ctx {
 struct adiantum_request_ctx {
 
 	/*
-	 * Buffer for right-hand block of data, i.e.
+	 * Buffer for right-hand part of data, i.e.
 	 *
 	 *    P_L => P_M => C_M => C_R when encrypting, or
 	 *    C_R => C_M => P_M => P_L when decrypting.
@@ -93,8 +93,8 @@ struct adiantum_request_ctx {
 	bool enc; /* true if encrypting, false if decrypting */
 
 	/*
-	 * The result of the Poly1305 εA∆U hash function applied to
-	 * (message length, tweak).
+	 * The result of the Poly1305 ε-∆U hash function applied to
+	 * (bulk length, tweak)
 	 */
 	le128 header_hash;
 
@@ -213,13 +213,16 @@ static inline void le128_sub(le128 *r, const le128 *v1, const le128 *v2)
 }
 
 /*
- * Apply the Poly1305 εA∆U hash function to (message length, tweak) and save the
- * result to rctx->header_hash.
+ * Apply the Poly1305 ε-∆U hash function to (bulk length, tweak) and save the
+ * result to rctx->header_hash.  This is the calculation
  *
- * This value is reused in both the first and second hash steps.  Specifically,
- * it's added to the result of an independently keyed εA∆U hash function (for
- * equal length inputs only) taken over the message.  This gives the overall
- * Adiantum hash of the (tweak, message) pair.
+ *	H_T ← Poly1305_{K_T}(bin_{128}(|L|) || T)
+ *
+ * from the procedure in section 6.4 of the Adiantum paper.  The resulting value
+ * is reused in both the first and second hash steps.  Specifically, it's added
+ * to the result of an independently keyed ε-∆U hash function (for equal length
+ * inputs only) taken over the left-hand part (the "bulk") of the message, to
+ * give the overall Adiantum hash of the (tweak, left-hand part) pair.
  */
 static void adiantum_hash_header(struct skcipher_request *req)
 {
@@ -248,7 +251,7 @@ static void adiantum_hash_header(struct skcipher_request *req)
 	poly1305_core_emit(&state, &rctx->header_hash);
 }
 
-/* Hash the left-hand block (the "bulk") of the message using NHPoly1305 */
+/* Hash the left-hand part (the "bulk") of the message using NHPoly1305 */
 static int adiantum_hash_message(struct skcipher_request *req,
 				 struct scatterlist *sgl, le128 *digest)
 {
@@ -550,7 +553,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto out_drop_streamcipher;
 	blockcipher_alg = ictx->blockcipher_spawn.alg;
 
-	/* NHPoly1305 εA∆U hash function */
+	/* NHPoly1305 ε-∆U hash function */
 	_hash_alg = crypto_alg_mod_lookup(nhpoly1305_name,
 					  CRYPTO_ALG_TYPE_SHASH,
 					  CRYPTO_ALG_TYPE_MASK);
diff --git a/crypto/nhpoly1305.c b/crypto/nhpoly1305.c
index c8385853f699d..ec831a5594d8f 100644
--- a/crypto/nhpoly1305.c
+++ b/crypto/nhpoly1305.c
@@ -9,15 +9,15 @@
  * "NHPoly1305" is the main component of Adiantum hashing.
  * Specifically, it is the calculation
  *
- *	H_M ← Poly1305_{K_M}(NH_{K_N}(pad_{128}(M)))
+ *	H_L ← Poly1305_{K_L}(NH_{K_N}(pad_{128}(L)))
  *
- * from the procedure in section A.5 of the Adiantum paper [1].  It is an
- * ε-almost-∆-universal (εA∆U) hash function for equal-length inputs over
+ * from the procedure in section 6.4 of the Adiantum paper [1].  It is an
+ * ε-almost-∆-universal (ε-∆U) hash function for equal-length inputs over
  * Z/(2^{128}Z), where the "∆" operation is addition.  It hashes 1024-byte
  * chunks of the input with the NH hash function [2], reducing the input length
  * by 32x.  The resulting NH digests are evaluated as a polynomial in
  * GF(2^{130}-5), like in the Poly1305 MAC [3].  Note that the polynomial
- * evaluation by itself would suffice to achieve the εA∆U property; NH is used
+ * evaluation by itself would suffice to achieve the ε-∆U property; NH is used
  * for performance since it's over twice as fast as Poly1305.
  *
  * This is *not* a cryptographic hash function; do not use it as such!
-- 
2.20.0.rc2.403.gdbc3b29805-goog
