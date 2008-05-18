From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH] [CRYPTO] rmd128: Fix endian problems
Date: Sun, 18 May 2008 23:35:55 +0200
Message-ID: <12111465553916-git-send-email-rueegsegger@swiss-it.ch>
References: <20080517081003.GA19540@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, linux-crypto@ml.breakpoint.cc,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2437 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYERVgA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 May 2008 17:36:00 -0400
In-Reply-To: <20080517081003.GA19540@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch is based on Sebastian Siewior's patch and
fixes endian issues making rmd128 work properly on
big-endian machines.


Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
---

I put the le32_to_cpu call in the ROUND-define so code-size is smaller
compared to Sebastians patch. I also removed the three now obsolete
functions (le32_to_cpu_array, cpu_to_le32_array and rmd_transform_helper),
which makes the code smaller.
The other changes make rmd128_final more "sha1-like".

I will fix the other RIPEMD modules once consensus is reached on how to
fix the endian issues for rmd128.

Sebastian, would you be so kind to test this patch on PowerPC?

crypto/rmd128.c |   37 +++++++++----------------------------
 1 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 146a167..6125a4d 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -43,7 +43,7 @@ struct rmd128_ctx {
 #define F4(x, y, z) (y ^ (z & (x ^ y)))	/* z ? x : y */
 
 #define ROUND(a, b, c, d, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + (x) + (k); \
+	(a) += f((b), (c), (d)) + le32_to_cpu(x) + (k); \
 	(a) = rol32((a), (s)); \
 }
 
@@ -217,28 +217,6 @@ static void rmd128_transform(u32 *state, u32 const *in)
 	return;
 }
 
-static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
-{
-	while (words--) {
-		le32_to_cpus(buf);
-		buf++;
-	}
-}
-
-static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
-{
-	while (words--) {
-		cpu_to_le32s(buf);
-		buf++;
-	}
-}
-
-static inline void rmd128_transform_helper(struct rmd128_ctx *ctx)
-{
-	le32_to_cpu_array(ctx->buffer, sizeof(ctx->buffer) / sizeof(u32));
-	rmd128_transform(ctx->state, ctx->buffer);
-}
-
 static void rmd128_init(struct crypto_tfm *tfm)
 {
 	struct rmd128_ctx *rctx = crypto_tfm_ctx(tfm);
@@ -271,13 +249,13 @@ static void rmd128_update(struct crypto_tfm *tfm, const u8 *data,
 	memcpy((char *)rctx->buffer + (sizeof(rctx->buffer) - avail),
 	       data, avail);
 
-	rmd128_transform_helper(rctx);
+	rmd128_transform(rctx->state, rctx->buffer);
 	data += avail;
 	len -= avail;
 
 	while (len >= sizeof(rctx->buffer)) {
 		memcpy(rctx->buffer, data, sizeof(rctx->buffer));
-		rmd128_transform_helper(rctx);
+		rmd128_transform(rctx->state, rctx->buffer);
 		data += sizeof(rctx->buffer);
 		len -= sizeof(rctx->buffer);
 	}
@@ -289,10 +267,12 @@ static void rmd128_update(struct crypto_tfm *tfm, const u8 *data,
 static void rmd128_final(struct crypto_tfm *tfm, u8 *out)
 {
 	struct rmd128_ctx *rctx = crypto_tfm_ctx(tfm);
-	u32 index, padlen;
+	u32 i, index, padlen;
 	u64 bits;
+	u32 *dst = (u32 *)out;
 	static const u8 padding[64] = { 0x80, };
-	bits = rctx->byte_count << 3;
+
+	bits = cpu_to_le64(rctx->byte_count << 3);
 
 	/* Pad out to 56 mod 64 */
 	index = rctx->byte_count & 0x3f;
@@ -303,7 +283,8 @@ static void rmd128_final(struct crypto_tfm *tfm, u8 *out)
 	rmd128_update(tfm, (const u8 *)&bits, sizeof(bits));
 
 	/* Store state in digest */
-	memcpy(out, rctx->state, sizeof(rctx->state));
+	for (i = 0; i < 4; i++)
+		dst[i] = cpu_to_le32(rctx->state[i]);
 
 	/* Wipe context */
 	memset(rctx, 0, sizeof(*rctx));
-- 
1.5.2.5

