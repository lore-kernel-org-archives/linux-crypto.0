Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77F22356BD
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785814; cv=none; b=Iw66z+lfyM0w6B6oU6RmqJOdqI2T9nSKEEUDAp8kIyyc3KBMo+cyg8lQ373t0n9kCtzWpK8qIlyz20G8ZAP/Vop2Un+7TBha+jJTK8bjx4LJGQNUi5+kikd2U3nxqaXYzRiazOza5XnmoF2dT+Jw1FcfNGnOSst4UkedndUCxFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785814; c=relaxed/simple;
	bh=8SQaBHwvgIVAqa1ME/+kmgtt/DpwMH+qyVnYnKXwgmI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=C7Mj7m4+G/ri/N+6f29NVgHbKX0KXreSI4CMWH4QTTGZc7reNeSI/3ga3Ysb3D17638mCoeAvb02m96bV8jg9WI8SDupQykBCwiuRjy5WYJoUmDXI2X6etKJZhpdiB3iYOfeWLHd6tDVg1VJQh7BGxU9p5GWj79jgHv6Fw21Lrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QVEM5eiW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QVEM5eiW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AHoW+JVPdbwWKRHHomw0NvRPZbYDRwWQ6N1T6GB62hw=; b=QVEM5eiWq9Ycmewg9u+GKPJmBO
	5QDk0e9A+Ojgc9YcGeq9QWaA6Yv+YJNYkZBtNu8ffe6yLJtm7IDwXOdUC1Ia1teHleqtZGGWVHToo
	kpnXKMVDoGlST/CAzY7HLhPJAmS8sqX/BqIK/Gt5ZJyj1KEqPT6iXramo6MM0VS8JNoufEaGcu4lq
	hzY5jpJnC8Rihw1faroTtN00j8K3wJq3cUotIQABT8vcRWZcID09Jbk2hOw0xo3skYEHIHF3FERqP
	XIAqA4DFq75fdUpvO7g3Zqakt/KVDATplCaLRJb3w7tfQ0T/5wV2F0h9+heWeOwYb8ZtBkWjY7Bhe
	ORxcFIPw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUb-00G6Jr-00;
	Wed, 16 Apr 2025 14:43:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:28 +0800
Date: Wed, 16 Apr 2025 14:43:28 +0800
Message-Id: <c6a85635ab8029cb6b623d60087ccf6fc10370ec.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 20/67] crypto: arm/sha1-neon - Use API partial block handling
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
 arch/arm/crypto/sha1_neon_glue.c | 39 ++++++++------------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/arch/arm/crypto/sha1_neon_glue.c b/arch/arm/crypto/sha1_neon_glue.c
index 9c70b87e69f7..d321850f22a6 100644
--- a/arch/arm/crypto/sha1_neon_glue.c
+++ b/arch/arm/crypto/sha1_neon_glue.c
@@ -13,18 +13,12 @@
  *  Copyright (c) Chandramouli Narayanan <mouli@linux.intel.com>
  */
 
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
-
-#include "sha1.h"
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 asmlinkage void sha1_transform_neon(struct sha1_state *state_h,
 				    const u8 *data, int rounds);
@@ -32,50 +26,37 @@ asmlinkage void sha1_transform_neon(struct sha1_state *state_h,
 static int sha1_neon_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
-		return sha1_update_arm(desc, data, len);
+	int remain;
 
 	kernel_neon_begin();
-	sha1_base_do_update(desc, data, len, sha1_transform_neon);
+	remain = sha1_base_do_update_blocks(desc, data, len,
+					    sha1_transform_neon);
 	kernel_neon_end();
 
-	return 0;
+	return remain;
 }
 
 static int sha1_neon_finup(struct shash_desc *desc, const u8 *data,
 			   unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable())
-		return sha1_finup_arm(desc, data, len, out);
-
 	kernel_neon_begin();
-	if (len)
-		sha1_base_do_update(desc, data, len, sha1_transform_neon);
-	sha1_base_do_finalize(desc, sha1_transform_neon);
+	sha1_base_do_finup(desc, data, len, sha1_transform_neon);
 	kernel_neon_end();
 
 	return sha1_base_finish(desc, out);
 }
 
-static int sha1_neon_final(struct shash_desc *desc, u8 *out)
-{
-	return sha1_neon_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	sha1_neon_update,
-	.final		=	sha1_neon_final,
 	.finup		=	sha1_neon_finup,
-	.descsize	=	sizeof(struct sha1_state),
+	.descsize		= SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name		= "sha1",
 		.cra_driver_name	= "sha1-neon",
 		.cra_priority		= 250,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
-- 
2.39.5

