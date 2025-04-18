Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56392686AE
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945193; cv=none; b=PSyLUXnGYqndSScB6GBdu8t9aSw1YQarWlreARScEd/XpIvt+hCYI5lOUlvYvwrCr0WrZQ+2poGgpqTy8Uo4ueUHBP4PnMKwLvgXkBeLFxBau42xkXUKnsqq2sqzYDj8yT9cdZj2/2GdUBjXFBdav+c0m7gNuZsH3WPKLjAbBFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945193; c=relaxed/simple;
	bh=jHCno36IdNNpskUnZpJ/EGEdeuv8DatPENfEuj8sQjY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=ts5JFpYwVnLzm3s0V0TzHbNUMic4x3P9KVyKDo4Ze9gU/t4MxkUZ5dGfjYJEPhMk/6b0tE9IY+dPgHWe+dGhUA0ovdMQGkMI4KfBnPbeaZbJuqFu6S0K7sgoFnnAeLDt0D4y9oxVq44wElTAFWOSYsEdSVowiUhtLSnhhHjQPYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=m7P8+Czz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="m7P8+Czz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5HtykYdmz2P+WqQ5XjwWnFjRUPenLIF7DIXGSe5zMFg=; b=m7P8+CzzZQMYqHkAZXyTbsz7Fp
	WHU6IvXfXrmD1wtlOPjd1nCRHc2vLUAUaYwxg3oTcV9vS/N1fnO1qPWcN7Rzi8VOUoPTogXwjKt1p
	8FDGFqbI/yDhFeh10uB6gL5zIAF9tsJLP6mvpE7Vj4Lmxt3vr+qicgaa55vJm/2y/PXXi/CcVgppN
	YwQwltm0NJJbsVJQCn1YeBs82ca6GRLqgexuMRvq18gfyv8DogiLJ7jATnBrOMAw/k+iO9HHF3LS3
	fvDJK5mtF2AJcJ2kQOPLHQNxQDHJlyjefQbpqPnivp3SUCFWX+mar0AyCqn2zeiBNVOBCafEZUNfi
	LD6GihMQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxE-00Ge8q-0U;
	Fri, 18 Apr 2025 10:59:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:48 +0800
Date: Fri, 18 Apr 2025 10:59:48 +0800
Message-Id: <240859e1ccf32772d947365ea3f175ea2474f9ac.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 30/67] crypto: sha256-generic - Use API partial block
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
 crypto/sha256_generic.c | 50 +++++++++++++++++------------------------
 include/crypto/sha2.h   |  6 -----
 2 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index b00521f1a6d4..05084e5bbaec 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -8,14 +8,10 @@
  * SHA224 Support Copyright 2007 Intel Corporation <jonathan.lynch@intel.com>
  */
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
-#include <asm/byteorder.h>
-#include <linux/unaligned.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE] = {
 	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47,
@@ -33,42 +29,37 @@ const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE] = {
 };
 EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
 
-int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
-			  unsigned int len)
+static void sha256_block(struct crypto_sha256_state *sctx, const u8 *input,
+			 int blocks)
 {
-	sha256_update(shash_desc_ctx(desc), data, len);
-	return 0;
-}
-EXPORT_SYMBOL(crypto_sha256_update);
-
-static int crypto_sha256_final(struct shash_desc *desc, u8 *out)
-{
-	if (crypto_shash_digestsize(desc->tfm) == SHA224_DIGEST_SIZE)
-		sha224_final(shash_desc_ctx(desc), out);
-	else
-		sha256_final(shash_desc_ctx(desc), out);
-	return 0;
+	sha256_transform_blocks(sctx, input, blocks);
 }
 
-int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *hash)
+static int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
+				unsigned int len)
 {
-	sha256_update(shash_desc_ctx(desc), data, len);
-	return crypto_sha256_final(desc, hash);
+	return sha256_base_do_update_blocks(desc, data, len, sha256_block);
+}
+
+static int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *hash)
+{
+	sha256_base_do_finup(desc, data, len, sha256_block);
+	return sha256_base_finish(desc, hash);
 }
-EXPORT_SYMBOL(crypto_sha256_finup);
 
 static struct shash_alg sha256_algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	crypto_sha256_update,
-	.final		=	crypto_sha256_final,
 	.finup		=	crypto_sha256_finup,
-	.descsize	=	sizeof(struct sha256_state),
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name=	"sha256-generic",
 		.cra_priority	=	100,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -76,13 +67,14 @@ static struct shash_alg sha256_algs[2] = { {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_base_init,
 	.update		=	crypto_sha256_update,
-	.final		=	crypto_sha256_final,
 	.finup		=	crypto_sha256_finup,
-	.descsize	=	sizeof(struct sha256_state),
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name=	"sha224-generic",
 		.cra_priority	=	100,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index d9b1b9932393..a913bad5dd3b 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -83,12 +83,6 @@ struct sha512_state {
 
 struct shash_desc;
 
-extern int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
-			      unsigned int len);
-
-extern int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
-			       unsigned int len, u8 *hash);
-
 extern int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
-- 
2.39.5

