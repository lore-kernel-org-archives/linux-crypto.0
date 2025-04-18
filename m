Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB33E2698AF
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945202; cv=none; b=El0AWlBUY8pNd91pYr2ELsBMhzeJ74/wEmBqePF/pIAwmVaV0WaN4grtfD7EjdMNK1scSAsOS4MEOsZF5xuNQU7ijIAlwLah80FLWhBIdSkV4vIBiHdQ1W98t0dzNJX7PqezWLLD7LyASeGlfKPES2i08tUunu30LIurzc+GZhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945202; c=relaxed/simple;
	bh=EzQTdQX4nKOaG+NE29ABjG5Kd1ERn4XcEi0KFs0a6zo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=t7AzhKZ3crJbdSkxjQyKfE4AcqFbGMZjv7+bk47ILj/nEwgM8u3CluCFCuC8PrXo9AnDSIKqQ0Yo3LRw9WTIbodFKCfdmwgjqZEM1vT1EU1uGUFBeBphCfI9GHSfTyyEdnAo0jiUT1F6FGTOvMou8W5mxJklKuYoM6F4N7KjrhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UncVz3Ms; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UncVz3Ms"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Weml+9fW5NJY0MlmDSp0+EubRWyD/Ar09KevBxT+8Vs=; b=UncVz3Msq/8RPiMX1HJVPQZnke
	IlKScbV02l8QRQ3TOO/aBqwQVQCg7ouu4lRwgT2mQ7F4wR4w6l4ObZq19MrsaEWXM8fpgJ7XkY3A5
	+pQcZk7wHl7WvGNOhFJL0wB7hMPp/MGd8m9EKn2gwpoZxEkwLRHL2ZLv/6993U5EIPQ0mHeE3b8wH
	YC7QFtYpDiz6gGoFnA9mMnTK3Wgj+9fwWDT5XF0BQfbITAx9Owwi6NVixQuj7MD1RpOXG0heB3nFd
	HjpDnNwz0E/jZTN/FxWtxdwwjTpkWwRsoGJ7L/dAwD8/iIlTEDYexiSgHkI+iLJnvtPWh3HdnZ60B
	g7hi5Ssw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxN-00Ge9Y-0y;
	Fri, 18 Apr 2025 10:59:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:57 +0800
Date: Fri, 18 Apr 2025 10:59:57 +0800
Message-Id: <fc0f2a83f1507b149d33d0f9369cf1eef8eb7b79.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 34/67] crypto: arm64/sha256-ce - Use API partial block
 handling
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
 arch/arm64/crypto/sha2-ce-glue.c | 90 +++++++-------------------------
 1 file changed, 18 insertions(+), 72 deletions(-)

diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 6b4866a88ded..912c215101eb 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -6,15 +6,13 @@
  */
 
 #include <asm/neon.h>
-#include <asm/simd.h>
-#include <linux/unaligned.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
@@ -23,7 +21,7 @@ MODULE_ALIAS_CRYPTO("sha224");
 MODULE_ALIAS_CRYPTO("sha256");
 
 struct sha256_ce_state {
-	struct sha256_state	sst;
+	struct crypto_sha256_state sst;
 	u32			finalize;
 };
 
@@ -33,7 +31,7 @@ extern const u32 sha256_ce_offsetof_finalize;
 asmlinkage int __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
 				     int blocks);
 
-static void sha256_ce_transform(struct sha256_state *sst, u8 const *src,
+static void sha256_ce_transform(struct crypto_sha256_state *sst, u8 const *src,
 				int blocks)
 {
 	while (blocks) {
@@ -54,42 +52,21 @@ const u32 sha256_ce_offsetof_count = offsetof(struct sha256_ce_state,
 const u32 sha256_ce_offsetof_finalize = offsetof(struct sha256_ce_state,
 						 finalize);
 
-asmlinkage void sha256_block_data_order(u32 *digest, u8 const *src, int blocks);
-
-static void sha256_arm64_transform(struct sha256_state *sst, u8 const *src,
-				   int blocks)
-{
-	sha256_block_data_order(sst->state, src, blocks);
-}
-
 static int sha256_ce_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 
-	if (!crypto_simd_usable())
-		return sha256_base_do_update(desc, data, len,
-					     sha256_arm64_transform);
-
 	sctx->finalize = 0;
-	sha256_base_do_update(desc, data, len, sha256_ce_transform);
-
-	return 0;
+	return sha256_base_do_update_blocks(desc, data, len,
+					    sha256_ce_transform);
 }
 
 static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 			   unsigned int len, u8 *out)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
-	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE) && len;
-
-	if (!crypto_simd_usable()) {
-		if (len)
-			sha256_base_do_update(desc, data, len,
-					      sha256_arm64_transform);
-		sha256_base_do_finalize(desc, sha256_arm64_transform);
-		return sha256_base_finish(desc, out);
-	}
+	bool finalize = !(len % SHA256_BLOCK_SIZE) && len;
 
 	/*
 	 * Allow the asm code to perform the finalization if there is no
@@ -97,23 +74,11 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 	 */
 	sctx->finalize = finalize;
 
-	sha256_base_do_update(desc, data, len, sha256_ce_transform);
-	if (!finalize)
-		sha256_base_do_finalize(desc, sha256_ce_transform);
-	return sha256_base_finish(desc, out);
-}
-
-static int sha256_ce_final(struct shash_desc *desc, u8 *out)
-{
-	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable()) {
-		sha256_base_do_finalize(desc, sha256_arm64_transform);
-		return sha256_base_finish(desc, out);
-	}
-
-	sctx->finalize = 0;
-	sha256_base_do_finalize(desc, sha256_ce_transform);
+	if (finalize)
+		sha256_base_do_update_blocks(desc, data, len,
+					     sha256_ce_transform);
+	else
+		sha256_base_do_finup(desc, data, len, sha256_ce_transform);
 	return sha256_base_finish(desc, out);
 }
 
@@ -124,55 +89,36 @@ static int sha256_ce_digest(struct shash_desc *desc, const u8 *data,
 	return sha256_ce_finup(desc, data, len, out);
 }
 
-static int sha256_ce_export(struct shash_desc *desc, void *out)
-{
-	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, &sctx->sst, sizeof(struct sha256_state));
-	return 0;
-}
-
-static int sha256_ce_import(struct shash_desc *desc, const void *in)
-{
-	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(&sctx->sst, in, sizeof(struct sha256_state));
-	sctx->finalize = 0;
-	return 0;
-}
-
 static struct shash_alg algs[] = { {
 	.init			= sha224_base_init,
 	.update			= sha256_ce_update,
-	.final			= sha256_ce_final,
 	.finup			= sha256_ce_finup,
-	.export			= sha256_ce_export,
-	.import			= sha256_ce_import,
 	.descsize		= sizeof(struct sha256_ce_state),
-	.statesize		= sizeof(struct sha256_state),
+	.statesize		= sizeof(struct crypto_sha256_state),
 	.digestsize		= SHA224_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha224",
 		.cra_driver_name	= "sha224-ce",
 		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
 }, {
 	.init			= sha256_base_init,
 	.update			= sha256_ce_update,
-	.final			= sha256_ce_final,
 	.finup			= sha256_ce_finup,
 	.digest			= sha256_ce_digest,
-	.export			= sha256_ce_export,
-	.import			= sha256_ce_import,
 	.descsize		= sizeof(struct sha256_ce_state),
-	.statesize		= sizeof(struct sha256_state),
+	.statesize		= sizeof(struct crypto_sha256_state),
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha256",
 		.cra_driver_name	= "sha256-ce",
 		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
-- 
2.39.5

