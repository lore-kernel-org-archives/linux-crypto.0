From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 resend 13/14] crypto/x86: move SHA-224/256 SSSE3 implementation to base layer
Date: Mon, 30 Mar 2015 11:48:32 +0200
Message-ID: <1427708913-29678-14-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35885 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbbC3Jtl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:49:41 -0400
Received: by wgra20 with SMTP id a20so166925369wgr.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:49:40 -0700 (PDT)
In-Reply-To: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 186 ++++++++----------------------------
 crypto/Kconfig                      |   1 +
 2 files changed, 39 insertions(+), 148 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 8fad72f4dfd2..bd9f5ec718fd 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -55,174 +55,63 @@ asmlinkage void sha256_transform_rorx(const char *data, u32 *digest,
 
 static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
 
-
-static int sha256_ssse3_init(struct shash_desc *desc)
+static void sha256_ssse3_block_fn(int blocks, u8 const *src, u32 *state,
+				  const u8 *head, void *p)
 {
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
-{
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
+	int err;
 
-	/* Handle the fast case right here */
-	if (partial + len < SHA256_BLOCK_SIZE) {
-		sctx->count += len;
-		memcpy(sctx->buf + partial, data, len);
+	if (!irq_fpu_usable() ||
+	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
+		return crypto_sha256_update(desc, data, len);
 
-		return 0;
-	}
+	kernel_fpu_begin();
+	err = crypto_sha256_base_do_update(desc, data, len,
+					   sha256_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	if (!irq_fpu_usable()) {
-		res = crypto_sha256_update(desc, data, len);
-	} else {
-		kernel_fpu_begin();
-		res = __sha256_ssse3_update(desc, data, len, partial);
-		kernel_fpu_end();
-	}
-
-	return res;
+	return err;
 }
 
-
-/* Add padding and return the message digest. */
-static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
+static int sha256_ssse3_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	__be32 *dst = (__be32 *)out;
-	__be64 bits;
-	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
+	if (!irq_fpu_usable())
+		return crypto_sha256_finup(desc, data, len, out);
 
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
+	kernel_fpu_begin();
+	if (len)
+		crypto_sha256_base_do_update(desc, data, len,
+					     sha256_ssse3_block_fn, NULL);
+	crypto_sha256_base_do_finalize(desc, sha256_ssse3_block_fn, NULL);
+	kernel_fpu_end();
 
-	/* Store state in digest */
-	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
-
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
-
-	return 0;
-}
-
-static int sha256_ssse3_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
-
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
-}
-
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
+	return crypto_sha256_base_finish(desc, out);
 }
 
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
+	.init		=	crypto_sha256_base_init,
 	.update		=	sha256_ssse3_update,
 	.final		=	sha256_ssse3_final,
-	.export		=	sha256_ssse3_export,
-	.import		=	sha256_ssse3_import,
+	.finup		=	sha256_ssse3_finup,
+	.export		=	crypto_sha256_base_export,
+	.import		=	crypto_sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
@@ -235,11 +124,12 @@ static struct shash_alg algs[] = { {
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_ssse3_init,
+	.init		=	crypto_sha224_base_init,
 	.update		=	sha256_ssse3_update,
-	.final		=	sha224_ssse3_final,
-	.export		=	sha256_ssse3_export,
-	.import		=	sha256_ssse3_import,
+	.final		=	sha256_ssse3_final,
+	.finup		=	sha256_ssse3_finup,
+	.export		=	crypto_sha256_base_export,
+	.import		=	crypto_sha256_base_import,
 	.descsize	=	sizeof(struct sha256_state),
 	.statesize	=	sizeof(struct sha256_state),
 	.base		=	{
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 82b9672f089f..1198ff3a33d8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -541,6 +541,7 @@ config CRYPTO_SHA256_SSSE3
 	tristate "SHA256 digest algorithm (SSSE3/AVX/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_SHA256
+	select CRYPTO_SHA256_BASE
 	select CRYPTO_HASH
 	help
 	  SHA-256 secure hash standard (DFIPS 180-2) implemented
-- 
1.8.3.2
