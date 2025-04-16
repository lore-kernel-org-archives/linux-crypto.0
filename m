Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE233237194
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785839; cv=none; b=DJ6oLr4DPwOecyBzDOZq/BRBwMYYjxo7GIf8inb/dbSwnYF4Mg271e2OifPFqxD4tVj35eKQ6S/l+CTIWZLyBToRQK6IhXFU/A0fC+PTIJgC+u6rhciiGxMAIeQZ/I8693yVtLcLMy7lTtm9wR3ehAXF1JqSIfFAgvERsvyF3Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785839; c=relaxed/simple;
	bh=aj7iwrEy9Elxa7xsvH4BzZih7fRgyX3JZ4i9wpM7X2w=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=mhuDO9nAC0uZyXHx9xO4Re4zuQX0m5TLU28nqWzglsLun7dzgovG/deCoO+sVudGwELCMyzwYa/W69F5vk6DUHI2xdcmV9v92bH4GGyS0nxi3RjzMbGVHRKfhT7RO9h6PqXqcppkxG6iV7RFcGkAidjLf7QFI52Jsjw1H5BcHcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CyO1X9lu; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CyO1X9lu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0kqRMywYfo5lO5nH4iqtFmMithplzjI2yVpEq0p61Yw=; b=CyO1X9lug4Ki2lOr5gFyJG7T6a
	V3oV78AUjpxEmmQee0IfPY9nOm2HgIDjWjTZ8FjLm8auzyGxV36zuUfbyb6Y23orx77gk09yVDYUr
	kNxaGiGflvtNaxy330fv8wO1goILIygrq1QYVl+kYyVjOypcKLO1xonnaGSsrZdhzbW5qIC04x31Z
	I8VPQ8lpav3DL2NZce0GdeMTJhGMMkKPoBQz55He6xp6ans4aWlJaiMtgGVMpCVi6N2tu/50tNf0d
	xHEk7uPT1iuWRI8VPjyqYi4uCqC0C1SQItHUCXCIEfwxo6XEX3B291a+PQUfbjASwBiaC2XDVdyvD
	yCXC2XsQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wV0-00G6MF-0s;
	Wed, 16 Apr 2025 14:43:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:54 +0800
Date: Wed, 16 Apr 2025 14:43:54 +0800
Message-Id: <c7ff0e712f96c54ce1dcd044815335ac38e7f5f7.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 31/67] crypto: arm/sha256-ce - Use API partial block handling
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
 arch/arm/crypto/sha2-ce-glue.c | 52 ++++++++++------------------------
 1 file changed, 15 insertions(+), 37 deletions(-)

diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
index aeac45bfbf9f..1e9d16f79678 100644
--- a/arch/arm/crypto/sha2-ce-glue.c
+++ b/arch/arm/crypto/sha2-ce-glue.c
@@ -5,91 +5,69 @@
  * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <asm/hwcap.h>
-#include <asm/simd.h>
-#include <asm/neon.h>
-#include <linux/unaligned.h>
-
-#include "sha256_glue.h"
-
 MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
-asmlinkage void sha2_ce_transform(struct sha256_state *sst, u8 const *src,
-				  int blocks);
+asmlinkage void sha2_ce_transform(struct crypto_sha256_state *sst,
+				  u8 const *src, int blocks);
 
 static int sha2_ce_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
-		return crypto_sha256_arm_update(desc, data, len);
+	int remain;
 
 	kernel_neon_begin();
-	sha256_base_do_update(desc, data, len,
-			      (sha256_block_fn *)sha2_ce_transform);
+	remain = sha256_base_do_update_blocks(desc, data, len,
+					      sha2_ce_transform);
 	kernel_neon_end();
-
-	return 0;
+	return remain;
 }
 
 static int sha2_ce_finup(struct shash_desc *desc, const u8 *data,
 			 unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable())
-		return crypto_sha256_arm_finup(desc, data, len, out);
-
 	kernel_neon_begin();
-	if (len)
-		sha256_base_do_update(desc, data, len,
-				      (sha256_block_fn *)sha2_ce_transform);
-	sha256_base_do_finalize(desc, (sha256_block_fn *)sha2_ce_transform);
+	sha256_base_do_finup(desc, data, len, sha2_ce_transform);
 	kernel_neon_end();
-
 	return sha256_base_finish(desc, out);
 }
 
-static int sha2_ce_final(struct shash_desc *desc, u8 *out)
-{
-	return sha2_ce_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg algs[] = { {
 	.init			= sha224_base_init,
 	.update			= sha2_ce_update,
-	.final			= sha2_ce_final,
 	.finup			= sha2_ce_finup,
-	.descsize		= sizeof(struct sha256_state),
+	.descsize		= sizeof(struct crypto_sha256_state),
 	.digestsize		= SHA224_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha224",
 		.cra_driver_name	= "sha224-ce",
 		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
 }, {
 	.init			= sha256_base_init,
 	.update			= sha2_ce_update,
-	.final			= sha2_ce_final,
 	.finup			= sha2_ce_finup,
-	.descsize		= sizeof(struct sha256_state),
+	.descsize		= sizeof(struct crypto_sha256_state),
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha256",
 		.cra_driver_name	= "sha256-ce",
 		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
-- 
2.39.5

