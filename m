From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 16/16] crypto/x86: move SHA-384/512 SSSE3 implementation to base layer
Date: Tue,  7 Apr 2015 10:52:04 +0200
Message-ID: <1428396724-19962-17-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32872 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbbDGIxD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:53:03 -0400
Received: by wgin8 with SMTP id n8so48691330wgi.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:53:02 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha512_ssse3_glue.c | 193 +++++++-----------------------------
 1 file changed, 36 insertions(+), 157 deletions(-)

diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 0b6af26832bf..4daa27a5d347 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -34,7 +34,7 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-#include <asm/byteorder.h>
+#include <crypto/sha512_base.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
@@ -54,183 +54,61 @@ asmlinkage void sha512_transform_rorx(const char *data, u64 *digest,
 
 static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);
 
-
-static int sha512_ssse3_init(struct shash_desc *desc)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA512_H0;
-	sctx->state[1] = SHA512_H1;
-	sctx->state[2] = SHA512_H2;
-	sctx->state[3] = SHA512_H3;
-	sctx->state[4] = SHA512_H4;
-	sctx->state[5] = SHA512_H5;
-	sctx->state[6] = SHA512_H6;
-	sctx->state[7] = SHA512_H7;
-	sctx->count[0] = sctx->count[1] = 0;
-
-	return 0;
-}
-
-static int __sha512_ssse3_update(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, unsigned int partial)
+static void sha512_ssse3_block_fn(int blocks, u8 const *src, u64 *state,
+				  const u8 *head, void *p)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-	unsigned int done = 0;
-
-	sctx->count[0] += len;
-	if (sctx->count[0] < len)
-		sctx->count[1]++;
-
-	if (partial) {
-		done = SHA512_BLOCK_SIZE - partial;
-		memcpy(sctx->buf + partial, data, done);
-		sha512_transform_asm(sctx->buf, sctx->state, 1);
-	}
-
-	if (len - done >= SHA512_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA512_BLOCK_SIZE;
-
-		sha512_transform_asm(data + done, sctx->state, (u64) rounds);
-
-		done += rounds * SHA512_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buf, data + done, len - done);
-
-	return 0;
+	if (head)
+		sha512_transform_asm(head, state, 1);
+	if (blocks)
+		sha512_transform_asm(src, state, blocks);
 }
 
 static int sha512_ssse3_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count[0] % SHA512_BLOCK_SIZE;
-	int res;
-
-	/* Handle the fast case right here */
-	if (partial + len < SHA512_BLOCK_SIZE) {
-		sctx->count[0] += len;
-		if (sctx->count[0] < len)
-			sctx->count[1]++;
-		memcpy(sctx->buf + partial, data, len);
-
-		return 0;
-	}
-
-	if (!irq_fpu_usable()) {
-		res = crypto_sha512_update(desc, data, len);
-	} else {
-		kernel_fpu_begin();
-		res = __sha512_ssse3_update(desc, data, len, partial);
-		kernel_fpu_end();
-	}
-
-	return res;
-}
-
-
-/* Add padding and return the message digest. */
-static int sha512_ssse3_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be64 *dst = (__be64 *)out;
-	__be64 bits[2];
-	static const u8 padding[SHA512_BLOCK_SIZE] = { 0x80, };
-
-	/* save number of bits */
-	bits[1] = cpu_to_be64(sctx->count[0] << 3);
-	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
-
-	/* Pad out to 112 mod 128 and append length */
-	index = sctx->count[0] & 0x7f;
-	padlen = (index < 112) ? (112 - index) : ((128+112) - index);
-
-	if (!irq_fpu_usable()) {
-		crypto_sha512_update(desc, padding, padlen);
-		crypto_sha512_update(desc, (const u8 *)&bits, sizeof(bits));
-	} else {
-		kernel_fpu_begin();
-		/* We need to fill a whole block for __sha512_ssse3_update() */
-		if (padlen <= 112) {
-			sctx->count[0] += padlen;
-			if (sctx->count[0] < padlen)
-				sctx->count[1]++;
-			memcpy(sctx->buf + index, padding, padlen);
-		} else {
-			__sha512_ssse3_update(desc, padding, padlen, index);
-		}
-		__sha512_ssse3_update(desc, (const u8 *)&bits,
-					sizeof(bits), 112);
-		kernel_fpu_end();
-	}
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be64(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha512_ssse3_export(struct shash_desc *desc, void *out)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
 
-	return 0;
-}
-
-static int sha512_ssse3_import(struct shash_desc *desc, const void *in)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
+	if (!irq_fpu_usable() ||
+	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
+		return crypto_sha512_update(desc, data, len);
 
-	memcpy(sctx, in, sizeof(*sctx));
+	kernel_fpu_begin();
+	sha512_base_do_update(desc, data, len, sha512_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
 	return 0;
 }
 
-static int sha384_ssse3_init(struct shash_desc *desc)
+static int sha512_ssse3_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
+	if (!irq_fpu_usable())
+		return crypto_sha512_finup(desc, data, len, out);
 
-	sctx->state[0] = SHA384_H0;
-	sctx->state[1] = SHA384_H1;
-	sctx->state[2] = SHA384_H2;
-	sctx->state[3] = SHA384_H3;
-	sctx->state[4] = SHA384_H4;
-	sctx->state[5] = SHA384_H5;
-	sctx->state[6] = SHA384_H6;
-	sctx->state[7] = SHA384_H7;
+	kernel_fpu_begin();
+	if (len)
+		sha512_base_do_update(desc, data, len, sha512_ssse3_block_fn,
+				      NULL);
+	sha512_base_do_finalize(desc, sha512_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	sctx->count[0] = sctx->count[1] = 0;
-
-	return 0;
+	return sha512_base_finish(desc, out);
 }
 
-static int sha384_ssse3_final(struct shash_desc *desc, u8 *hash)
+/* Add padding and return the message digest. */
+static int sha512_ssse3_final(struct shash_desc *desc, u8 *out)
 {
-	u8 D[SHA512_DIGEST_SIZE];
-
-	sha512_ssse3_final(desc, D);
-
-	memcpy(hash, D, SHA384_DIGEST_SIZE);
-	memzero_explicit(D, SHA512_DIGEST_SIZE);
-
-	return 0;
+	return sha512_ssse3_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg algs[] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
-	.init		=	sha512_ssse3_init,
+	.init		=	sha512_base_init,
 	.update		=	sha512_ssse3_update,
 	.final		=	sha512_ssse3_final,
-	.export		=	sha512_ssse3_export,
-	.import		=	sha512_ssse3_import,
+	.finup		=	sha512_ssse3_finup,
+	.export		=	sha512_base_export,
+	.import		=	sha512_base_import,
 	.descsize	=	sizeof(struct sha512_state),
 	.statesize	=	sizeof(struct sha512_state),
 	.base		=	{
@@ -243,11 +121,12 @@ static struct shash_alg algs[] = { {
 	}
 },  {
 	.digestsize	=	SHA384_DIGEST_SIZE,
-	.init		=	sha384_ssse3_init,
+	.init		=	sha384_base_init,
 	.update		=	sha512_ssse3_update,
-	.final		=	sha384_ssse3_final,
-	.export		=	sha512_ssse3_export,
-	.import		=	sha512_ssse3_import,
+	.final		=	sha512_ssse3_final,
+	.finup		=	sha512_ssse3_finup,
+	.export		=	sha512_base_export,
+	.import		=	sha512_base_import,
 	.descsize	=	sizeof(struct sha512_state),
 	.statesize	=	sizeof(struct sha512_state),
 	.base		=	{
-- 
1.8.3.2
