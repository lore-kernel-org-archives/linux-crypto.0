Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E5C267B14
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945230; cv=none; b=YCyR4WVK76TEpoKWzWJRzPzqHHfKRhDC521mpfhJ15Xf2d90Z8G1opQSdHyjnRVgIOc77i0wQFo+HlnHyYogd0tSeWxbjm1GI0Kss3mPaNQ9UYXVYgC26r8wCgC4eMtf12dECU+EGmMijvDPBkAAWmERA4gLIlWlrheiNggay1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945230; c=relaxed/simple;
	bh=oCWIsU7it7RFCaB85UZtYguR/Qmiyl7CYoWLM6V2N0A=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=lRAyrmdn6DqAfI7hMJmhXcg8FuMp8cwvbKDIdI9W4oz7Kzvw/QUMfu4Rne8HyQHdSsQk2AaBDIyx0m95oWi2F1999zPfzhLTixoHFP3FCw3QHfv+GKU6PDCP9eu42K3vNHKyxOwvPzEDGzEpc7g7rk63UniLwOTDlUkJIXjJCkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kRrD+d+b; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kRrD+d+b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d4Huz3C69B7cDotE3V00uqfYDPm3xqAct2NTblL48lQ=; b=kRrD+d+bR3pQSgYqehzUNGYcXz
	6Mf5zdjb6pBQhEnlJOvUYbJ6t/nQm16Oi+2Sl06m6lebuZdBJXsvIlEeX2esf5rjR2gp6Hzn7LsCO
	VFCmjc9wI1cq+WQKIfhCEVZaI8j0qk7y8xtFqliD3YJh0oIs1qjrOESQfTjpBclrqFDwFBzLLV8WE
	JNuRvjXoklAk0wK4KQ0qODBhFpke4MPlhSecFHYBnduGZacGKBPtvo5aQB3sg0sLV80wiTNaN85xs
	+kdfL4l4P6qgxhsJqhJgFPLlZcPbaO79IiGcaCqjNY5hpIgpdMQe2YHZEP+LuX1lDGNlHNi8lLkAn
	XyvE9qtg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxp-00GeCq-04;
	Fri, 18 Apr 2025 11:00:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:25 +0800
Date: Fri, 18 Apr 2025 11:00:25 +0800
Message-Id: <0ee9b4f029bf211ad103b4d6f2c4ed9a3f2b32e5.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 46/67] crypto: riscv/sha512 - Use API partial block
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
 arch/riscv/crypto/sha512-riscv64-glue.c | 47 ++++++++++---------------
 crypto/sha512_generic.c                 |  5 +--
 include/crypto/sha512_base.h            |  6 ++++
 3 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/arch/riscv/crypto/sha512-riscv64-glue.c b/arch/riscv/crypto/sha512-riscv64-glue.c
index 43b56a08aeb5..4634fca78ae2 100644
--- a/arch/riscv/crypto/sha512-riscv64-glue.c
+++ b/arch/riscv/crypto/sha512-riscv64-glue.c
@@ -14,7 +14,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/sha512_base.h>
-#include <linux/linkage.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
 /*
@@ -24,8 +24,8 @@
 asmlinkage void sha512_transform_zvknhb_zvkb(
 	struct sha512_state *state, const u8 *data, int num_blocks);
 
-static int riscv64_sha512_update(struct shash_desc *desc, const u8 *data,
-				 unsigned int len)
+static void sha512_block(struct sha512_state *state, const u8 *data,
+			 int num_blocks)
 {
 	/*
 	 * Ensure struct sha512_state begins directly with the SHA-512
@@ -35,35 +35,24 @@ static int riscv64_sha512_update(struct shash_desc *desc, const u8 *data,
 
 	if (crypto_simd_usable()) {
 		kernel_vector_begin();
-		sha512_base_do_update(desc, data, len,
-				      sha512_transform_zvknhb_zvkb);
+		sha512_transform_zvknhb_zvkb(state, data, num_blocks);
 		kernel_vector_end();
 	} else {
-		crypto_sha512_update(desc, data, len);
+		sha512_generic_block_fn(state, data, num_blocks);
 	}
-	return 0;
+}
+
+static int riscv64_sha512_update(struct shash_desc *desc, const u8 *data,
+				 unsigned int len)
+{
+	return sha512_base_do_update_blocks(desc, data, len, sha512_block);
 }
 
 static int riscv64_sha512_finup(struct shash_desc *desc, const u8 *data,
 				unsigned int len, u8 *out)
 {
-	if (crypto_simd_usable()) {
-		kernel_vector_begin();
-		if (len)
-			sha512_base_do_update(desc, data, len,
-					      sha512_transform_zvknhb_zvkb);
-		sha512_base_do_finalize(desc, sha512_transform_zvknhb_zvkb);
-		kernel_vector_end();
-
-		return sha512_base_finish(desc, out);
-	}
-
-	return crypto_sha512_finup(desc, data, len, out);
-}
-
-static int riscv64_sha512_final(struct shash_desc *desc, u8 *out)
-{
-	return riscv64_sha512_finup(desc, NULL, 0, out);
+	sha512_base_do_finup(desc, data, len, sha512_block);
+	return sha512_base_finish(desc, out);
 }
 
 static int riscv64_sha512_digest(struct shash_desc *desc, const u8 *data,
@@ -77,14 +66,15 @@ static struct shash_alg riscv64_sha512_algs[] = {
 	{
 		.init = sha512_base_init,
 		.update = riscv64_sha512_update,
-		.final = riscv64_sha512_final,
 		.finup = riscv64_sha512_finup,
 		.digest = riscv64_sha512_digest,
-		.descsize = sizeof(struct sha512_state),
+		.descsize = SHA512_STATE_SIZE,
 		.digestsize = SHA512_DIGEST_SIZE,
 		.base = {
 			.cra_blocksize = SHA512_BLOCK_SIZE,
 			.cra_priority = 300,
+			.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				     CRYPTO_AHASH_ALG_FINUP_MAX,
 			.cra_name = "sha512",
 			.cra_driver_name = "sha512-riscv64-zvknhb-zvkb",
 			.cra_module = THIS_MODULE,
@@ -92,13 +82,14 @@ static struct shash_alg riscv64_sha512_algs[] = {
 	}, {
 		.init = sha384_base_init,
 		.update = riscv64_sha512_update,
-		.final = riscv64_sha512_final,
 		.finup = riscv64_sha512_finup,
-		.descsize = sizeof(struct sha512_state),
+		.descsize = SHA512_STATE_SIZE,
 		.digestsize = SHA384_DIGEST_SIZE,
 		.base = {
 			.cra_blocksize = SHA384_BLOCK_SIZE,
 			.cra_priority = 300,
+			.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				     CRYPTO_AHASH_ALG_FINUP_MAX,
 			.cra_name = "sha384",
 			.cra_driver_name = "sha384-riscv64-zvknhb-zvkb",
 			.cra_module = THIS_MODULE,
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index ed81813bd420..27a7346ff143 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -145,14 +145,15 @@ sha512_transform(u64 *state, const u8 *input)
 	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
 }
 
-static void sha512_generic_block_fn(struct sha512_state *sst, u8 const *src,
-				    int blocks)
+void sha512_generic_block_fn(struct sha512_state *sst, u8 const *src,
+			     int blocks)
 {
 	while (blocks--) {
 		sha512_transform(sst->state, src);
 		src += SHA512_BLOCK_SIZE;
 	}
 }
+EXPORT_SYMBOL_GPL(sha512_generic_block_fn);
 
 int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
diff --git a/include/crypto/sha512_base.h b/include/crypto/sha512_base.h
index 8cb172e52dc0..e9f302ec3ede 100644
--- a/include/crypto/sha512_base.h
+++ b/include/crypto/sha512_base.h
@@ -10,7 +10,10 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
+#include <linux/compiler.h>
+#include <linux/math.h>
 #include <linux/string.h>
+#include <linux/types.h>
 #include <linux/unaligned.h>
 
 typedef void (sha512_block_fn)(struct sha512_state *sst, u8 const *src,
@@ -175,4 +178,7 @@ static inline int sha512_base_finish(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
+void sha512_generic_block_fn(struct sha512_state *sst, u8 const *src,
+			     int blocks);
+
 #endif /* _CRYPTO_SHA512_BASE_H */
-- 
2.39.5

