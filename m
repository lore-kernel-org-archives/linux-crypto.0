Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8A622B8A7
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785883; cv=none; b=PsO5E1hbglRly4NIPt0kIoMzIXYPvXtiiy57zcs8s5r9G36D2nldQGXjGrlZiFUJVMEQcge4eA5I4PgKJI9Wgb/WpJkSAMrD/zjD00TlJFKeAMasbfCRSu3gttpptxuLGXQHq/x1E47PgtJhXiAhiMiLdg4srEiKPbezq8rlT+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785883; c=relaxed/simple;
	bh=gYZH+Vqo109zeyYwqDdRwIXBNPTJXfJKJNJejmv7QtE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=eCjJKYw9eRX2MgNvsF9lpgV2BZJgAfFEqTdGiKeENiFnMjgZBZfrWRrc4OINCxob275/7P6Mbm1yuJZ3roQliiWRgovNvOdbwwDw7g+a4/fKrXsX4c0xdGVOz0x4CIE9hQYkAf6s3ovb85eKAgqeNFxMLPsLsUe7L71aznLgx7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SQLe0+/h; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SQLe0+/h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TY11+pDWY2ylq+3e5vyuVPraIVXbyt6c+7SP/PFvlfQ=; b=SQLe0+/hKC8cuuPiRTTRTs3ErJ
	yPv4f3pkTxPKrDaxaRlObgDH6U4M+wkMnNuFmDZVTL7rQvixCAqzrhQwbWSvQJEgA7/6r5FNGqEGn
	uK8ZORoTx8SLgdSFNQA0Mg+zsZVvdVpwkHM09Q7+3FfT9WRdWHo5y6m/N8rHnZsb6OVY+fFXtbUNU
	f38biSFCXzIu8IMQJVR5PK1dmAJ3omG3rex7eXY641uRri6XY9vA+UsxMfLS5xHI8sWuUhh7gmmFV
	73dB3HssGHtKXaYrYHfqdYWw96xLDjtOMKIFvdxzbyM+U0xyf0lfZJ7ux+dNw2JcwJKKKcn/iOtWR
	xIQ8bBuQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVi-00G6QJ-0h;
	Wed, 16 Apr 2025 14:44:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:38 +0800
Date: Wed, 16 Apr 2025 14:44:38 +0800
Message-Id: <40ba9848bba723f73096ae178e8ed235d3fcd6dc.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 50/67] crypto: arm64/sha512-ce - Use API partial block
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
 arch/arm64/crypto/sha512-ce-glue.c | 49 ++++++++----------------------
 1 file changed, 12 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/crypto/sha512-ce-glue.c b/arch/arm64/crypto/sha512-ce-glue.c
index 071f64293227..6fb3001fa2c9 100644
--- a/arch/arm64/crypto/sha512-ce-glue.c
+++ b/arch/arm64/crypto/sha512-ce-glue.c
@@ -10,14 +10,11 @@
  */
 
 #include <asm/neon.h>
-#include <asm/simd.h>
-#include <linux/unaligned.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/sha2.h>
 #include <crypto/sha512_base.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
 MODULE_DESCRIPTION("SHA-384/SHA-512 secure hash using ARMv8 Crypto Extensions");
@@ -29,12 +26,10 @@ MODULE_ALIAS_CRYPTO("sha512");
 asmlinkage int __sha512_ce_transform(struct sha512_state *sst, u8 const *src,
 				     int blocks);
 
-asmlinkage void sha512_block_data_order(u64 *digest, u8 const *src, int blocks);
-
 static void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
 				int blocks)
 {
-	while (blocks) {
+	do {
 		int rem;
 
 		kernel_neon_begin();
@@ -42,67 +37,47 @@ static void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
 		kernel_neon_end();
 		src += (blocks - rem) * SHA512_BLOCK_SIZE;
 		blocks = rem;
-	}
-}
-
-static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
-				   int blocks)
-{
-	sha512_block_data_order(sst->state, src, blocks);
+	} while (blocks);
 }
 
 static int sha512_ce_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
-	sha512_block_fn *fn = crypto_simd_usable() ? sha512_ce_transform
-						   : sha512_arm64_transform;
-
-	sha512_base_do_update(desc, data, len, fn);
-	return 0;
+	return sha512_base_do_update_blocks(desc, data, len,
+					    sha512_ce_transform);
 }
 
 static int sha512_ce_finup(struct shash_desc *desc, const u8 *data,
 			   unsigned int len, u8 *out)
 {
-	sha512_block_fn *fn = crypto_simd_usable() ? sha512_ce_transform
-						   : sha512_arm64_transform;
-
-	sha512_base_do_update(desc, data, len, fn);
-	sha512_base_do_finalize(desc, fn);
-	return sha512_base_finish(desc, out);
-}
-
-static int sha512_ce_final(struct shash_desc *desc, u8 *out)
-{
-	sha512_block_fn *fn = crypto_simd_usable() ? sha512_ce_transform
-						   : sha512_arm64_transform;
-
-	sha512_base_do_finalize(desc, fn);
+	sha512_base_do_finup(desc, data, len, sha512_ce_transform);
 	return sha512_base_finish(desc, out);
 }
 
 static struct shash_alg algs[] = { {
 	.init			= sha384_base_init,
 	.update			= sha512_ce_update,
-	.final			= sha512_ce_final,
 	.finup			= sha512_ce_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.digestsize		= SHA384_DIGEST_SIZE,
 	.base.cra_name		= "sha384",
 	.base.cra_driver_name	= "sha384-ce",
 	.base.cra_priority	= 200,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA512_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.init			= sha512_base_init,
 	.update			= sha512_ce_update,
-	.final			= sha512_ce_final,
 	.finup			= sha512_ce_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.digestsize		= SHA512_DIGEST_SIZE,
 	.base.cra_name		= "sha512",
 	.base.cra_driver_name	= "sha512-ce",
 	.base.cra_priority	= 200,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA512_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 } };
-- 
2.39.5

