Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACE623371F
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785812; cv=none; b=nIcTEwB+ZalsaD5dJ+oLRaNE3nccHLpbnr/afdq7yLxRficVkOiQ3suOLw8n0WCy7w7iWM3p1Zs3PEFwaiwoeuuJ3FcgmCFyHDkjGVpNAetY9IbUMFAy6RxujDhmf9rmmGy+Fj6eRXEywk2Usb8b6flFZcr3ClIA1kZ1tClnFGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785812; c=relaxed/simple;
	bh=Qoa5bbVROlod+2dM2Ls54miYE8oQTFUR3KrMP3ZYO28=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=bjuN/rxqBXjw0cF69hhtOSnYJusRKR2rCvuFsjFHAazALEHAd/mTdgY3LrnilLe0HTiYWvvyaY9Hv27/oErYkFXx/slshmxODPL2/EB8PGY+FjJykm460D9ZHS3mwwIZQSsSC+krtuqcsPgR3nqguY6T4QjZhvshYsu1SoyIHMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=S62IcsMV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="S62IcsMV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8nZICOC4MezdulRvqAChn4nsJYXAiOLt6/5MRsTeBIs=; b=S62IcsMVcLuUZbg4W+cyKv0nS/
	v/yD7Szyvp2cfJ0PES4gdk2/elqZvIXoyxMJEkUwdZz8KrvbJTAXzfPswLQBZjRI0yTI1JX/qEavS
	aN32LbETywdM2jj5G9lyVmY0OJSJA18u6elSzrTjdv/3pygyE3m+t0ol8mFjwM8TlJ/6MoNwf4I8m
	R+LntJvutO6Zk1WPBTSfKcgrkTNNP9c3W+eHcJwI1y/drzkkSJzv85Po8JZztVPJTFFIfeTm4tL9+
	k0KrsK1hRR7th3kWqto27AKkYg6XlMjhGDQ0r0unMU67eWOUaOTsBZBPObrOaXe0CD/l2TIaM9uAH
	IOCD0SKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUY-00G6Jg-2E;
	Wed, 16 Apr 2025 14:43:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:26 +0800
Date: Wed, 16 Apr 2025 14:43:26 +0800
Message-Id: <bd1b0b3eb293be10165bae1b9c8ce60905c8f32a.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 19/67] crypto: arm/sha1-ce - Use API partial block handling
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
 arch/arm/crypto/sha1-ce-glue.c | 36 ++++++++--------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff --git a/arch/arm/crypto/sha1-ce-glue.c b/arch/arm/crypto/sha1-ce-glue.c
index de9100c67b37..fac07a4799de 100644
--- a/arch/arm/crypto/sha1-ce-glue.c
+++ b/arch/arm/crypto/sha1-ce-glue.c
@@ -5,20 +5,14 @@
  * Copyright (C) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
-#include <asm/hwcap.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
-
-#include "sha1.h"
-
 MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
@@ -29,50 +23,36 @@ asmlinkage void sha1_ce_transform(struct sha1_state *sst, u8 const *src,
 static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
-		return sha1_update_arm(desc, data, len);
+	int remain;
 
 	kernel_neon_begin();
-	sha1_base_do_update(desc, data, len, sha1_ce_transform);
+	remain = sha1_base_do_update_blocks(desc, data, len, sha1_ce_transform);
 	kernel_neon_end();
 
-	return 0;
+	return remain;
 }
 
 static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 			 unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable())
-		return sha1_finup_arm(desc, data, len, out);
-
 	kernel_neon_begin();
-	if (len)
-		sha1_base_do_update(desc, data, len, sha1_ce_transform);
-	sha1_base_do_finalize(desc, sha1_ce_transform);
+	sha1_base_do_finup(desc, data, len, sha1_ce_transform);
 	kernel_neon_end();
 
 	return sha1_base_finish(desc, out);
 }
 
-static int sha1_ce_final(struct shash_desc *desc, u8 *out)
-{
-	return sha1_ce_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg alg = {
 	.init			= sha1_base_init,
 	.update			= sha1_ce_update,
-	.final			= sha1_ce_final,
 	.finup			= sha1_ce_finup,
-	.descsize		= sizeof(struct sha1_state),
+	.descsize		= SHA1_STATE_SIZE,
 	.digestsize		= SHA1_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha1",
 		.cra_driver_name	= "sha1-ce",
 		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
-- 
2.39.5

