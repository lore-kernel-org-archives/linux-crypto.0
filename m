Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9165623815B
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785835; cv=none; b=kJ0FTAGpE7tnTuu0azj+Es+C7hclXhI+6kV8P8qrFRIqjnEt0lLz0PLDkxPzotfZQ4qmud3lfdb7UClwKmL8hE7wc86ZdHmcMX21ZMikJwZPfFN78oQCAluTqX6JJsSSUeWvdJkug+mNaSTptn47vbCQIhkvTMvZfhCDKAf98bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785835; c=relaxed/simple;
	bh=mnTKLAJJqpSBoMn2qOlRGxiaeul7OcTtAOpET/YzAdI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=jSQOdqYlF0rpEHEEIeezC9hIEuxKjZ8lHvYqpCLzIyXSoxyY/qeHnG63vBwvpc2ztCMjM8avZrC2Zz5Gfjc9qPjl0/7cMAKiX18ZytHmCo4gTYIpdN2FTG6EUbK7Iwe6dIq2kg/Wi7FrCyo4d3OF+s2qB2XavHlompRlt1Rw54I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=V8Ya4YkM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="V8Ya4YkM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Qz+da9xGW9DIDsmuxEy5W6/6ufoGMbTepw664uvub0E=; b=V8Ya4YkMt8WUFQjODt/8Zp4kKk
	YQYdNbVLvBf8DnWAulP8BW1/eEVUr5re7EOoM38WsGm9+0rVEFydJhVxKQ7wgQpkhSelqmzWC1qip
	7FPy0Nd5b3RlWlczigDpXC2VgA21XgKnzHGBCVMuHdHFwwxoo0luixMmrOrF11oX3AwnKsl9hBAdf
	awMM26xQNDJxts5Qk2NGpwoy4Bipgb9Ymkn+eow2sFEs0Wq10x3rF0/YyFZpz/m8IuG+bUDUzSUS3
	663Fq1esUt5unF3OOJ1Y9J397o0KTkAklRdM5WZe2nMaf5OnJHMklBB6WTgXOUJD3SUsfVCLp8aPD
	Koz0oU4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUv-00G6LV-2H;
	Wed, 16 Apr 2025 14:43:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:49 +0800
Date: Wed, 16 Apr 2025 14:43:49 +0800
Message-Id: <eee78928138f57ff699bd2aa89d1c40d4b07311e.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 29/67] crypto: riscv/sha256 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/riscv/crypto/sha256-riscv64-glue.c | 68 ++++++++++---------------
 include/crypto/sha256_base.h            |  3 ++
 lib/crypto/sha256.c                     | 18 +++++--
 3 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/arch/riscv/crypto/sha256-riscv64-glue.c b/arch/riscv/crypto/sha256-riscv64-glue.c
index 71e051e40a64..c998300ab843 100644
--- a/arch/riscv/crypto/sha256-riscv64-glue.c
+++ b/arch/riscv/crypto/sha256-riscv64-glue.c
@@ -14,7 +14,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/sha256_base.h>
-#include <linux/linkage.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
 /*
@@ -22,50 +22,36 @@
  * It is assumed to be the first field.
  */
 asmlinkage void sha256_transform_zvknha_or_zvknhb_zvkb(
-	struct sha256_state *state, const u8 *data, int num_blocks);
+	struct crypto_sha256_state *state, const u8 *data, int num_blocks);
+
+static void sha256_block(struct crypto_sha256_state *state, const u8 *data,
+			 int num_blocks)
+{
+	/*
+	 * Ensure struct crypto_sha256_state begins directly with the SHA-256
+	 * 256-bit internal state, as this is what the asm function expects.
+	 */
+	BUILD_BUG_ON(offsetof(struct crypto_sha256_state, state) != 0);
+
+	if (crypto_simd_usable()) {
+		kernel_vector_begin();
+		sha256_transform_zvknha_or_zvknhb_zvkb(state, data, num_blocks);
+		kernel_vector_end();
+	} else
+		sha256_transform_blocks(state, data, num_blocks);
+}
 
 static int riscv64_sha256_update(struct shash_desc *desc, const u8 *data,
 				 unsigned int len)
 {
-	/*
-	 * Ensure struct sha256_state begins directly with the SHA-256
-	 * 256-bit internal state, as this is what the asm function expects.
-	 */
-	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
-
-	if (crypto_simd_usable()) {
-		kernel_vector_begin();
-		sha256_base_do_update(desc, data, len,
-				      sha256_transform_zvknha_or_zvknhb_zvkb);
-		kernel_vector_end();
-	} else {
-		crypto_sha256_update(desc, data, len);
-	}
-	return 0;
+	return sha256_base_do_update_blocks(desc, data, len, sha256_block);
 }
 
 static int riscv64_sha256_finup(struct shash_desc *desc, const u8 *data,
 				unsigned int len, u8 *out)
 {
-	if (crypto_simd_usable()) {
-		kernel_vector_begin();
-		if (len)
-			sha256_base_do_update(
-				desc, data, len,
-				sha256_transform_zvknha_or_zvknhb_zvkb);
-		sha256_base_do_finalize(
-			desc, sha256_transform_zvknha_or_zvknhb_zvkb);
-		kernel_vector_end();
-
-		return sha256_base_finish(desc, out);
-	}
-
-	return crypto_sha256_finup(desc, data, len, out);
-}
-
-static int riscv64_sha256_final(struct shash_desc *desc, u8 *out)
-{
-	return riscv64_sha256_finup(desc, NULL, 0, out);
+	sha256_base_do_finup(desc, data, len, sha256_block);
+	return sha256_base_finish(desc, out);
 }
 
 static int riscv64_sha256_digest(struct shash_desc *desc, const u8 *data,
@@ -79,13 +65,14 @@ static struct shash_alg riscv64_sha256_algs[] = {
 	{
 		.init = sha256_base_init,
 		.update = riscv64_sha256_update,
-		.final = riscv64_sha256_final,
 		.finup = riscv64_sha256_finup,
 		.digest = riscv64_sha256_digest,
-		.descsize = sizeof(struct sha256_state),
+		.descsize = sizeof(struct crypto_sha256_state),
 		.digestsize = SHA256_DIGEST_SIZE,
 		.base = {
 			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				     CRYPTO_AHASH_ALG_FINUP_MAX,
 			.cra_priority = 300,
 			.cra_name = "sha256",
 			.cra_driver_name = "sha256-riscv64-zvknha_or_zvknhb-zvkb",
@@ -94,12 +81,13 @@ static struct shash_alg riscv64_sha256_algs[] = {
 	}, {
 		.init = sha224_base_init,
 		.update = riscv64_sha256_update,
-		.final = riscv64_sha256_final,
 		.finup = riscv64_sha256_finup,
-		.descsize = sizeof(struct sha256_state),
+		.descsize = sizeof(struct crypto_sha256_state),
 		.digestsize = SHA224_DIGEST_SIZE,
 		.base = {
 			.cra_blocksize = SHA224_BLOCK_SIZE,
+			.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				     CRYPTO_AHASH_ALG_FINUP_MAX,
 			.cra_priority = 300,
 			.cra_name = "sha224",
 			.cra_driver_name = "sha224-riscv64-zvknha_or_zvknhb-zvkb",
diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index 727a1b63e1e9..b9d3583b6256 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -198,4 +198,7 @@ static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
 	return __sha256_base_finish(sctx->state, out, digest_size);
 }
 
+void sha256_transform_blocks(struct crypto_sha256_state *sst,
+			     const u8 *input, int blocks);
+
 #endif /* _CRYPTO_SHA256_BASE_H */
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 04c1f2557e6c..39ead0222937 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -118,28 +118,36 @@ static void sha256_transform(u32 *state, const u8 *input, u32 *W)
 	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
 }
 
-static void sha256_transform_blocks(struct sha256_state *sctx,
-				    const u8 *input, int blocks)
+void sha256_transform_blocks(struct crypto_sha256_state *sst,
+			     const u8 *input, int blocks)
 {
 	u32 W[64];
 
 	do {
-		sha256_transform(sctx->state, input, W);
+		sha256_transform(sst->state, input, W);
 		input += SHA256_BLOCK_SIZE;
 	} while (--blocks);
 
 	memzero_explicit(W, sizeof(W));
 }
+EXPORT_SYMBOL_GPL(sha256_transform_blocks);
+
+static void lib_sha256_transform_blocks(struct sha256_state *sctx,
+					const u8 *input, int blocks)
+{
+	sha256_transform_blocks((struct crypto_sha256_state *)sctx, input,
+				blocks);
+}
 
 void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 {
-	lib_sha256_base_do_update(sctx, data, len, sha256_transform_blocks);
+	lib_sha256_base_do_update(sctx, data, len, lib_sha256_transform_blocks);
 }
 EXPORT_SYMBOL(sha256_update);
 
 static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_size)
 {
-	lib_sha256_base_do_finalize(sctx, sha256_transform_blocks);
+	lib_sha256_base_do_finalize(sctx, lib_sha256_transform_blocks);
 	lib_sha256_base_finish(sctx, out, digest_size);
 }
 
-- 
2.39.5

