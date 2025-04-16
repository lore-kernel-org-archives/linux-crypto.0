Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71816237194
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785842; cv=none; b=ickYq4I3a+M1AGuxI/hRPuJ7v15TRBhsF3iOUMsY9rqIb283Ml/VTyqP765JqtLbfqMY5gRXPyGiFPJ7AaYTSE9yd3XAQ+u3vok6CjE9okFRx0oMHnvM1gORIUc42nBV9OaB/ycUs03ZMzlw+IWosfpb2jh51slZjXXW0MrWmeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785842; c=relaxed/simple;
	bh=nhl9IjgXyB+Lem9FnIIyVxbkefTJYGHg5HvBojrNqMQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=l0BGmhWFMSugusOF2MraMkwdSQ9TeP85Pzg9BH9ydrWQX0SwCjIwZ2H3AsNddcGOao7FlQh+Yxm9jC0fiBsyo3DfVU1YZDk5VeCd/N60a2GByvu0kiqhCWw4a863ByBQv/1/DnAEspnxdDXdrtu1hbViIHYeBe2vlTerhyBsSdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LtjL5TXU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LtjL5TXU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JNI2XEsu5568TnyzsZojHx46a5dkC+22gxeHO7c1xFs=; b=LtjL5TXUaKhShFye4VtcIItTXd
	IwDEjwEf7Jzw68i4zCbKbxynA6RD+42rqJJ80gEZpj7dwgSu1OPCfdEDC9pfQfn1V0KvM9Jj4543D
	sXUHgc6OzAkJbgNAhOZwk5blOgX3k2pxeg+C4iRx/iIM9YwDwlw3NfirKfiBDtzHKvVdUAESD0XFI
	7tIK1zqzuA43DqTyMKBJKyJQwPG1Mp40CowJ4rl8U95L7W0p0jOWn0dA2r5Bg2UnCsoQV4g3QHs/G
	+AGcIqqKsY8v8C8RAPdC4AyyvnM9abxy0QJ+7t9nRitBb6Lu6QphnMQ+KUL9vZxAm/pKXjt9224IC
	P/6U1jwg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wV2-00G6MQ-1q;
	Wed, 16 Apr 2025 14:43:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:56 +0800
Date: Wed, 16 Apr 2025 14:43:56 +0800
Message-Id: <c8b0fe13dfb9660c54ec633cb3ad5ef97483e46b.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 32/67] crypto: arm/sha256-neon - Use API partial block
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
 arch/arm/crypto/sha256_neon_glue.c | 49 ++++++++++--------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha256_neon_glue.c
index ccdcfff71910..76eb3cdc21c9 100644
--- a/arch/arm/crypto/sha256_neon_glue.c
+++ b/arch/arm/crypto/sha256_neon_glue.c
@@ -9,69 +9,51 @@
  *   Copyright © 2014 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  */
 
+#include <asm/neon.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <linux/types.h>
-#include <linux/string.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
-#include <asm/byteorder.h>
-#include <asm/simd.h>
-#include <asm/neon.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "sha256_glue.h"
 
-asmlinkage void sha256_block_data_order_neon(struct sha256_state *digest,
-					     const u8 *data, int num_blks);
+asmlinkage void sha256_block_data_order_neon(
+	struct crypto_sha256_state *digest, const u8 *data, int num_blks);
 
 static int crypto_sha256_neon_update(struct shash_desc *desc, const u8 *data,
 				     unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
-		return crypto_sha256_arm_update(desc, data, len);
+	int remain;
 
 	kernel_neon_begin();
-	sha256_base_do_update(desc, data, len, sha256_block_data_order_neon);
+	remain = sha256_base_do_update_blocks(desc, data, len,
+					      sha256_block_data_order_neon);
 	kernel_neon_end();
-
-	return 0;
+	return remain;
 }
 
 static int crypto_sha256_neon_finup(struct shash_desc *desc, const u8 *data,
 				    unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable())
-		return crypto_sha256_arm_finup(desc, data, len, out);
-
 	kernel_neon_begin();
-	if (len)
-		sha256_base_do_update(desc, data, len,
-				      sha256_block_data_order_neon);
-	sha256_base_do_finalize(desc, sha256_block_data_order_neon);
+	sha256_base_do_finup(desc, data, len, sha256_block_data_order_neon);
 	kernel_neon_end();
-
 	return sha256_base_finish(desc, out);
 }
 
-static int crypto_sha256_neon_final(struct shash_desc *desc, u8 *out)
-{
-	return crypto_sha256_neon_finup(desc, NULL, 0, out);
-}
-
 struct shash_alg sha256_neon_algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	crypto_sha256_neon_update,
-	.final		=	crypto_sha256_neon_final,
 	.finup		=	crypto_sha256_neon_finup,
-	.descsize	=	sizeof(struct sha256_state),
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-neon",
 		.cra_priority	=	250,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -79,13 +61,14 @@ struct shash_alg sha256_neon_algs[] = { {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_base_init,
 	.update		=	crypto_sha256_neon_update,
-	.final		=	crypto_sha256_neon_final,
 	.finup		=	crypto_sha256_neon_finup,
-	.descsize	=	sizeof(struct sha256_state),
+	.descsize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name =	"sha224-neon",
 		.cra_priority	=	250,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

