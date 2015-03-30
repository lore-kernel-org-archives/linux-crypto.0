From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 5/6] arm64/crypto: move ARMv8 SHA-224/256 driver to SHA-256 base layer
Date: Mon, 30 Mar 2015 11:36:18 +0200
Message-ID: <1427708184-2353-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36182 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbbC3JhC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:37:02 -0400
Received: by wgra20 with SMTP id a20so166505679wgr.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:37:01 -0700 (PDT)
In-Reply-To: <1427708184-2353-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig        |   1 +
 arch/arm64/crypto/sha2-ce-core.S |  11 +-
 arch/arm64/crypto/sha2-ce-glue.c | 211 ++++++---------------------------------
 3 files changed, 40 insertions(+), 183 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 2cf32e9887e1..13008362154b 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -17,6 +17,7 @@ config CRYPTO_SHA2_ARM64_CE
 	tristate "SHA-224/SHA-256 digest algorithm (ARMv8 Crypto Extensions)"
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_HASH
+	select CRYPTO_SHA256_BASE
 
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH (for GCM chaining mode) using ARMv8 Crypto Extensions"
diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 7f29fc031ea8..65ad56636fba 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -135,15 +135,18 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 
 	/*
 	 * Final block: add padding and total bit count.
-	 * Skip if we have no total byte count in x4. In that case, the input
-	 * size was not a round multiple of the block size, and the padding is
-	 * handled by the C code.
+	 * Skip if the input size was not a round multiple of the block size,
+	 * the padding is handled by the C code in that case.
 	 */
 	cbz		x4, 3f
+	ldr		x5, [x2, #-8]		// sha256_state::count
+	tst		x5, #0x3f		// round multiple of block size?
+	b.ne		3f
+	str		wzr, [x4]
 	movi		v17.2d, #0
 	mov		x8, #0x80000000
 	movi		v18.2d, #0
-	ror		x7, x4, #29		// ror(lsl(x4, 3), 32)
+	ror		x7, x5, #29		// ror(lsl(x4, 3), 32)
 	fmov		d16, x8
 	mov		x4, #0
 	mov		v19.d[0], xzr
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index ae67e88c28b9..8b35ca32538a 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -20,195 +20,48 @@ MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
-asmlinkage int sha2_ce_transform(int blocks, u8 const *src, u32 *state,
-				 u8 *head, long bytes);
+asmlinkage void sha2_ce_transform(int blocks, u8 const *src, u32 *state,
+				  const u8 *head, void *p);
 
-static int sha224_init(struct shash_desc *desc)
+static int sha256_ce_update(struct shash_desc *desc, const u8 *data,
+			    unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha256_state){
-		.state = {
-			SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
-			SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
-		}
-	};
-	return 0;
-}
-
-static int sha256_init(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha256_state){
-		.state = {
-			SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
-			SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
-		}
-	};
-	return 0;
-}
-
-static int sha2_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
-
-	sctx->count += len;
-
-	if ((partial + len) >= SHA256_BLOCK_SIZE) {
-		int blocks;
-
-		if (partial) {
-			int p = SHA256_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buf + partial, data, p);
-			data += p;
-			len -= p;
-		}
-
-		blocks = len / SHA256_BLOCK_SIZE;
-		len %= SHA256_BLOCK_SIZE;
-
-		kernel_neon_begin_partial(28);
-		sha2_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buf : NULL, 0);
-		kernel_neon_end();
-
-		data += blocks * SHA256_BLOCK_SIZE;
-		partial = 0;
-	}
-	if (len)
-		memcpy(sctx->buf + partial, data, len);
-	return 0;
-}
-
-static void sha2_final(struct shash_desc *desc)
-{
-	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
-
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	__be64 bits = cpu_to_be64(sctx->count << 3);
-	u32 padlen = SHA256_BLOCK_SIZE
-		     - ((sctx->count + sizeof(bits)) % SHA256_BLOCK_SIZE);
-
-	sha2_update(desc, padding, padlen);
-	sha2_update(desc, (const u8 *)&bits, sizeof(bits));
-}
-
-static int sha224_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	int i;
-
-	sha2_final(desc);
-
-	for (i = 0; i < SHA224_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
-
-	*sctx = (struct sha256_state){};
-	return 0;
-}
-
-static int sha256_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	int i;
-
-	sha2_final(desc);
-
-	for (i = 0; i < SHA256_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
-
-	*sctx = (struct sha256_state){};
-	return 0;
-}
-
-static void sha2_finup(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	int blocks;
-
-	if (sctx->count || !len || (len % SHA256_BLOCK_SIZE)) {
-		sha2_update(desc, data, len);
-		sha2_final(desc);
-		return;
-	}
-
-	/*
-	 * Use a fast path if the input is a multiple of 64 bytes. In
-	 * this case, there is no need to copy data around, and we can
-	 * perform the entire digest calculation in a single invocation
-	 * of sha2_ce_transform()
-	 */
-	blocks = len / SHA256_BLOCK_SIZE;
+	int err;
 
 	kernel_neon_begin_partial(28);
-	sha2_ce_transform(blocks, data, sctx->state, NULL, len);
+	err = sha256_base_do_update(desc, data, len, sha2_ce_transform, NULL);
 	kernel_neon_end();
+	return err;
 }
 
-static int sha224_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out)
+static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
+			   unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	int i;
-
-	sha2_finup(desc, data, len);
-
-	for (i = 0; i < SHA224_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
+	u32 finalize = 1;
 
-	*sctx = (struct sha256_state){};
-	return 0;
-}
-
-static int sha256_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	__be32 *dst = (__be32 *)out;
-	int i;
-
-	sha2_finup(desc, data, len);
-
-	for (i = 0; i < SHA256_DIGEST_SIZE / sizeof(__be32); i++)
-		put_unaligned_be32(sctx->state[i], dst++);
-
-	*sctx = (struct sha256_state){};
-	return 0;
-}
-
-static int sha2_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	struct sha256_state *dst = out;
+	kernel_neon_begin_partial(28);
+	if (len)
+		sha256_base_do_update(desc, data, len, sha2_ce_transform,
+				      &finalize);
+	if (finalize)
+		sha256_base_do_finalize(desc, sha2_ce_transform, NULL);
+	kernel_neon_end();
 
-	*dst = *sctx;
-	return 0;
+	return sha256_base_finish(desc, out);
 }
 
-static int sha2_import(struct shash_desc *desc, const void *in)
+static int sha256_ce_final(struct shash_desc *desc, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	struct sha256_state const *src = in;
-
-	*sctx = *src;
-	return 0;
+	return sha256_ce_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg algs[] = { {
-	.init			= sha224_init,
-	.update			= sha2_update,
-	.final			= sha224_final,
-	.finup			= sha224_finup,
-	.export			= sha2_export,
-	.import			= sha2_import,
+	.init			= sha224_base_init,
+	.update			= sha256_ce_update,
+	.final			= sha256_ce_final,
+	.finup			= sha256_ce_finup,
+	.export			= sha256_base_export,
+	.import			= sha256_base_import,
 	.descsize		= sizeof(struct sha256_state),
 	.digestsize		= SHA224_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha256_state),
@@ -221,12 +74,12 @@ static struct shash_alg algs[] = { {
 		.cra_module		= THIS_MODULE,
 	}
 }, {
-	.init			= sha256_init,
-	.update			= sha2_update,
-	.final			= sha256_final,
-	.finup			= sha256_finup,
-	.export			= sha2_export,
-	.import			= sha2_import,
+	.init			= sha256_base_init,
+	.update			= sha256_ce_update,
+	.final			= sha256_ce_final,
+	.finup			= sha256_ce_finup,
+	.export			= sha256_base_export,
+	.import			= sha256_base_import,
 	.descsize		= sizeof(struct sha256_state),
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha256_state),
-- 
1.8.3.2
