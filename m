Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BB522F155
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785849; cv=none; b=UTKu+9GcWGdBPibggEpMVsA7foEONGoljbwqqPmOdQDO45+Z10RgIKZR0oZchk3b24uulh5t+UFJOwyFimDKtGgGwi2NQMrFk6GMkpzHr4i2cpu+OEe2cJ+AFZBxrny3e0yFOqzLBpQglXUg9IvkP4jiRsGVgunh0zuXjhe6EFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785849; c=relaxed/simple;
	bh=PC6hP/PaQN0oz6HV0ApFwZr9MhdLvzBWz/TfF5y4k+4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Ts3IhzGOaLXVd5PBe4RuTOW2W1sD1SfYKn2SZfdaUAsNMoSQEfh9GULMSrQE0VourEuqpccrp4p/sSY2cVSmC1HqwfBc5z4Jz/AOFxJwH7qrmkO4XYyl07NA72XBAz4EQJSnLrnlkWYNB0ky0yaKLrbYD/co+RASXnKeJIZ+9Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EfJNBjrz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EfJNBjrz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lntNOo8e5HUWKRFdufdnkSbtYQ1e5oo8QPFVYsPR33U=; b=EfJNBjrz6FdZFk4/Fywa3hI7fx
	qAIomZ7d3pRV+EFvjeNAVw9vEguNumfdPO2ywqTzOM+AltFICFHdq51ZRA2dq6ld1fBYY5s+GEb2c
	t8TwjNufIQV5O8nmwSqV+oAXdy3uFm9RtC7MwO/JRO6Xk5Z3j0DaRlSpZeoUuUh0MJRh4IyjNk2oQ
	in38r/wJZz7Cv6wSHpO/0oAdJPceoKCPUW1YIEw0MaMS7vAk7VHWFOzd954f3OBBddtJ0ffy8HWWN
	XeuE7MWp+4L+7eDTU+IXWY5E6xJheq3hmMiXlx9+LJJrynSTQqKz2Ul8d2h74GwpiBP9auiX1CYjc
	hj0hWJEw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wV9-00G6Mx-1f;
	Wed, 16 Apr 2025 14:44:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:03 +0800
Date: Wed, 16 Apr 2025 14:44:03 +0800
Message-Id: <1af65079af987533aa78b7e87aa578ef82e55b68.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 35/67] crypto: arm64/sha256 - Use API partial block handling
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
 arch/arm64/crypto/sha256-glue.c | 97 +++++++++++++--------------------
 1 file changed, 37 insertions(+), 60 deletions(-)

diff --git a/arch/arm64/crypto/sha256-glue.c b/arch/arm64/crypto/sha256-glue.c
index 35356987cc1e..26f9fdfae87b 100644
--- a/arch/arm64/crypto/sha256-glue.c
+++ b/arch/arm64/crypto/sha256-glue.c
@@ -5,16 +5,13 @@
  * Copyright (c) 2016 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#include <asm/hwcap.h>
 #include <asm/neon.h>
-#include <asm/simd.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
+#include <linux/cpufeature.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/string.h>
-#include <linux/types.h>
 
 MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash for arm64");
 MODULE_AUTHOR("Andy Polyakov <appro@openssl.org>");
@@ -27,8 +24,8 @@ asmlinkage void sha256_block_data_order(u32 *digest, const void *data,
 					unsigned int num_blks);
 EXPORT_SYMBOL(sha256_block_data_order);
 
-static void sha256_arm64_transform(struct sha256_state *sst, u8 const *src,
-				   int blocks)
+static void sha256_arm64_transform(struct crypto_sha256_state *sst,
+				   u8 const *src, int blocks)
 {
 	sha256_block_data_order(sst->state, src, blocks);
 }
@@ -36,55 +33,52 @@ static void sha256_arm64_transform(struct sha256_state *sst, u8 const *src,
 asmlinkage void sha256_block_neon(u32 *digest, const void *data,
 				  unsigned int num_blks);
 
-static void sha256_neon_transform(struct sha256_state *sst, u8 const *src,
-				  int blocks)
+static void sha256_neon_transform(struct crypto_sha256_state *sst,
+				  u8 const *src, int blocks)
 {
+	kernel_neon_begin();
 	sha256_block_neon(sst->state, src, blocks);
+	kernel_neon_end();
 }
 
 static int crypto_sha256_arm64_update(struct shash_desc *desc, const u8 *data,
 				      unsigned int len)
 {
-	return sha256_base_do_update(desc, data, len, sha256_arm64_transform);
+	return sha256_base_do_update_blocks(desc, data, len,
+					    sha256_arm64_transform);
 }
 
 static int crypto_sha256_arm64_finup(struct shash_desc *desc, const u8 *data,
 				     unsigned int len, u8 *out)
 {
-	if (len)
-		sha256_base_do_update(desc, data, len, sha256_arm64_transform);
-	sha256_base_do_finalize(desc, sha256_arm64_transform);
-
+	sha256_base_do_finup(desc, data, len, sha256_arm64_transform);
 	return sha256_base_finish(desc, out);
 }
 
-static int crypto_sha256_arm64_final(struct shash_desc *desc, u8 *out)
-{
-	return crypto_sha256_arm64_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.init			= sha256_base_init,
 	.update			= crypto_sha256_arm64_update,
-	.final			= crypto_sha256_arm64_final,
 	.finup			= crypto_sha256_arm64_finup,
-	.descsize		= sizeof(struct sha256_state),
+	.descsize		= sizeof(struct crypto_sha256_state),
 	.base.cra_name		= "sha256",
 	.base.cra_driver_name	= "sha256-arm64",
 	.base.cra_priority	= 125,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA256_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA224_DIGEST_SIZE,
 	.init			= sha224_base_init,
 	.update			= crypto_sha256_arm64_update,
-	.final			= crypto_sha256_arm64_final,
 	.finup			= crypto_sha256_arm64_finup,
-	.descsize		= sizeof(struct sha256_state),
+	.descsize		= sizeof(struct crypto_sha256_state),
 	.base.cra_name		= "sha224",
 	.base.cra_driver_name	= "sha224-arm64",
 	.base.cra_priority	= 125,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA224_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 } };
@@ -92,13 +86,7 @@ static struct shash_alg algs[] = { {
 static int sha256_update_neon(struct shash_desc *desc, const u8 *data,
 			      unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable())
-		return sha256_base_do_update(desc, data, len,
-				sha256_arm64_transform);
-
-	while (len > 0) {
+	do {
 		unsigned int chunk = len;
 
 		/*
@@ -106,65 +94,54 @@ static int sha256_update_neon(struct shash_desc *desc, const u8 *data,
 		 * input when running on a preemptible kernel, but process the
 		 * data block by block instead.
 		 */
-		if (IS_ENABLED(CONFIG_PREEMPTION) &&
-		    chunk + sctx->count % SHA256_BLOCK_SIZE > SHA256_BLOCK_SIZE)
-			chunk = SHA256_BLOCK_SIZE -
-				sctx->count % SHA256_BLOCK_SIZE;
+		if (IS_ENABLED(CONFIG_PREEMPTION))
+			chunk = SHA256_BLOCK_SIZE;
 
-		kernel_neon_begin();
-		sha256_base_do_update(desc, data, chunk, sha256_neon_transform);
-		kernel_neon_end();
+		chunk -= sha256_base_do_update_blocks(desc, data, chunk,
+						      sha256_neon_transform);
 		data += chunk;
 		len -= chunk;
-	}
-	return 0;
+	} while (len >= SHA256_BLOCK_SIZE);
+	return len;
 }
 
 static int sha256_finup_neon(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable()) {
-		if (len)
-			sha256_base_do_update(desc, data, len,
-				sha256_arm64_transform);
-		sha256_base_do_finalize(desc, sha256_arm64_transform);
-	} else {
-		if (len)
-			sha256_update_neon(desc, data, len);
-		kernel_neon_begin();
-		sha256_base_do_finalize(desc, sha256_neon_transform);
-		kernel_neon_end();
-	}
-	return sha256_base_finish(desc, out);
-}
+	if (len >= SHA256_BLOCK_SIZE) {
+		int remain = sha256_update_neon(desc, data, len);
 
-static int sha256_final_neon(struct shash_desc *desc, u8 *out)
-{
-	return sha256_finup_neon(desc, NULL, 0, out);
+		data += len - remain;
+		len = remain;
+	}
+	sha256_base_do_finup(desc, data, len, sha256_neon_transform);
+	return sha256_base_finish(desc, out);
 }
 
 static struct shash_alg neon_algs[] = { {
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.init			= sha256_base_init,
 	.update			= sha256_update_neon,
-	.final			= sha256_final_neon,
 	.finup			= sha256_finup_neon,
-	.descsize		= sizeof(struct sha256_state),
+	.descsize		= sizeof(struct crypto_sha256_state),
 	.base.cra_name		= "sha256",
 	.base.cra_driver_name	= "sha256-arm64-neon",
 	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA256_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA224_DIGEST_SIZE,
 	.init			= sha224_base_init,
 	.update			= sha256_update_neon,
-	.final			= sha256_final_neon,
 	.finup			= sha256_finup_neon,
-	.descsize		= sizeof(struct sha256_state),
+	.descsize		= sizeof(struct crypto_sha256_state),
 	.base.cra_name		= "sha224",
 	.base.cra_driver_name	= "sha224-arm64-neon",
 	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA224_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 } };
-- 
2.39.5

