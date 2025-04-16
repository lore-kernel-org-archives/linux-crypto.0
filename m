Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F322309B0
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785784; cv=none; b=j5uwZfbGu5QgjGk2MBY2JYVYWunJeVBDFTiEFVKXnDD8g6jeALx9mMlyy0e69RpoPxEkmX3np20q0yi9kafyVxQH5pIz0m3oPOypP+gR9+/4G1hKvqStyyU5Y11D8ygNPgA/o2vBAkvkq1w/bF5JI1VaIn2f0gA3egFLM6G+TSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785784; c=relaxed/simple;
	bh=FeQsdAWrIpcSwSWfi4E59f28zXxwpUGm2Ls5AZQi1g0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=IhKABCx5qMsupe01eGLeCz+A6ANqGu6Vuc0vOdIvOuCKgxXAE9MglTecVw3wgU7meEc+sSOgJqAG4VWneERr1qCN1jSsCaa3HIadxWBOmfTu/rfiqpRNeb1j/W9xTwBcUJM9rBcMSC5YL2Lts5tRHO7VMTuqDVDnin2uM5+O21I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JCLaGIAe; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JCLaGIAe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Squ27ojLQ7hZiAyvY4dmDP1YXLyCVYhjNaQRuY7+eB8=; b=JCLaGIAepRPgd8lNaEKWb+AwV7
	vCiOyKhkqbTXcBzYF7MdH3HxJr4/TTIwu7ujPR2kmv/ICFhouoj+sHkCpWgcxPZSg/EzbvzZYnL1E
	rPpvwUcNnXC3d0F9pY8eRn8mIXGWvgUWHyXI42Vmt/q/u32gYfnRfs0ns4yANnGvkwvUlfNGCBMJU
	AXFqS6YjpzrZAOO4MXe7ox/C9giuSyd4xo80/VtwnmKgZWcf38h2TOpGGgYlZAgbwKy5uJz5UWHQh
	Wjuzx420EiZTrMahYOpXOVtvYn2EAS2Rd8ECRsDMJ93ub+mx5QjHkQCVrpT2QzTbX/h681XCtzstK
	wgTLpRNQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wU6-00G6HY-3D;
	Wed, 16 Apr 2025 14:43:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:42:58 +0800
Date: Wed, 16 Apr 2025 14:42:58 +0800
Message-Id: <2eb60b2f91e48a33e058af45792afe36daddd307.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 07/67] crypto: arm64/ghash - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also remove the unnecessary SIMD fallback path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/ghash-ce-glue.c | 151 ++++++++++++------------------
 1 file changed, 60 insertions(+), 91 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 071e122f9c37..4995b6e22335 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -6,30 +6,27 @@
  */
 
 #include <asm/neon.h>
-#include <asm/simd.h>
-#include <linux/unaligned.h>
 #include <crypto/aes.h>
-#include <crypto/gcm.h>
-#include <crypto/algapi.h>
 #include <crypto/b128ops.h>
+#include <crypto/gcm.h>
+#include <crypto/ghash.h>
 #include <crypto/gf128mul.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 MODULE_DESCRIPTION("GHASH and AES-GCM using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("ghash");
 
-#define GHASH_BLOCK_SIZE	16
-#define GHASH_DIGEST_SIZE	16
-
 #define RFC4106_NONCE_SIZE	4
 
 struct ghash_key {
@@ -37,10 +34,8 @@ struct ghash_key {
 	u64			h[][2];
 };
 
-struct ghash_desc_ctx {
+struct arm_ghash_desc_ctx {
 	u64 digest[GHASH_DIGEST_SIZE/sizeof(u64)];
-	u8 buf[GHASH_BLOCK_SIZE];
-	u32 count;
 };
 
 struct gcm_aes_ctx {
@@ -65,36 +60,12 @@ asmlinkage int pmull_gcm_decrypt(int bytes, u8 dst[], const u8 src[],
 
 static int ghash_init(struct shash_desc *desc)
 {
-	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	*ctx = (struct ghash_desc_ctx){};
+	*ctx = (struct arm_ghash_desc_ctx){};
 	return 0;
 }
 
-static void ghash_do_update(int blocks, u64 dg[], const char *src,
-			    struct ghash_key *key, const char *head)
-{
-	be128 dst = { cpu_to_be64(dg[1]), cpu_to_be64(dg[0]) };
-
-	do {
-		const u8 *in = src;
-
-		if (head) {
-			in = head;
-			blocks++;
-			head = NULL;
-		} else {
-			src += GHASH_BLOCK_SIZE;
-		}
-
-		crypto_xor((u8 *)&dst, in, GHASH_BLOCK_SIZE);
-		gf128mul_lle(&dst, &key->k);
-	} while (--blocks);
-
-	dg[0] = be64_to_cpu(dst.b);
-	dg[1] = be64_to_cpu(dst.a);
-}
-
 static __always_inline
 void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
 			  struct ghash_key *key, const char *head,
@@ -103,13 +74,9 @@ void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
 					      u64 const h[][2],
 					      const char *head))
 {
-	if (likely(crypto_simd_usable())) {
-		kernel_neon_begin();
-		simd_update(blocks, dg, src, key->h, head);
-		kernel_neon_end();
-	} else {
-		ghash_do_update(blocks, dg, src, key, head);
-	}
+	kernel_neon_begin();
+	simd_update(blocks, dg, src, key->h, head);
+	kernel_neon_end();
 }
 
 /* avoid hogging the CPU for too long */
@@ -118,63 +85,61 @@ void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
 static int ghash_update(struct shash_desc *desc, const u8 *src,
 			unsigned int len)
 {
-	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int partial = ctx->count % GHASH_BLOCK_SIZE;
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct ghash_key *key = crypto_shash_ctx(desc->tfm);
+	int blocks;
 
-	ctx->count += len;
+	blocks = len / GHASH_BLOCK_SIZE;
+	len -= blocks * GHASH_BLOCK_SIZE;
 
-	if ((partial + len) >= GHASH_BLOCK_SIZE) {
-		struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-		int blocks;
+	do {
+		int chunk = min(blocks, MAX_BLOCKS);
 
-		if (partial) {
-			int p = GHASH_BLOCK_SIZE - partial;
+		ghash_do_simd_update(chunk, ctx->digest, src, key, NULL,
+				     pmull_ghash_update_p8);
+		blocks -= chunk;
+		src += chunk * GHASH_BLOCK_SIZE;
+	} while (unlikely(blocks > 0));
+	return len;
+}
 
-			memcpy(ctx->buf + partial, src, p);
-			src += p;
-			len -= p;
-		}
+static int ghash_export(struct shash_desc *desc, void *out)
+{
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	u8 *dst = out;
 
-		blocks = len / GHASH_BLOCK_SIZE;
-		len %= GHASH_BLOCK_SIZE;
-
-		do {
-			int chunk = min(blocks, MAX_BLOCKS);
-
-			ghash_do_simd_update(chunk, ctx->digest, src, key,
-					     partial ? ctx->buf : NULL,
-					     pmull_ghash_update_p8);
-
-			blocks -= chunk;
-			src += chunk * GHASH_BLOCK_SIZE;
-			partial = 0;
-		} while (unlikely(blocks > 0));
-	}
-	if (len)
-		memcpy(ctx->buf + partial, src, len);
+	put_unaligned_be64(ctx->digest[1], dst);
+	put_unaligned_be64(ctx->digest[0], dst + 8);
 	return 0;
 }
 
-static int ghash_final(struct shash_desc *desc, u8 *dst)
+static int ghash_import(struct shash_desc *desc, const void *in)
 {
-	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int partial = ctx->count % GHASH_BLOCK_SIZE;
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	const u8 *src = in;
 
-	if (partial) {
-		struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-
-		memset(ctx->buf + partial, 0, GHASH_BLOCK_SIZE - partial);
-
-		ghash_do_simd_update(1, ctx->digest, ctx->buf, key, NULL,
-				     pmull_ghash_update_p8);
-	}
-	put_unaligned_be64(ctx->digest[1], dst);
-	put_unaligned_be64(ctx->digest[0], dst + 8);
-
-	memzero_explicit(ctx, sizeof(*ctx));
+	ctx->digest[1] = get_unaligned_be64(src);
+	ctx->digest[0] = get_unaligned_be64(src + 8);
 	return 0;
 }
 
+static int ghash_finup(struct shash_desc *desc, const u8 *src,
+		       unsigned int len, u8 *dst)
+{
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct ghash_key *key = crypto_shash_ctx(desc->tfm);
+
+	if (len) {
+		u8 buf[GHASH_BLOCK_SIZE] = {};
+
+		memcpy(buf, src, len);
+		ghash_do_simd_update(1, ctx->digest, src, key, NULL,
+				     pmull_ghash_update_p8);
+		memzero_explicit(buf, sizeof(buf));
+	}
+	return ghash_export(desc, dst);
+}
+
 static void ghash_reflect(u64 h[], const be128 *k)
 {
 	u64 carry = be64_to_cpu(k->a) & BIT(63) ? 1 : 0;
@@ -205,6 +170,7 @@ static struct shash_alg ghash_alg = {
 	.base.cra_name		= "ghash",
 	.base.cra_driver_name	= "ghash-neon",
 	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct ghash_key) + sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
@@ -212,9 +178,12 @@ static struct shash_alg ghash_alg = {
 	.digestsize		= GHASH_DIGEST_SIZE,
 	.init			= ghash_init,
 	.update			= ghash_update,
-	.final			= ghash_final,
+	.finup			= ghash_finup,
 	.setkey			= ghash_setkey,
-	.descsize		= sizeof(struct ghash_desc_ctx),
+	.export			= ghash_export,
+	.import			= ghash_import,
+	.descsize		= sizeof(struct arm_ghash_desc_ctx),
+	.statesize		= sizeof(struct ghash_desc_ctx),
 };
 
 static int num_rounds(struct crypto_aes_ctx *ctx)
-- 
2.39.5

