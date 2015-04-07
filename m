From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 15/16] crypto/x86: move SHA-224/256 SSSE3 implementation to base layer
Date: Tue,  7 Apr 2015 10:52:03 +0200
Message-ID: <1428396724-19962-16-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36512 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbbDGIxA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:53:00 -0400
Received: by wizk4 with SMTP id k4so8938141wiz.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:59 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 184 +++++++-----------------------------
 1 file changed, 36 insertions(+), 148 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 8fad72f4dfd2..bd4ae0da0a49 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -36,7 +36,7 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-#include <asm/byteorder.h>
+#include <crypto/sha256_base.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
@@ -55,174 +55,61 @@ asmlinkage void sha256_transform_rorx(const char *data, u32 *digest,
 
 static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
 
-
-static int sha256_ssse3_init(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA256_H0;
-	sctx->state[1] = SHA256_H1;
-	sctx->state[2] = SHA256_H2;
-	sctx->state[3] = SHA256_H3;
-	sctx->state[4] = SHA256_H4;
-	sctx->state[5] = SHA256_H5;
-	sctx->state[6] = SHA256_H6;
-	sctx->state[7] = SHA256_H7;
-	sctx->count = 0;
-
-	return 0;
-}
-
-static int __sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, unsigned int partial)
+static void sha256_ssse3_block_fn(int blocks, u8 const *src, u32 *state,
+				  const u8 *head, void *p)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int done = 0;
-
-	sctx->count += len;
-
-	if (partial) {
-		done = SHA256_BLOCK_SIZE - partial;
-		memcpy(sctx->buf + partial, data, done);
-		sha256_transform_asm(sctx->buf, sctx->state, 1);
-	}
-
-	if (len - done >= SHA256_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA256_BLOCK_SIZE;
-
-		sha256_transform_asm(data + done, sctx->state, (u64) rounds);
-
-		done += rounds * SHA256_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buf, data + done, len - done);
-
-	return 0;
+	if (head)
+		sha256_transform_asm(head, state, 1);
+	if (blocks)
+		sha256_transform_asm(src, state, blocks);
 }
 
 static int sha256_ssse3_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
-	int res;
 
-	/* Handle the fast case right here */
-	if (partial + len < SHA256_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buf + partial, data, len);
-
-		return 0;
-	}
-
-	if (!irq_fpu_usable()) {
-		res = crypto_sha256_update(desc, data, len);
-	} else {
-		kernel_fpu_begin();
-		res = __sha256_ssse3_update(desc, data, len, partial);
-		kernel_fpu_end();
-	}
+	if (!irq_fpu_usable() ||
+	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
+		return crypto_sha256_update(desc, data, len);
 
-	return res;
-}
-
-
-/* Add padding and return the message digest. */
-static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
-
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->count % SHA256_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((SHA256_BLOCK_SIZE+56)-index);
-
-	if (!irq_fpu_usable()) {
-		crypto_sha256_update(desc, padding, padlen);
-		crypto_sha256_update(desc, (const u8 *)&bits, sizeof(bits));
-	} else {
-		kernel_fpu_begin();
-		/* We need to fill a whole block for __sha256_ssse3_update() */
-		if (padlen <= 56) {
-			sctx->count += padlen;
-			memcpy(sctx->buf + index, padding, padlen);
-		} else {
-			__sha256_ssse3_update(desc, padding, padlen, index);
-		}
-		__sha256_ssse3_update(desc, (const u8 *)&bits,
-					sizeof(bits), 56);
-		kernel_fpu_end();
-	}
-
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
+	kernel_fpu_begin();
+	sha256_base_do_update(desc, data, len, sha256_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
 	return 0;
 }
 
-static int sha256_ssse3_export(struct shash_desc *desc, void *out)
+static int sha256_ssse3_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	if (!irq_fpu_usable())
+		return crypto_sha256_finup(desc, data, len, out);
 
-	memcpy(out, sctx, sizeof(*sctx));
+	kernel_fpu_begin();
+	if (len)
+		sha256_base_do_update(desc, data, len, sha256_ssse3_block_fn,
+				      NULL);
+	sha256_base_do_finalize(desc, sha256_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	return 0;
-}
-
-static int sha256_ssse3_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-
-	return 0;
+	return sha256_base_finish(desc, out);
 }
 
-static int sha224_ssse3_init(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA224_H0;
-	sctx->state[1] = SHA224_H1;
-	sctx->state[2] = SHA224_H2;
-	sctx->state[3] = SHA224_H3;
-	sctx->state[4] = SHA224_H4;
-	sctx->state[5] = SHA224_H5;
-	sctx->state[6] = SHA224_H6;
-	sctx->state[7] = SHA224_H7;
-	sctx->count = 0;
-
-	return 0;
-}
-
-static int sha224_ssse3_final(struct shash_desc *desc, u8 *hash)
+/* Add padding and return the message digest. */
+static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
 {
-	u8 D[SHA256_DIGEST_SIZE];
-
-	sha256_ssse3_final(desc, D);
-
-	memcpy(hash, D, SHA224_DIGEST_SIZE);
-	memzero_explicit(D, SHA256_DIGEST_SIZE);
-
-	return 0;
+	return sha256_ssse3_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_ssse3_init,
+	.init		=	sha256_base_init,
 	.update		=	sha256_ssse3_update,
 	.final		=	sha256_ssse3_final,
-	.export		=	sha256_ssse3_export,
-	.import		=	sha256_ssse3_import,
+	.finup		=	sha256_ssse3_finup,
+	.export		=	sha256_base_export,
+	.import		=	sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
@@ -235,11 +122,12 @@ static struct shash_alg algs[] = { {
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_ssse3_init,
+	.init		=	sha224_base_init,
 	.update		=	sha256_ssse3_update,
-	.final		=	sha224_ssse3_final,
-	.export		=	sha256_ssse3_export,
-	.import		=	sha256_ssse3_import,
+	.final		=	sha256_ssse3_final,
+	.finup		=	sha256_ssse3_finup,
+	.export		=	sha256_base_export,
+	.import		=	sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
-- 
1.8.3.2
