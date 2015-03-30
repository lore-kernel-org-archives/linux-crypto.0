From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 resend 09/14] crypto/arm: move SHA-224/256 ARMv8 implementation to base layer
Date: Mon, 30 Mar 2015 11:48:28 +0200
Message-ID: <1427708913-29678-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	samitolvanen@google.com, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, stockhausen@collogia.de, x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35031 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbbC3Jt3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 05:49:29 -0400
Received: by wicne17 with SMTP id ne17so23935681wic.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2015 02:49:28 -0700 (PDT)
In-Reply-To: <1427708913-29678-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig        |   1 +
 arch/arm/crypto/sha2-ce-glue.c | 151 +++++++++--------------------------------
 2 files changed, 33 insertions(+), 119 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 31ad19f18af2..de91f0447240 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -42,6 +42,7 @@ config CRYPTO_SHA2_ARM_CE
 	tristate "SHA-224/256 digest algorithm (ARM v8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SHA256
+	select CRYPTO_SHA256_BASE
 	select CRYPTO_HASH
 	help
 	  SHA-256 secure hash standard (DFIPS 180-2) implemented
diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
index 9ffe8ad27402..df57192c41cd 100644
--- a/arch/arm/crypto/sha2-ce-glue.c
+++ b/arch/arm/crypto/sha2-ce-glue.c
@@ -23,140 +23,52 @@ MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
 asmlinkage void sha2_ce_transform(int blocks, u8 const *src, u32 *state,
-				  u8 *head);
+				  const u8 *head, void *p);
 
-static int sha224_init(struct shash_desc *desc)
+static int sha2_ce_update(struct shash_desc *desc, const u8 *data,
+			  unsigned int len)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
-	*sctx = (struct sha256_state){
-		.state = {
-			SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
-			SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
-		}
-	};
-	return 0;
-}
+	if (!may_use_simd() ||
+	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
+		return crypto_sha256_update(desc, data, len);
 
-static int sha256_init(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	kernel_neon_begin();
+	crypto_sha256_base_do_update(desc, data, len, sha2_ce_transform, NULL);
+	kernel_neon_end();
 
-	*sctx = (struct sha256_state){
-		.state = {
-			SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
-			SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
-		}
-	};
 	return 0;
 }
 
-static int sha2_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
+static int sha2_ce_finup(struct shash_desc *desc, const u8 *data,
+			 unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial;
-
 	if (!may_use_simd())
-		return crypto_sha256_update(desc, data, len);
-
-	partial = sctx->count % SHA256_BLOCK_SIZE;
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
+		return crypto_sha256_finup(desc, data, len, out);
 
-		blocks = len / SHA256_BLOCK_SIZE;
-		len %= SHA256_BLOCK_SIZE;
-
-		kernel_neon_begin();
-		sha2_ce_transform(blocks, data, sctx->state,
-				  partial ? sctx->buf : NULL);
-		kernel_neon_end();
-
-		data += blocks * SHA256_BLOCK_SIZE;
-		partial = 0;
-	}
+	kernel_neon_begin();
 	if (len)
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
+		crypto_sha256_base_do_update(desc, data, len,
+					     sha2_ce_transform, NULL);
+	crypto_sha256_base_do_finalize(desc, sha2_ce_transform, NULL);
+	kernel_neon_end();
 
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
+	return crypto_sha256_base_finish(desc, out);
 }
 
-static int sha256_final(struct shash_desc *desc, u8 *out)
+static int sha2_ce_final(struct shash_desc *desc, u8 *out)
 {
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
-static int sha2_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	struct sha256_state *dst = out;
-
-	*dst = *sctx;
-	return 0;
-}
-
-static int sha2_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	struct sha256_state const *src = in;
-
-	*sctx = *src;
-	return 0;
+	return sha2_ce_finup(desc, NULL, 0, out);
 }
 
 static struct shash_alg algs[] = { {
-	.init			= sha224_init,
-	.update			= sha2_update,
-	.final			= sha224_final,
-	.export			= sha2_export,
-	.import			= sha2_import,
+	.init			= crypto_sha224_base_init,
+	.update			= sha2_ce_update,
+	.final			= sha2_ce_final,
+	.finup			= sha2_ce_finup,
+	.export			= crypto_sha256_base_export,
+	.import			= crypto_sha256_base_import,
 	.descsize		= sizeof(struct sha256_state),
 	.digestsize		= SHA224_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha256_state),
@@ -169,11 +81,12 @@ static struct shash_alg algs[] = { {
 		.cra_module		= THIS_MODULE,
 	}
 }, {
-	.init			= sha256_init,
-	.update			= sha2_update,
-	.final			= sha256_final,
-	.export			= sha2_export,
-	.import			= sha2_import,
+	.init			= crypto_sha256_base_init,
+	.update			= sha2_ce_update,
+	.final			= sha2_ce_final,
+	.finup			= sha2_ce_finup,
+	.export			= crypto_sha256_base_export,
+	.import			= crypto_sha256_base_import,
 	.descsize		= sizeof(struct sha256_state),
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.statesize		= sizeof(struct sha256_state),
-- 
1.8.3.2
