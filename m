Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46FE231CAE
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785809; cv=none; b=nqR2XnyQkTQgyurl+GpR5eahlTYVfYa6dUAROKXsh3LUOEzWMR99cb4sGOFjlaulMinAeYe8Q5dr0oRgNagfEj/ePpB2oECRQjhVKtkau2q09j3lLPa66ZyillfaFvIJ1ddhlAOm1vPxUpQl9sq13gFNM61CpC1Srxzet0fx1es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785809; c=relaxed/simple;
	bh=30zMiw15QLQGv57WqWjAaZ4VZPbKM2MmTv/iX2E+7GY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=DItGD36o4C7eYXXIeN+TaS3hIQ8FMlLdE4R6GezJd2HA+wPI0TVfqTAK6I29iiVnZbrWp53lq5EMg+llecpQZ73ddRNyyoHn2FbvMW8GUf5dUGHRxyjs5NW3XwMEYoJPTPfnnR1qgII+E84qAnbR3PmP6/aMtxhfkIt8ESseZTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SlcWW+ZE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SlcWW+ZE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O6GiwROsJLLGYEu1aD8o7mdqokr8ZgmuYBO2jyCNvqw=; b=SlcWW+ZESI5jo7XnHYTSPZh0Vc
	BzQoGQHDxiLylDwtPxH0Yw8g3dee2x/1D/VUoUBMe0rP4sTIY6A1jHrzk3lFxcOg0k4V1yoa+M69o
	oTMdU7DCteY5fPfzKRAOxg2wmffbdFU8ZcPawTBFClTs+daPTU0g4KSz6pn6041UBUH/rHWHsdVNQ
	WvOI/m6xApTFKE1suzKVPuUy1W7/NNS0Qz252Qtz1GbLgIPX2sSU6pd64IzH825ZsVC+IPprHd6GJ
	RUHLtW32IIjGtJk4zMXdNu2ZtqX1+AY+nHC/al0GS0IvMg0VcSB/lBZwX6qYmKAQlnTCHhquFC13E
	vRu+UJGw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUW-00G6JV-1E;
	Wed, 16 Apr 2025 14:43:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:24 +0800
Date: Wed, 16 Apr 2025 14:43:24 +0800
Message-Id: <09eaa7d74bca91407a6732788068b0806b142a71.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 18/67] crypto: sha1-generic - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/sha1_generic.c | 33 ++++++++++++---------------------
 include/crypto/sha1.h |  8 --------
 2 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 325b57fe28dc..7a3c837923b5 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -12,13 +12,11 @@
  * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
  */
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
-#include <asm/byteorder.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
 const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE] = {
 	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
@@ -39,38 +37,31 @@ static void sha1_generic_block_fn(struct sha1_state *sst, u8 const *src,
 	memzero_explicit(temp, sizeof(temp));
 }
 
-int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
+static int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len)
 {
-	return sha1_base_do_update(desc, data, len, sha1_generic_block_fn);
+	return sha1_base_do_update_blocks(desc, data, len,
+					  sha1_generic_block_fn);
 }
-EXPORT_SYMBOL(crypto_sha1_update);
 
-static int sha1_final(struct shash_desc *desc, u8 *out)
+static int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *out)
 {
-	sha1_base_do_finalize(desc, sha1_generic_block_fn);
+	sha1_base_do_finup(desc, data, len, sha1_generic_block_fn);
 	return sha1_base_finish(desc, out);
 }
 
-int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
-		      unsigned int len, u8 *out)
-{
-	sha1_base_do_update(desc, data, len, sha1_generic_block_fn);
-	return sha1_final(desc, out);
-}
-EXPORT_SYMBOL(crypto_sha1_finup);
-
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	crypto_sha1_update,
-	.final		=	sha1_final,
 	.finup		=	crypto_sha1_finup,
-	.descsize	=	sizeof(struct sha1_state),
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-generic",
 		.cra_priority	=	100,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
index dd6de4a4d6e6..f48230b1413c 100644
--- a/include/crypto/sha1.h
+++ b/include/crypto/sha1.h
@@ -26,14 +26,6 @@ struct sha1_state {
 	u8 buffer[SHA1_BLOCK_SIZE];
 };
 
-struct shash_desc;
-
-extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
-			      unsigned int len);
-
-extern int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
-			     unsigned int len, u8 *hash);
-
 /*
  * An implementation of SHA-1's compression function.  Don't use in new code!
  * You shouldn't be using SHA-1, and even if you *have* to use SHA-1, this isn't
-- 
2.39.5

