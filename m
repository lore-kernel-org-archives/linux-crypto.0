Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6821426868E
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945237; cv=none; b=a3tV8qEERnnlWI6+tPYb9a5a2roqbE8cM0K0ffoFcuCiBFeqVqEJw4Yjn6/FthcVI2Pzr41Hz/msXevhP3czMi4/CHSR5GJGqiHqPcpMLkAfD1ukiWN+HOsL4QqTWuHTbOwYEu6gLRoq51PeT5nW1qj5GS4PbW1KgaYtQREwGoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945237; c=relaxed/simple;
	bh=HmCNW4X6Mev55a6TBFq+Z92ILLTUnmaNNsA2fxnODig=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=VMyceGdL6yt/wQkSCUMX71QKdYubwAnqOWFrlz5sBg4y0/EVlQq7wUUt8PhNkzT4w4kMk/FCh3ZwW2YJW0YJ1WEHuKt8tXnOYRp/UqSLVxwvN470bbZVurxB9na/KafetXcbklOo7edSAZRtHkp8FseuaA7tX7Iwl/1GwUzTazE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dvJ6zdk+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dvJ6zdk+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bDEddljQOWGzrkWHbyXqd5D5romkfBto41ahDeM+Bg0=; b=dvJ6zdk+785arWFAGvkNIbbJMZ
	vlXl419IELlPE0qkLK+E+DjH3QjdxKSPneSiA2U39FBl5XxERDjMdh7Ygv2vNV8Od80pRteG5Mj0p
	/T9e3FLh+cZiCnLvSu/q6p2TZ1eutajLsFaLg/a1GbzFQjmRFMRt19C2IDut9DgI5hTeGKBF77R8E
	Hzcj0zqJLBs9KYoY3J7XI6Pg1WVnAQFEzKVIqbj5jbNQJsyMn0Cmj6zn6qQeiCaHiXAir9vY6NN2W
	0NUDKn41Jamum8obuPGUlouKYE3husQ0E+1qoPslJeKjHxT1AdV2IooLWIe/wEWM4ciaLKmBY3m8H
	BmaHic5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxv-00GeEB-39;
	Fri, 18 Apr 2025 11:00:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:31 +0800
Date: Fri, 18 Apr 2025 11:00:31 +0800
Message-Id: <995e795d4b67474895e46d521537a9b42c17c9dd.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 49/67] crypto: arm/sha512-asm - Use API partial block
 handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/sha512-glue.c | 36 ++++++++++++++++-------------------
 arch/arm/crypto/sha512.h      |  6 ------
 2 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/arch/arm/crypto/sha512-glue.c b/arch/arm/crypto/sha512-glue.c
index 1be5bd498af3..f8a6480889b1 100644
--- a/arch/arm/crypto/sha512-glue.c
+++ b/arch/arm/crypto/sha512-glue.c
@@ -5,15 +5,14 @@
  * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
+#include <asm/hwcap.h>
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
 #include <crypto/sha512_base.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <asm/hwcap.h>
-#include <asm/neon.h>
-
 #include "sha512.h"
 
 MODULE_DESCRIPTION("Accelerated SHA-384/SHA-512 secure hash for ARM");
@@ -28,50 +27,47 @@ MODULE_ALIAS_CRYPTO("sha512-arm");
 asmlinkage void sha512_block_data_order(struct sha512_state *state,
 					u8 const *src, int blocks);
 
-int sha512_arm_update(struct shash_desc *desc, const u8 *data,
-		      unsigned int len)
+static int sha512_arm_update(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
 {
-	return sha512_base_do_update(desc, data, len, sha512_block_data_order);
+	return sha512_base_do_update_blocks(desc, data, len,
+					    sha512_block_data_order);
 }
 
-static int sha512_arm_final(struct shash_desc *desc, u8 *out)
+static int sha512_arm_finup(struct shash_desc *desc, const u8 *data,
+			    unsigned int len, u8 *out)
 {
-	sha512_base_do_finalize(desc, sha512_block_data_order);
+	sha512_base_do_finup(desc, data, len, sha512_block_data_order);
 	return sha512_base_finish(desc, out);
 }
 
-int sha512_arm_finup(struct shash_desc *desc, const u8 *data,
-		     unsigned int len, u8 *out)
-{
-	sha512_base_do_update(desc, data, len, sha512_block_data_order);
-	return sha512_arm_final(desc, out);
-}
-
 static struct shash_alg sha512_arm_algs[] = { {
 	.init			= sha384_base_init,
 	.update			= sha512_arm_update,
-	.final			= sha512_arm_final,
 	.finup			= sha512_arm_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.digestsize		= SHA384_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha384",
 		.cra_driver_name	= "sha384-arm",
 		.cra_priority		= 250,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA512_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
 },  {
 	.init			= sha512_base_init,
 	.update			= sha512_arm_update,
-	.final			= sha512_arm_final,
 	.finup			= sha512_arm_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.digestsize		= SHA512_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha512",
 		.cra_driver_name	= "sha512-arm",
 		.cra_priority		= 250,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		= SHA512_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
diff --git a/arch/arm/crypto/sha512.h b/arch/arm/crypto/sha512.h
index e14572be76d1..eeaee52cda69 100644
--- a/arch/arm/crypto/sha512.h
+++ b/arch/arm/crypto/sha512.h
@@ -1,9 +1,3 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
-int sha512_arm_update(struct shash_desc *desc, const u8 *data,
-		      unsigned int len);
-
-int sha512_arm_finup(struct shash_desc *desc, const u8 *data,
-		     unsigned int len, u8 *out);
-
 extern struct shash_alg sha512_neon_algs[2];
-- 
2.39.5

