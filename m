Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5395A2686AE
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945191; cv=none; b=ayyoFFnS0tYRD78LmI/Nf2BG2QIokDqwAjVDz+7qSKyJ2ALpbfNqkw/KYgSL7LB5kI7MMyjCBMTAMsEbHSr7bybF2b+zZOl26Ivl/PJJBWE1bQ//NP0CQlmcWHbFAWtfFz6Iclyy1tJzY2fIeKXq55KaU/lfM50Yik3rWn+ycVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945191; c=relaxed/simple;
	bh=mnTKLAJJqpSBoMn2qOlRGxiaeul7OcTtAOpET/YzAdI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Rox6ZO+KpvDZVyYiEZwwsbDAcD9Qe0LEx3tETcqWFjLLkn6/ZnyXbAPWnfIQyiem41DZGWypuJHI6IY+mtMG1+LtVCyT1OMQIfPsiSAJEz7n2NbfrICjx43L9KH7f0W7r521NQvh9I3t3YrRkp+hEHcwlOJbEcESC5jvCT5U1pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fzBusYEB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fzBusYEB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Qz+da9xGW9DIDsmuxEy5W6/6ufoGMbTepw664uvub0E=; b=fzBusYEBomCmMH8IdsGnEq2UCh
	Pn82kVtdnBGniZ2gf+Mrufo98iHg2j+NGELGaAqQaJkYPHn/36Gp8WAfKIh8DPCvMqIB7kBX5VzwT
	ZSjIK7AXbM9ovuTFssgeZOHrqUw9X2B339K9MdQ2/N2gL9as2obezDdLanSXWXweRJaBWeyBVKuqo
	c/9UUz2/5AidBrcr3Buu3K8g8qZIfswuAndIRUZ/wgnZ9/RRu9hNA68I7477hPQKxWrGEPgEoBCO3
	TZAfFwhf52MjmBr6fCFkSlkQXn6a6gWQ5Wnwl89C5CFAMP1B59tOuW/iNTGMz1X470HLaF4EgyVlC
	Ke9xNplg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxB-00Ge8f-2i;
	Fri, 18 Apr 2025 10:59:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:45 +0800
Date: Fri, 18 Apr 2025 10:59:45 +0800
Message-Id: <be6a5ce5c711494549072054b1d7d5c789025643.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 29/67] crypto: riscv/sha256 - Use API partial block
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

