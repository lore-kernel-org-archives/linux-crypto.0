Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3734E26989D
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945198; cv=none; b=e0O8NF91flK+CEC11QrrNEg0G5/VKX4f3vKJWmBZmRzq5YgGhaWtg0Ve1+9+camDoOJJHV79fNKUX219QBG47fDac9BcXaZfiPgGgzZCVObGKEwbggiAIKyOq00Iy7NpXW+n+zWgfN/vJYE2V6s6KPOXw4b+n5SBeGPoZxHCLiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945198; c=relaxed/simple;
	bh=nhl9IjgXyB+Lem9FnIIyVxbkefTJYGHg5HvBojrNqMQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Kv3Mk9NFMZxSNKbyeRg21938x5W12h0B0HPlslRCQXe/sID8IZLEYvF+zBEZH5t/tZPo0KhNqsYpWB/bEsvEoCpXAvUmeZqwZ2Xb0lRffpCFT5eA+UmRqYnthYDtvPdhvM3Ct/pZVV71DeSW1RjU67toaEovcrD6QBs2rW9JduM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SFTNodvY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SFTNodvY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JNI2XEsu5568TnyzsZojHx46a5dkC+22gxeHO7c1xFs=; b=SFTNodvYQgjTwLrDp1+HRygdI5
	qO2SHS3d0q2gBI1DwpuWCqacXhI1cUT++DL57S/GXaBZFR+/+Cip7IdpPAJBMbh+a5f3fy+JhQK6J
	QYjHdsRPV+UO85aykPjDB/0E36TuWkzNfq/pE6EpATc47Dl2Mzabauw3xVNHMCT1ZR/orNg8Fkz6Y
	fHzqoNibMMG7NE56UiL7LpkS9lRl4RZlQSh0gxEx9tFwGg0jRN2A8BFl/QvPPGjazYho+UXsDcEpZ
	St5bM4fnGpbAZDvNSSAUb8jCdTE5sa9MPrwW/JLJqupAjhafIPow/UQygbw4ZN0JIwctFQDgoJOyu
	Hxf2SE2A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxI-00Ge9C-2P;
	Fri, 18 Apr 2025 10:59:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:52 +0800
Date: Fri, 18 Apr 2025 10:59:52 +0800
Message-Id: <bcb766ebd8c11d5bf3176359a0b863d5ebc289b9.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 32/67] crypto: arm/sha256-neon - Use API partial block
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
 arch/arm/crypto/sha256_neon_glue.c | 49 ++++++++++--------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha256_neon_glue.c
index ccdcfff71910..76eb3cdc21c9 100644
--- a/arch/arm/crypto/sha256_neon_glue.c
+++ b/arch/arm/crypto/sha256_neon_glue.c
@@ -9,69 +9,51 @@
  *   Copyright © 2014 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  */
 
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <linux/types.h>
-#include <linux/string.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
-#include <asm/byteorder.h>
-#include <asm/simd.h>
-#include <asm/neon.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "sha256_glue.h"
 
-asmlinkage void sha256_block_data_order_neon(struct sha256_state *digest,
-					     const u8 *data, int num_blks);
+asmlinkage void sha256_block_data_order_neon(
+	struct crypto_sha256_state *digest, const u8 *data, int num_blks);
 
 static int crypto_sha256_neon_update(struct shash_desc *desc, const u8 *data,
 				     unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
-		return crypto_sha256_arm_update(desc, data, len);
+	int remain;
 
 	kernel_neon_begin();
-	sha256_base_do_update(desc, data, len, sha256_block_data_order_neon);
+	remain = sha256_base_do_update_blocks(desc, data, len,
+					      sha256_block_data_order_neon);
 	kernel_neon_end();
-
-	return 0;
+	return remain;
 }
 
 static int crypto_sha256_neon_finup(struct shash_desc *desc, const u8 *data,
 				    unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable())
-		return crypto_sha256_arm_finup(desc, data, len, out);
-
 	kernel_neon_begin();
-	if (len)
-		sha256_base_do_update(desc, data, len,
-				      sha256_block_data_order_neon);
-	sha256_base_do_finalize(desc, sha256_block_data_order_neon);
+	sha256_base_do_finup(desc, data, len, sha256_block_data_order_neon);
 	kernel_neon_end();
-
 	return sha256_base_finish(desc, out);
 }
 
-static int crypto_sha256_neon_final(struct shash_desc *desc, u8 *out)
-{
-	return crypto_sha256_neon_finup(desc, NULL, 0, out);
-}
-
 struct shash_alg sha256_neon_algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	crypto_sha256_neon_update,
-	.final		=	crypto_sha256_neon_final,
 	.finup		=	crypto_sha256_neon_finup,
-	.descsize	=	sizeof(struct sha256_state),
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-neon",
 		.cra_priority	=	250,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -79,13 +61,14 @@ struct shash_alg sha256_neon_algs[] = { {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_base_init,
 	.update		=	crypto_sha256_neon_update,
-	.final		=	crypto_sha256_neon_final,
 	.finup		=	crypto_sha256_neon_finup,
-	.descsize	=	sizeof(struct sha256_state),
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name =	"sha224-neon",
 		.cra_priority	=	250,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

