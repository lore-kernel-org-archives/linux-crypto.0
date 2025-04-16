Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2235B22CBD5
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785877; cv=none; b=WL4+DXPa7e9iYFoLl5pSs0HPHRDKTc3qNIQVzcPG9g1LOfXSOnUiYtHOwWpvjBI5M0HPoaeCt79VHNSTJTxMURv3V20KgpsU1TUz/A6mxkriGmeNsvQxhl92Vr2Xj3AxXwRD3UEml8mFotIaLO3/1tzE/XYXaoB93bt6K9faJ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785877; c=relaxed/simple;
	bh=JGpTr7ztX7F3fgb3KACO0dKC11pf9Phgj9UWAkkTuOA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=oU2b8gfzG91l6ABKk5ZZwoxn5brSHt++DIgaoAfto4k8NHAAiN6mraV393o+0CKS9jziUYZhht17uCu2PGObLeOMzdsJURWjTETMhNarskUn3LwBro6Zm2VV04jxcBGam7vAahIbgpaC/EGkTPAsFCBkkW3g0fWcYVGbB8y3ALE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XqzOnq67; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XqzOnq67"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dVjTQ5vi/HdL8CPeJ9z6oDjTDC4hsFp0rEj+LF84OYg=; b=XqzOnq67uDb0GqywF8TlG16YVA
	PxtndzSlJPaHy6MVosvASsoCuBIzAAMJVb7ILKVfkJgSy5rIPBzOJYwlX0hYDHSIy8VukViwxJP6j
	+gcSewxxxEdbiFu49DogPw6/2Kmd4xQ15+SEPHC7Ld8/eu5yHEcVnqdcKXzPUZONljqNs7xBGyyxH
	aQ1VL2ke7cZoXBy9m0a89H8YidtQKTVDdnyvczH1T3vCztWRxzaIjIDfreQGQbNhf/u43q6LFJgzk
	7KBplVsowqIPAXnNYy8Iu1FSwc42ppo3WnyXeOqpSHkoZ8KgHgXV8tO+1W9by4hTNg4InQ7GIZ8Tm
	/On2+plw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVb-00G6Ph-0y;
	Wed, 16 Apr 2025 14:44:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:31 +0800
Date: Wed, 16 Apr 2025 14:44:31 +0800
Message-Id: <a07ca094da7c39c97306f2b1d30c434ea36742fb.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 47/67] crypto: sha512-generic - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/sha512_generic.c | 45 ++++++++++++++++-------------------------
 include/crypto/sha2.h   |  8 --------
 2 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 27a7346ff143..bfea65f4181c 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -6,16 +6,10 @@
  * Copyright (c) 2003 Kyle McMartin <kyle@debian.org>
  */
 #include <crypto/internal/hash.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/init.h>
-#include <linux/crypto.h>
-#include <linux/types.h>
 #include <crypto/sha2.h>
 #include <crypto/sha512_base.h>
-#include <linux/percpu.h>
-#include <asm/byteorder.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/unaligned.h>
 
 const u8 sha384_zero_message_hash[SHA384_DIGEST_SIZE] = {
@@ -148,45 +142,39 @@ sha512_transform(u64 *state, const u8 *input)
 void sha512_generic_block_fn(struct sha512_state *sst, u8 const *src,
 			     int blocks)
 {
-	while (blocks--) {
+	do {
 		sha512_transform(sst->state, src);
 		src += SHA512_BLOCK_SIZE;
-	}
+	} while (--blocks);
 }
 EXPORT_SYMBOL_GPL(sha512_generic_block_fn);
 
-int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
-			unsigned int len)
+static int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
+				unsigned int len)
 {
-	return sha512_base_do_update(desc, data, len, sha512_generic_block_fn);
+	return sha512_base_do_update_blocks(desc, data, len,
+					    sha512_generic_block_fn);
 }
-EXPORT_SYMBOL(crypto_sha512_update);
 
-static int sha512_final(struct shash_desc *desc, u8 *hash)
+static int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *hash)
 {
-	sha512_base_do_finalize(desc, sha512_generic_block_fn);
+	sha512_base_do_finup(desc, data, len, sha512_generic_block_fn);
 	return sha512_base_finish(desc, hash);
 }
 
-int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *hash)
-{
-	sha512_base_do_update(desc, data, len, sha512_generic_block_fn);
-	return sha512_final(desc, hash);
-}
-EXPORT_SYMBOL(crypto_sha512_finup);
-
 static struct shash_alg sha512_algs[2] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_base_init,
 	.update		=	crypto_sha512_update,
-	.final		=	sha512_final,
 	.finup		=	crypto_sha512_finup,
-	.descsize	=	sizeof(struct sha512_state),
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name =	"sha512-generic",
 		.cra_priority	=	100,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -194,13 +182,14 @@ static struct shash_alg sha512_algs[2] = { {
 	.digestsize	=	SHA384_DIGEST_SIZE,
 	.init		=	sha384_base_init,
 	.update		=	crypto_sha512_update,
-	.final		=	sha512_final,
 	.finup		=	crypto_sha512_finup,
-	.descsize	=	sizeof(struct sha512_state),
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name =	"sha384-generic",
 		.cra_priority	=	100,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index e9ad7ab955aa..abbd882f7849 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -82,14 +82,6 @@ struct sha512_state {
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
-struct shash_desc;
-
-extern int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
-			      unsigned int len);
-
-extern int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, u8 *hash);
-
 /*
  * Stand-alone implementation of the SHA256 algorithm. It is designed to
  * have as little dependencies as possible so it can be used in the
-- 
2.39.5

