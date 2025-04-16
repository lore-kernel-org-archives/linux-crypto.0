Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA53221F03
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785886; cv=none; b=N+OcNUsf3LXiQkUkXrM8VwXwz5ffbqFUZHoKCx3m25zPTXNGqyCMhYvy9mJ/HjGUXwuma8PJswLhTQblSL1UIqqEuJ7072yCx6km0escPOCRrZedaoc/uAxR7GL6Qk5OGqAh1/nVgl2HElFyRt0QLA5Nv99uSikAxpNlZVG7220=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785886; c=relaxed/simple;
	bh=+nm6oBLtK9KTa19ZC357kSbxAdJRorpdW2RTTZl5eFs=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=IkFZat9vZHIm1/T9oiiLDp+9e3cPNo6jkuBKaNs25RQN5GxKG+rnaK0o199vk6aaaCG/N01hu+tL72ggdU7CmzdNg/tJ70HWgQUKnPRVghq+nf+3VM6BWRjNfEMZr0Dt9+Co6wM3jyAGXkumSXn7WWPbVUY38q+/MF4dcR72Jis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=l/Sg074b; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="l/Sg074b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WY5zy24TEtLq2l8zVmtrG97fmxvINEeXSpCEdWBb/H0=; b=l/Sg074bIVe9K6FExd/paqaekD
	F74qs56GNCS4PnqT1P+0VSyHxcigxhrgs67dyfkA+AdZGvv+GuqH4BX56REqnRUE/5wYSxsqjRmA3
	dVbUHoIK21Bu/iNM1qhPV24S/4j79y4nS4s/6ZRwewW4SQOG9rDhZ5gK6neJuWpY8uHSmhHrJSJT3
	eQXVgwYQtgBkmDvryIOpvn/lyQlBNL9H5Jfu8NUUMG1vTGNjWNp8ixqEBZwFGvEKn1X7840N9swel
	FRa9tFzLokQPeLzpQhbfIRxTpB5Mxbf37a0Zq/kVWk8rRmTUJky7KgWrAE6uNLiUHbOYm+RwekfAe
	3ul3kAsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVk-00G6QW-1f;
	Wed, 16 Apr 2025 14:44:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:40 +0800
Date: Wed, 16 Apr 2025 14:44:40 +0800
Message-Id: <76c73bc67986ace2ac87a2e3a59b60e218c3c7b6.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 51/67] crypto: arm/sha512 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sha512-glue.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
index f789deabefc0..ab2e1c13dfad 100644
--- a/arch/arm64/crypto/sha512-glue.c
+++ b/arch/arm64/crypto/sha512-glue.c
@@ -6,10 +6,10 @@
  */
 
 #include <crypto/internal/hash.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <crypto/sha2.h>
 #include <crypto/sha512_base.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 MODULE_DESCRIPTION("SHA-384/SHA-512 secure hash for arm64");
 MODULE_AUTHOR("Andy Polyakov <appro@openssl.org>");
@@ -20,7 +20,6 @@ MODULE_ALIAS_CRYPTO("sha512");
 
 asmlinkage void sha512_block_data_order(u64 *digest, const void *data,
 					unsigned int num_blks);
-EXPORT_SYMBOL(sha512_block_data_order);
 
 static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
 				   int blocks)
@@ -31,46 +30,41 @@ static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
 static int sha512_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
 {
-	return sha512_base_do_update(desc, data, len, sha512_arm64_transform);
+	return sha512_base_do_update_blocks(desc, data, len,
+					    sha512_arm64_transform);
 }
 
 static int sha512_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
-	if (len)
-		sha512_base_do_update(desc, data, len, sha512_arm64_transform);
-	sha512_base_do_finalize(desc, sha512_arm64_transform);
-
+	sha512_base_do_finup(desc, data, len, sha512_arm64_transform);
 	return sha512_base_finish(desc, out);
 }
 
-static int sha512_final(struct shash_desc *desc, u8 *out)
-{
-	return sha512_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA512_DIGEST_SIZE,
 	.init			= sha512_base_init,
 	.update			= sha512_update,
-	.final			= sha512_final,
 	.finup			= sha512_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.base.cra_name		= "sha512",
 	.base.cra_driver_name	= "sha512-arm64",
 	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA512_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA384_DIGEST_SIZE,
 	.init			= sha384_base_init,
 	.update			= sha512_update,
-	.final			= sha512_final,
 	.finup			= sha512_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.base.cra_name		= "sha384",
 	.base.cra_driver_name	= "sha384-arm64",
 	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA384_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 } };
-- 
2.39.5

