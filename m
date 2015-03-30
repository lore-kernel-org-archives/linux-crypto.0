From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 resend 12/14] crypto/x86: move SHA-1 SSSE3 implementation to base layer
Date: Mon, 30 Mar 2015 11:48:31 +0200
Message-ID: <1427708913-29678-13-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37996 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbbC3Jti (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:49:38 -0400
Received: by wibgn9 with SMTP id gn9so120947142wib.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:49:37 -0700 (PDT)
In-Reply-To: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha1_ssse3_glue.c | 139 +++++++++-----------------------------
 crypto/Kconfig                    |   1 +
 2 files changed, 34 insertions(+), 106 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 6c20fe04a738..ee0b775f2b1f 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -49,127 +49,53 @@ asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
 
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
-
-	/* Handle the fast case right here */
-	if (partial + len < SHA1_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buffer + partial, data, len);
+	int err;
 
-		return 0;
-	}
+	if (!irq_fpu_usable() ||
+	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
+		return crypto_sha1_update(desc, data, len);
 
-	if (!irq_fpu_usable()) {
-		res = crypto_sha1_update(desc, data, len);
-	} else {
-		kernel_fpu_begin();
-		res = __sha1_ssse3_update(desc, data, len, partial);
-		kernel_fpu_end();
-	}
+	kernel_fpu_begin();
+	err = crypto_sha1_base_do_update(desc, data, len,
+					 sha1_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	return res;
+	return err;
 }
 
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
-
-	return 0;
-}
-
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
+		crypto_sha1_base_do_update(desc, data, len,
+					   sha1_ssse3_block_fn, NULL);
+	crypto_sha1_base_do_finalize(desc, sha1_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	return 0;
+	return crypto_sha1_base_finish(desc, out);
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
@@ -186,11 +112,12 @@ static void sha1_apply_transform_avx2(u32 *digest, const char *data,
 
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
-	.init		=	sha1_ssse3_init,
+	.init		=	crypto_sha1_base_init,
 	.update		=	sha1_ssse3_update,
 	.final		=	sha1_ssse3_final,
-	.export		=	sha1_ssse3_export,
-	.import		=	sha1_ssse3_import,
+	.finup		=	sha1_ssse3_finup,
+	.export		=	crypto_sha1_base_export,
+	.import		=	crypto_sha1_base_import,
 	.descsize	=	sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8f16d90f7c55..82b9672f089f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -530,6 +530,7 @@ config CRYPTO_SHA1_SSSE3
 	tristate "SHA1 digest algorithm (SSSE3/AVX/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_SHA1
+	select CRYPTO_SHA1_BASE
 	select CRYPTO_HASH
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
-- 
1.8.3.2
