Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE18267F79
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945235; cv=none; b=INS/Eo97vQXy/OmPjoa2W1oFzKAc6JvwiYkndaCAaEesLdgQ2z0Mwx26WoNIsv5Ex9YWnYgYJH5UbEmiqVHZYhDTnIkQVWmet45Hfbikpi2UARrLo5RsJ4U1a1561EoUgXNPgyN8svEL8/jA5KX1o8uBC4xqtItMER0QW1codhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945235; c=relaxed/simple;
	bh=WFel2lcfF40CtI+5pi/mtEJYsjfb1jByfwxae7FUOkQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=M45xVTfDpFiQd3Hxboyok+TUKmUki477VhTidoZxbSCJE1u31JQ3mvqb7QQPoCV5Fy4N2XpfMvmlHBw8bTzI5jIj7kjBb4MP2m8uP7d0HX58UxamRGLWFmU1TsXEU1U2XxT3NxKd0Snt3lqWJRfp6/vovb/lvt6Jk8hY4EDQfvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DSHCUBZd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DSHCUBZd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pbRt3upg29IOkf4ssPbIGkAzvj/4gxMnCwkRnKI5ONU=; b=DSHCUBZdqBpb1BSxF/90Oizjmz
	8DQYzCC1eGo+ObDs+1xfC9KHd6Z+yUHqWJIE1rYwyKVFKFK+I3l8VriWBOCB+TAMnmR1/6Z4Ky8lL
	jaALOe17stuIUmE7h8kUNDZsNc3Z5Q5+o1L+qZhxzN2X6S66ylSE9pUWJmWUnhQ3B9LMnYigBo2e5
	bfNCBfxVT2w0nQDzwEY65BXFF249VgmIEZ+aWDtVZQDTZ/CeMCRNNraNebQGuModakvU0JsBUztKO
	S5S4bxCs6xwN9uC8fG17piyA1gfscFeSilDLwGUwGz4snnpr8O6hj1ec6O5W8Gjlxk9Wg2dMwHl9K
	oSpWsvfQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxt-00GeDj-2G;
	Fri, 18 Apr 2025 11:00:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:29 +0800
Date: Fri, 18 Apr 2025 11:00:29 +0800
Message-Id: <ddabceae4bd4ac11035c92649ad964c99ff3f97e.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 48/67] crypto: arm/sha512-neon - Use API partial block
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
 arch/arm/crypto/sha512-neon-glue.c | 43 +++++++++---------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/arch/arm/crypto/sha512-neon-glue.c b/arch/arm/crypto/sha512-neon-glue.c
index c6e58fe475ac..bd528077fefb 100644
--- a/arch/arm/crypto/sha512-neon-glue.c
+++ b/arch/arm/crypto/sha512-neon-glue.c
@@ -5,16 +5,13 @@
  * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/sha2.h>
 #include <crypto/sha512_base.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <asm/simd.h>
-#include <asm/neon.h>
-
 #include "sha512.h"
 
 MODULE_ALIAS_CRYPTO("sha384-neon");
@@ -26,51 +23,36 @@ asmlinkage void sha512_block_data_order_neon(struct sha512_state *state,
 static int sha512_neon_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
-		return sha512_arm_update(desc, data, len);
+	int remain;
 
 	kernel_neon_begin();
-	sha512_base_do_update(desc, data, len, sha512_block_data_order_neon);
+	remain = sha512_base_do_update_blocks(desc, data, len,
+					      sha512_block_data_order_neon);
 	kernel_neon_end();
-
-	return 0;
+	return remain;
 }
 
 static int sha512_neon_finup(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable())
-		return sha512_arm_finup(desc, data, len, out);
-
 	kernel_neon_begin();
-	if (len)
-		sha512_base_do_update(desc, data, len,
-				      sha512_block_data_order_neon);
-	sha512_base_do_finalize(desc, sha512_block_data_order_neon);
+	sha512_base_do_finup(desc, data, len, sha512_block_data_order_neon);
 	kernel_neon_end();
-
 	return sha512_base_finish(desc, out);
 }
 
-static int sha512_neon_final(struct shash_desc *desc, u8 *out)
-{
-	return sha512_neon_finup(desc, NULL, 0, out);
-}
-
 struct shash_alg sha512_neon_algs[] = { {
 	.init			= sha384_base_init,
 	.update			= sha512_neon_update,
-	.final			= sha512_neon_final,
 	.finup			= sha512_neon_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.digestsize		= SHA384_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha384",
 		.cra_driver_name	= "sha384-neon",
 		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA384_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 
@@ -78,14 +60,15 @@ struct shash_alg sha512_neon_algs[] = { {
 },  {
 	.init			= sha512_base_init,
 	.update			= sha512_neon_update,
-	.final			= sha512_neon_final,
 	.finup			= sha512_neon_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.digestsize		= SHA512_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha512",
 		.cra_driver_name	= "sha512-neon",
 		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA512_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
-- 
2.39.5

