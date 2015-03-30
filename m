From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 resend 14/14] crypto/x86: move SHA-384/512 SSSE3 implementation to base layer
Date: Mon, 30 Mar 2015 11:48:33 +0200
Message-ID: <1427708913-29678-15-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35897 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbbC3Jto (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:49:44 -0400
Received: by wibg7 with SMTP id g7so95825099wib.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:49:43 -0700 (PDT)
In-Reply-To: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha512_ssse3_glue.c | 195 +++++++-----------------------------
 crypto/Kconfig                      |   1 +
 2 files changed, 39 insertions(+), 157 deletions(-)

diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 0b6af26832bf..f5ab7275e50b 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -54,183 +54,63 @@ asmlinkage void sha512_transform_rorx(const char *data, u64 *digest,
 
 static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);
 
-
-static int sha512_ssse3_init(struct shash_desc *desc)
+static void sha512_ssse3_block_fn(int blocks, u8 const *src, u64 *state,
+				  const u8 *head, void *p)
 {
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
-{
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
+	int err;
 
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be64(sctx->state[i]);
+	if (!irq_fpu_usable() ||
+	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
+		return crypto_sha512_update(desc, data, len);
 
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
+	kernel_fpu_begin();
+	err = crypto_sha512_base_do_update(desc, data, len,
+					   sha512_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	return 0;
+	return err;
 }
 
-static int sha512_ssse3_export(struct shash_desc *desc, void *out)
+static int sha512_ssse3_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha512_ssse3_import(struct shash_desc *desc, const void *in)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
+	if (!irq_fpu_usable())
+		return crypto_sha512_finup(desc, data, len, out);
 
-	memcpy(sctx, in, sizeof(*sctx));
+	kernel_fpu_begin();
+	if (len)
+		crypto_sha512_base_do_update(desc, data, len,
+					     sha512_ssse3_block_fn, NULL);
+	crypto_sha512_base_do_finalize(desc, sha512_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	return 0;
+	return crypto_sha512_base_finish(desc, out);
 }
 
-static int sha384_ssse3_init(struct shash_desc *desc)
-{
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	sctx->state[0] = SHA384_H0;
-	sctx->state[1] = SHA384_H1;
-	sctx->state[2] = SHA384_H2;
-	sctx->state[3] = SHA384_H3;
-	sctx->state[4] = SHA384_H4;
-	sctx->state[5] = SHA384_H5;
-	sctx->state[6] = SHA384_H6;
-	sctx->state[7] = SHA384_H7;
-
-	sctx->count[0] = sctx->count[1] = 0;
-
-	return 0;
-}
-
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
+	.init		=	crypto_sha512_base_init,
 	.update		=	sha512_ssse3_update,
 	.final		=	sha512_ssse3_final,
-	.export		=	sha512_ssse3_export,
-	.import		=	sha512_ssse3_import,
+	.finup		=	sha512_ssse3_finup,
+	.export		=	crypto_sha512_base_export,
+	.import		=	crypto_sha512_base_import,
 	.descsize	=	sizeof(struct sha512_state),
 	.statesize	=	sizeof(struct sha512_state),
 	.base		=	{
@@ -243,11 +123,12 @@ static struct shash_alg algs[] = { {
 	}
 },  {
 	.digestsize	=	SHA384_DIGEST_SIZE,
-	.init		=	sha384_ssse3_init,
+	.init		=	crypto_sha384_base_init,
 	.update		=	sha512_ssse3_update,
-	.final		=	sha384_ssse3_final,
-	.export		=	sha512_ssse3_export,
-	.import		=	sha512_ssse3_import,
+	.final		=	sha512_ssse3_final,
+	.finup		=	sha512_ssse3_finup,
+	.export		=	crypto_sha512_base_export,
+	.import		=	crypto_sha512_base_import,
 	.descsize	=	sizeof(struct sha512_state),
 	.statesize	=	sizeof(struct sha512_state),
 	.base		=	{
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1198ff3a33d8..e3ce5cd2f4c1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -553,6 +553,7 @@ config CRYPTO_SHA512_SSSE3
 	tristate "SHA512 digest algorithm (SSSE3/AVX/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_SHA512
+	select CRYPTO_SHA512_BASE
 	select CRYPTO_HASH
 	help
 	  SHA-512 secure hash standard (DFIPS 180-2) implemented
-- 
1.8.3.2
