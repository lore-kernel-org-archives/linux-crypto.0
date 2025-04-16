Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79CD22F147
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785844; cv=none; b=TrFr7jOrkMeD52EBbouTaEPSiuRNSNapaSdnoX9IsZP83ux/h7vHBjQmxxaXMjjdLeMvPIfKeaTdekhz0R1Z9ZiytCZh3EKDxeOx3VpspdwLAX3dOxPU7h5Ug0UtYWDzOfqLDzqgaTDibgC+hOJ1tP5JR4r0TRTA8e8SCgm0reY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785844; c=relaxed/simple;
	bh=hTwiBRcB10QL+oWMMGu++FGbFMCh/YAYbdSp5Hxv3HY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=asxXjXCeaohr7YT7ByR1vzpLIsn2Pf4kOcXtFnaLkk/YbiBmUrdAZvNbIfHXIYV6OcbJCj+hX+SJi3VMssfu2WdiH8BxJZY+RUF5SI9BOLV9jbdQOVB7kDSGctrkNUr50uG8UK1D4mCL0skeptfvdU6UKOsdu0G/GXwH+Mx4Cjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N8V0d7Tv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N8V0d7Tv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vk4AQ9B/4RhliO+I8I8LQ7FoE0p8G3zJOspwra+LZMk=; b=N8V0d7Tv6of3k0Cp0pYTwzajSm
	1STSaFGQspLUP8H+FT1E8uafHtWxm8D//V5Qbi3k9R4BsoiWjR5TEVZPsb+x8c+kUf8N9/QXl2VQ+
	aCu8Uh2/Yo7vQOPfCvveNBD25bg8gyCZiVhao0pCBbs/2xvWmpsQ6JBdgLkzIgGh+JTnQ89P3YJge
	iPgL5NM5L/hHU0FozuoSlB/czHiVvqU7ZK+abCIDEclBXldHYHTUEqx+gCEdAm/kUTSVDNBrcZBqY
	N6u+CxutYjKjNIhGtW1BlgpnFmR/Jsq3uaCfmXSACcT2YoV1W7ZXxNzjT2z9Z3RZo3z725UTMgmL/
	2TJjXNjQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wV4-00G6Mb-2q;
	Wed, 16 Apr 2025 14:43:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:58 +0800
Date: Wed, 16 Apr 2025 14:43:58 +0800
Message-Id: <0578d123898c3131a4b12bef607174e13fb09972.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 33/67] crypto: arm/sha256-asm - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/sha256_glue.c | 46 ++++++++++++++---------------------
 arch/arm/crypto/sha256_glue.h |  8 +-----
 2 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/arch/arm/crypto/sha256_glue.c b/arch/arm/crypto/sha256_glue.c
index f85933fdec75..d04c4e6bae6d 100644
--- a/arch/arm/crypto/sha256_glue.c
+++ b/arch/arm/crypto/sha256_glue.c
@@ -10,58 +10,47 @@
  *   Author: Tim Chen <tim.c.chen@linux.intel.com>
  */
 
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
-#include <linux/crypto.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
-#include <linux/string.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
-#include <asm/simd.h>
-#include <asm/neon.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "sha256_glue.h"
 
-asmlinkage void sha256_block_data_order(struct sha256_state *state,
+asmlinkage void sha256_block_data_order(struct crypto_sha256_state *state,
 					const u8 *data, int num_blks);
 
-int crypto_sha256_arm_update(struct shash_desc *desc, const u8 *data,
-			     unsigned int len)
+static int crypto_sha256_arm_update(struct shash_desc *desc, const u8 *data,
+				    unsigned int len)
 {
 	/* make sure casting to sha256_block_fn() is safe */
-	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
+	BUILD_BUG_ON(offsetof(struct crypto_sha256_state, state) != 0);
 
-	return sha256_base_do_update(desc, data, len, sha256_block_data_order);
+	return sha256_base_do_update_blocks(desc, data, len,
+					    sha256_block_data_order);
 }
-EXPORT_SYMBOL(crypto_sha256_arm_update);
 
-static int crypto_sha256_arm_final(struct shash_desc *desc, u8 *out)
+static int crypto_sha256_arm_finup(struct shash_desc *desc, const u8 *data,
+				   unsigned int len, u8 *out)
 {
-	sha256_base_do_finalize(desc, sha256_block_data_order);
+	sha256_base_do_finup(desc, data, len, sha256_block_data_order);
 	return sha256_base_finish(desc, out);
 }
 
-int crypto_sha256_arm_finup(struct shash_desc *desc, const u8 *data,
-			    unsigned int len, u8 *out)
-{
-	sha256_base_do_update(desc, data, len, sha256_block_data_order);
-	return crypto_sha256_arm_final(desc, out);
-}
-EXPORT_SYMBOL(crypto_sha256_arm_finup);
-
 static struct shash_alg algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	crypto_sha256_arm_update,
-	.final		=	crypto_sha256_arm_final,
 	.finup		=	crypto_sha256_arm_finup,
-	.descsize	=	sizeof(struct sha256_state),
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-asm",
 		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -69,13 +58,14 @@ static struct shash_alg algs[] = { {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_base_init,
 	.update		=	crypto_sha256_arm_update,
-	.final		=	crypto_sha256_arm_final,
 	.finup		=	crypto_sha256_arm_finup,
-	.descsize	=	sizeof(struct sha256_state),
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name =	"sha224-asm",
 		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
diff --git a/arch/arm/crypto/sha256_glue.h b/arch/arm/crypto/sha256_glue.h
index 9f0d578bab5f..9881c9a115d1 100644
--- a/arch/arm/crypto/sha256_glue.h
+++ b/arch/arm/crypto/sha256_glue.h
@@ -2,14 +2,8 @@
 #ifndef _CRYPTO_SHA256_GLUE_H
 #define _CRYPTO_SHA256_GLUE_H
 
-#include <linux/crypto.h>
+#include <crypto/hash.h>
 
 extern struct shash_alg sha256_neon_algs[2];
 
-int crypto_sha256_arm_update(struct shash_desc *desc, const u8 *data,
-			     unsigned int len);
-
-int crypto_sha256_arm_finup(struct shash_desc *desc, const u8 *data,
-			    unsigned int len, u8 *hash);
-
 #endif /* _CRYPTO_SHA256_GLUE_H */
-- 
2.39.5

