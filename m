From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 14/16] crypto/x86: move SHA-1 SSSE3 implementation to base layer
Date: Tue,  7 Apr 2015 10:52:02 +0200
Message-ID: <1428396724-19962-15-git-send-email-ard.biesheuvel@linaro.org>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: stockhausen@collogia.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, herbert@gondor.apana.org.au,
	samitolvanen@google.com, jussi.kivilinna@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36454 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbbDGIw6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 04:52:58 -0400
Received: by wizk4 with SMTP id k4so8936831wiz.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2015 01:52:56 -0700 (PDT)
In-Reply-To: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha1_ssse3_glue.c | 136 +++++++++-----------------------------
 1 file changed, 30 insertions(+), 106 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 6c20fe04a738..8678dc75fbf3 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -28,7 +28,7 @@
 #include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
-#include <asm/byteorder.h>
+#include <crypto/sha1_base.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/xsave.h>
@@ -49,127 +49,50 @@ asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
 
 static asmlinkage void (*sha1_transform_asm)(u32 *, const char *, unsigned int);
 
-
-static int sha1_ssse3_init(struct shash_desc *desc)
+static void sha1_ssse3_block_fn(int blocks, u8 const *src, u32 *state,
+				const u8 *head, void *p)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
-
-	return 0;
-}
-
-static int __sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, unsigned int partial)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int done = 0;
-
-	sctx->count += len;
-
-	if (partial) {
-		done = SHA1_BLOCK_SIZE - partial;
-		memcpy(sctx->buffer + partial, data, done);
-		sha1_transform_asm(sctx->state, sctx->buffer, 1);
-	}
-
-	if (len - done >= SHA1_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / SHA1_BLOCK_SIZE;
-
-		sha1_transform_asm(sctx->state, data + done, rounds);
-		done += rounds * SHA1_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->buffer, data + done, len - done);
-
-	return 0;
+	if (head)
+		sha1_transform_asm(state, head, 1);
+	if (blocks)
+		sha1_transform_asm(state, src, blocks);
 }
 
 static int sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
-	int res;
 
-	/* Handle the fast case right here */
-	if (partial + len < SHA1_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buffer + partial, data, len);
+	if (!irq_fpu_usable() ||
+	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
+		return crypto_sha1_update(desc, data, len);
 
-		return 0;
-	}
-
-	if (!irq_fpu_usable()) {
-		res = crypto_sha1_update(desc, data, len);
-	} else {
-		kernel_fpu_begin();
-		res = __sha1_ssse3_update(desc, data, len, partial);
-		kernel_fpu_end();
-	}
-
-	return res;
-}
-
-
-/* Add padding and return the message digest. */
-static int sha1_ssse3_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA1_BLOCK_SIZE] = { 0x80, };
-
-	bits = cpu_to_be64(sctx->count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->count % SHA1_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((SHA1_BLOCK_SIZE+56) - index);
-	if (!irq_fpu_usable()) {
-		crypto_sha1_update(desc, padding, padlen);
-		crypto_sha1_update(desc, (const u8 *)&bits, sizeof(bits));
-	} else {
-		kernel_fpu_begin();
-		/* We need to fill a whole block for __sha1_ssse3_update() */
-		if (padlen <= 56) {
-			sctx->count += padlen;
-			memcpy(sctx->buffer + index, padding, padlen);
-		} else {
-			__sha1_ssse3_update(desc, padding, padlen, index);
-		}
-		__sha1_ssse3_update(desc, (const u8 *)&bits, sizeof(bits), 56);
-		kernel_fpu_end();
-	}
-
-	/* Store state in digest */
-	for (i = 0; i < 5; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
+	kernel_fpu_begin();
+	sha1_base_do_update(desc, data, len, sha1_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
 	return 0;
 }
 
-static int sha1_ssse3_export(struct shash_desc *desc, void *out)
+static int sha1_ssse3_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
+	if (!irq_fpu_usable())
+		return crypto_sha1_finup(desc, data, len, out);
 
-	memcpy(out, sctx, sizeof(*sctx));
+	kernel_fpu_begin();
+	if (len)
+		sha1_base_do_update(desc, data, len, sha1_ssse3_block_fn, NULL);
+	sha1_base_do_finalize(desc, sha1_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	return 0;
+	return sha1_base_finish(desc, out);
 }
 
-static int sha1_ssse3_import(struct shash_desc *desc, const void *in)
+/* Add padding and return the message digest. */
+static int sha1_ssse3_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
-
-	return 0;
+	return sha1_ssse3_finup(desc, NULL, 0, out);
 }
 
 #ifdef CONFIG_AS_AVX2
@@ -186,11 +109,12 @@ static void sha1_apply_transform_avx2(u32 *digest, const char *data,
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
-	.init		=	sha1_ssse3_init,
+	.init		=	sha1_base_init,
 	.update		=	sha1_ssse3_update,
 	.final		=	sha1_ssse3_final,
-	.export		=	sha1_ssse3_export,
-	.import		=	sha1_ssse3_import,
+	.finup		=	sha1_ssse3_finup,
+	.export		=	sha1_base_export,
+	.import		=	sha1_base_import,
 	.descsize	=	sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
-- 
1.8.3.2
