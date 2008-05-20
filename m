From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 2/3] [CRYPTO] rmd256: Fix endian problems
Date: Tue, 20 May 2008 21:49:51 +0200
Message-ID: <1211312992-6439-3-git-send-email-rueegsegger@swiss-it.ch>
References: <>
 <1211312992-6439-1-git-send-email-rueegsegger@swiss-it.ch>
 <1211312992-6439-2-git-send-email-rueegsegger@swiss-it.ch>
Cc: sebastian@breakpoint.cc, linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:51088 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315AbYETTt5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 May 2008 15:49:57 -0400
In-Reply-To: <1211312992-6439-2-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes endian issues making rmd256 work
properly on big-endian machines.

Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
---
 crypto/rmd256.c |   37 +++++++++----------------------------
 1 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 060ee81..88f2203 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -44,7 +44,7 @@ struct rmd256_ctx {
 #define F4(x, y, z) (y ^ (z & (x ^ y)))	/* z ? x : y */
 
 #define ROUND(a, b, c, d, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + (x) + (k); \
+	(a) += f((b), (c), (d)) + le32_to_cpu(x) + (k); \
 	(a) = rol32((a), (s)); \
 }
 
@@ -233,28 +233,6 @@ static void rmd256_transform(u32 *state, u32 const *in)
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
-static inline void rmd256_transform_helper(struct rmd256_ctx *ctx)
-{
-	le32_to_cpu_array(ctx->buffer, sizeof(ctx->buffer) / sizeof(u32));
-	rmd256_transform(ctx->state, ctx->buffer);
-}
-
 static void rmd256_init(struct crypto_tfm *tfm)
 {
 	struct rmd256_ctx *rctx = crypto_tfm_ctx(tfm);
@@ -291,13 +269,13 @@ static void rmd256_update(struct crypto_tfm *tfm, const u8 *data,
 	memcpy((char *)rctx->buffer + (sizeof(rctx->buffer) - avail),
 	       data, avail);
 
-	rmd256_transform_helper(rctx);
+	rmd256_transform(rctx->state, rctx->buffer);
 	data += avail;
 	len -= avail;
 
 	while (len >= sizeof(rctx->buffer)) {
 		memcpy(rctx->buffer, data, sizeof(rctx->buffer));
-		rmd256_transform_helper(rctx);
+		rmd256_transform(rctx->state, rctx->buffer);
 		data += sizeof(rctx->buffer);
 		len -= sizeof(rctx->buffer);
 	}
@@ -309,10 +287,12 @@ static void rmd256_update(struct crypto_tfm *tfm, const u8 *data,
 static void rmd256_final(struct crypto_tfm *tfm, u8 *out)
 {
 	struct rmd256_ctx *rctx = crypto_tfm_ctx(tfm);
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
@@ -323,7 +303,8 @@ static void rmd256_final(struct crypto_tfm *tfm, u8 *out)
 	rmd256_update(tfm, (const u8 *)&bits, sizeof(bits));
 
 	/* Store state in digest */
-	memcpy(out, rctx->state, sizeof(rctx->state));
+	for (i = 0; i < 8; i++)
+		dst[i] = cpu_to_le32(rctx->state[i]);
 
 	/* Wipe context */
 	memset(rctx, 0, sizeof(*rctx));
-- 
1.5.2.5

