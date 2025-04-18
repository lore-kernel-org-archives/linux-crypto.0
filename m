Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5D92686A9
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945165; cv=none; b=dzRQol397Cvm5GIn1vGZxCKI41I4NNDdrRgMJUux+6EIQDFEHlGl1ZvPcsBIqAXzzwVP01iu3sQJp97m3E3yWk946vjirSfS4nzmM2UtyNgeiY3KNI5VQYP8gtYC0vpac8TS3dVX7djqrsx+2bcpk+otiJAN5t5uO+u8FMDPiwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945165; c=relaxed/simple;
	bh=30zMiw15QLQGv57WqWjAaZ4VZPbKM2MmTv/iX2E+7GY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=K9SUw9RhJi2rdGUa7YjNpWMm66udxRGmlx3j2w2Cgk4lGQ0P3t0g57b5JFYZd2KSwEgmMX5qRsjiTQNDIuMB1x2/sG46CVFVm6LeU/lG+EI4KqaErwrmXGy+6cz+ieuW6H3BLsVZs31YQTYYbpW0sD2Xcl7SbTB6EPGO9DVMkvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VJyA7V/T; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VJyA7V/T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O6GiwROsJLLGYEu1aD8o7mdqokr8ZgmuYBO2jyCNvqw=; b=VJyA7V/ToJPuaQNmWeZ0QD+yeA
	nvTLI3w9uJY6ZtM04WHiws23+o9etClB8jnCRnX27eN73h5ZHbNEY/1jiMIxfBcu+OUYrwYC0s62d
	iYvFp1eD+RFiNZ6t9ze1eNdZqSlpJZOb9/FBiXgVmlVMB0SEKORvJbeE+O85WJBLNm4DN44pZcX3v
	/T3GwqviN6ge9K78ZaPrJpvdy+Msn4DLvAFdzN7ROPci/TU2j0gTfnVAuxO7u03RiU7oT4MUEq7sI
	Hc9qqVxxQNnJr+gfhfdokqD8LG7roMglmiTWEUoZnDjz1CQ6YMaKk4c1P7046+g+Fy+yfsBVSQ1hN
	wzt6gFbA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwm-00Ge5Y-1L;
	Fri, 18 Apr 2025 10:59:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:20 +0800
Date: Fri, 18 Apr 2025 10:59:20 +0800
Message-Id: <252409efeaf0d0c9a2cfff505d076c0fb538a762.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 18/67] crypto: sha1-generic - Use API partial block
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

