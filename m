Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAC32686A9
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945168; cv=none; b=HZ/JgFYZHLuNVCw3hy+Vs9b3AAz8nQf4RkfPflAZxAQwSYWUOhTtmI77PLPON9zR8ktTXUAdKBgmkfEUzexu2lUXKpe91plDKFRXvM5G7Q4vIvN2tjiqPqa6DfDIYqEnW914xLUv0FSYP/OWkblO4qF0oETwjDNkkqv13XapC6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945168; c=relaxed/simple;
	bh=Qoa5bbVROlod+2dM2Ls54miYE8oQTFUR3KrMP3ZYO28=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Wo6n8Dhfn8t2JPAovSjjpGtJjdzpfRlPXZBv6DuZWUqva8hUivp4OPMJZBVkZIiT9MqD/rd7M+Jumf2N2KP3rmqOx5gj+U2zP6tSe5juQwUIpC3rh2rysdrYqpCVGFZ6LUky3l25vamP11vpvn9VAVoiKHaCgyWSqLuO8bRN+dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NqiVTq0w; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NqiVTq0w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8nZICOC4MezdulRvqAChn4nsJYXAiOLt6/5MRsTeBIs=; b=NqiVTq0wxbozPLw5U73XzoxuFd
	pRjf/05SJLPN6935jkQnG9sv6rn1jD6SXHYH+mChRqsCWReWINa/yij3r5qW4Z/KpUXXyvNUgPXWs
	hYnZ+LfHuhjpZPs8+MCQMOD1pidYJJUj+go4Swd5aOHoe9F1Xi5oYkMKWjJZS+8UjE1GM7TBqfWBz
	x1knRifOGIGg0tII35Y/QjNXJb39+IzqjWQmsUNN/c55ktQStPziud+CDiqcftKZ06uvK5i5DevMM
	za91OcvEKWhmMKgyDNjXk71Jv8aCzEEZgWU6mClVTQoWGAAJOfuvZtaEq319hIKpnC386UjxcQfZ7
	CVWaZ1PQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwo-00Ge5k-2L;
	Fri, 18 Apr 2025 10:59:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:22 +0800
Date: Fri, 18 Apr 2025 10:59:22 +0800
Message-Id: <37465485af422e2c6f4e13f50c5d5185a638fc9e.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 19/67] crypto: arm/sha1-ce - Use API partial block handling
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

