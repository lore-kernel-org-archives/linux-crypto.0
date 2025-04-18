Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0562E23ED5A
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945144; cv=none; b=pk/APTW0H8/pQiaiP8UiAG8p0lkJ//4kNVFQBxNDdMhmLQ8+32FkcpuB1vSHIFJmJ/QhVGBX+sM/0rE8WPKd0+FvqPuDAb28yjzbxPSURhnKZbLH5UAtKkLgncst2QfzTbb8Bw2cegRQANQDpGFtxEd8j5aR1W8kpydSjMjRljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945144; c=relaxed/simple;
	bh=9d/xZUV5DOobkyOf82dKTLStsGJ8efl9s5uPWjspXrQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=nRfhYfufTfQXTQ3YFxByQkdKNTD1Q5ckp4Jn2jeWFIkoiD0wO4YgDCFPjSuYVAb/Dh+so1Yn6J/pFWiL9ufEB1hw5gXUFw/iTb55A9z4fraOVHQx8WopUHvwreBz8RhxvHL56m+9CYBIiUrbLDEMl/1FJ/3E7zpaji4IFqsLAUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Muov6aPz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Muov6aPz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UJn4Idi0q6cC9DeMCvqyd1Bvs15yorgEjA8iFwqskp8=; b=Muov6aPz9pbm2Mtzvp0rXOHOnl
	LCiKRbhtQBrhEFlikriF5n2AkIbazrkygCPHw4A2hQMftpjykV5bjkHxKgiOU7UqhbNWQxGrWmwef
	FgGNJBYhXhm+38EJbaC4l8SEOWzsOhEzt3OV8eYJBYgBd2w0b2WpNOn/INek5oQPn1oA8Ssok0LOs
	VDHQ3Rby+82KzfSxLD+DDise2GfaYeym1l8B5/MW/3hG35b1bN41Bc8nfrU7tYjHfpdflKmI0NICX
	LOGPMxz8QomceUHvb5p5PxaOazKuXuhs+rYzKqSFviZ6Vdb1KQYleZTFmh3uAo5xAzUASMdAGidYP
	xw0jfe6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwP-00Ge3l-0p;
	Fri, 18 Apr 2025 10:58:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:58:57 +0800
Date: Fri, 18 Apr 2025 10:58:57 +0800
Message-Id: <b89a0b3c2c5f8e03bc70e3bc06b71020684a98c6.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 08/67] crypto: riscv/ghash - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

As this was the last user relying on crypto/ghash.h for gf128mul.h,
remove the unnecessary inclusion of gf128mul.h from crypto/ghash.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/riscv/crypto/ghash-riscv64-glue.c | 58 ++++++++------------------
 include/crypto/ghash.h                 |  1 -
 2 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/arch/riscv/crypto/ghash-riscv64-glue.c b/arch/riscv/crypto/ghash-riscv64-glue.c
index 312e7891fd0a..d86073d25387 100644
--- a/arch/riscv/crypto/ghash-riscv64-glue.c
+++ b/arch/riscv/crypto/ghash-riscv64-glue.c
@@ -11,11 +11,16 @@
 
 #include <asm/simd.h>
 #include <asm/vector.h>
+#include <crypto/b128ops.h>
+#include <crypto/gf128mul.h>
 #include <crypto/ghash.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
-#include <linux/linkage.h>
+#include <crypto/utils.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 asmlinkage void ghash_zvkg(be128 *accumulator, const be128 *key, const u8 *data,
 			   size_t len);
@@ -26,8 +31,6 @@ struct riscv64_ghash_tfm_ctx {
 
 struct riscv64_ghash_desc_ctx {
 	be128 accumulator;
-	u8 buffer[GHASH_BLOCK_SIZE];
-	u32 bytes;
 };
 
 static int riscv64_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
@@ -78,50 +81,24 @@ static int riscv64_ghash_update(struct shash_desc *desc, const u8 *src,
 {
 	const struct riscv64_ghash_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	unsigned int len;
 
-	if (dctx->bytes) {
-		if (dctx->bytes + srclen < GHASH_BLOCK_SIZE) {
-			memcpy(dctx->buffer + dctx->bytes, src, srclen);
-			dctx->bytes += srclen;
-			return 0;
-		}
-		memcpy(dctx->buffer + dctx->bytes, src,
-		       GHASH_BLOCK_SIZE - dctx->bytes);
-		riscv64_ghash_blocks(tctx, dctx, dctx->buffer,
-				     GHASH_BLOCK_SIZE);
-		src += GHASH_BLOCK_SIZE - dctx->bytes;
-		srclen -= GHASH_BLOCK_SIZE - dctx->bytes;
-		dctx->bytes = 0;
-	}
-
-	len = round_down(srclen, GHASH_BLOCK_SIZE);
-	if (len) {
-		riscv64_ghash_blocks(tctx, dctx, src, len);
-		src += len;
-		srclen -= len;
-	}
-
-	if (srclen) {
-		memcpy(dctx->buffer, src, srclen);
-		dctx->bytes = srclen;
-	}
-
-	return 0;
+	riscv64_ghash_blocks(tctx, dctx, src,
+			     round_down(srclen, GHASH_BLOCK_SIZE));
+	return srclen - round_down(srclen, GHASH_BLOCK_SIZE);
 }
 
-static int riscv64_ghash_final(struct shash_desc *desc, u8 *out)
+static int riscv64_ghash_finup(struct shash_desc *desc, const u8 *src,
+			       unsigned int len, u8 *out)
 {
 	const struct riscv64_ghash_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
 	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	int i;
 
-	if (dctx->bytes) {
-		for (i = dctx->bytes; i < GHASH_BLOCK_SIZE; i++)
-			dctx->buffer[i] = 0;
+	if (len) {
+		u8 buf[GHASH_BLOCK_SIZE] = {};
 
-		riscv64_ghash_blocks(tctx, dctx, dctx->buffer,
-				     GHASH_BLOCK_SIZE);
+		memcpy(buf, src, len);
+		riscv64_ghash_blocks(tctx, dctx, buf, GHASH_BLOCK_SIZE);
+		memzero_explicit(buf, sizeof(buf));
 	}
 
 	memcpy(out, &dctx->accumulator, GHASH_DIGEST_SIZE);
@@ -131,7 +108,7 @@ static int riscv64_ghash_final(struct shash_desc *desc, u8 *out)
 static struct shash_alg riscv64_ghash_alg = {
 	.init = riscv64_ghash_init,
 	.update = riscv64_ghash_update,
-	.final = riscv64_ghash_final,
+	.finup = riscv64_ghash_finup,
 	.setkey = riscv64_ghash_setkey,
 	.descsize = sizeof(struct riscv64_ghash_desc_ctx),
 	.digestsize = GHASH_DIGEST_SIZE,
@@ -139,6 +116,7 @@ static struct shash_alg riscv64_ghash_alg = {
 		.cra_blocksize = GHASH_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct riscv64_ghash_tfm_ctx),
 		.cra_priority = 300,
+		.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_name = "ghash",
 		.cra_driver_name = "ghash-riscv64-zvkg",
 		.cra_module = THIS_MODULE,
diff --git a/include/crypto/ghash.h b/include/crypto/ghash.h
index 16904f2b5184..043d938e9a2c 100644
--- a/include/crypto/ghash.h
+++ b/include/crypto/ghash.h
@@ -7,7 +7,6 @@
 #define __CRYPTO_GHASH_H__
 
 #include <linux/types.h>
-#include <crypto/gf128mul.h>
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
-- 
2.39.5

