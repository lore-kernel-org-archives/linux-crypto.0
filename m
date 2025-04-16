Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B2522DFBF
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785803; cv=none; b=TEH5rLJBQB434oW90WH3bmpUXCMWgU8zZek12P07jYkQV23S3eu6x3YKEnFvDQHhuVD6U4fO3AKMAyGVcB+dokVuTHhmPOey68wkY6SqJYGK7ClmCfdW2HvuR6L8wzuGeH91/GZPbkxjBH3ItxlB3R3ZtIFjctRzzFsG6N+MRls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785803; c=relaxed/simple;
	bh=xZnqTSGcKc243BuF8jz0ehYSPYwl7oAqr2c2I0KIaA8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=mvyPDLEO5I60JjC3lGwazJKG4Sj1HbrViz5mViSkbY+yALdB6tz07LWA0KAA3J3MDc1RMPaa4tG3ZjTlL7HXbfjPKCkqM0loJ35/8cpBCCb9VvmFtKJzB/r8XsU0/qKRvdp+fqieC3MSVqPoU7NJEo3XFo56Fa2BBSB3Ut1N29g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LRdtmXk5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LRdtmXk5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BaUVNUOM3mLvCAqnUWLDH9aIa7jYpo91YL/EUuaQCxc=; b=LRdtmXk5WOT+/DcBeoybeT9ZBi
	bhiZot+NiSSx5zGIabyQQCOZovO5svUPvFNZMZ11mlE0zyzGJzG5cZtuKMa4sgsxITLfFmb9Ae2mk
	wlPtztfGKJfiaQEyAxUi3dnuU1LkTe5SNNcUvUdqVWTvZZAKLddnVQNdgX8ErAKZuiI/6wmSBWoWo
	x3ECqldoQ3KJek1vcimbRGkcjEcacUFcNufoSv8rGw7LNdx/tKyvJnWXIyL2zf4NmMSN9N6akUVfy
	C+09ybDgUiNwiHWcmoYcHf2ocl/osyMJCKX7PQMaZoZsrOJg3d+kYC71p8RJMK2luKHrgP65g7Q4d
	PHJADtqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUP-00G6Iy-1U;
	Wed, 16 Apr 2025 14:43:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:17 +0800
Date: Wed, 16 Apr 2025 14:43:17 +0800
Message-Id: <3c8ed32814c08bc6ececcaeb76b08d103bc001e9.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/67] crypto: x86/sha1 - Use API partial block handling
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
 arch/x86/crypto/sha1_ssse3_glue.c | 81 ++++++++++---------------------
 include/crypto/sha1.h             |  1 +
 include/crypto/sha1_base.h        | 42 ++++++++++++++--
 3 files changed, 64 insertions(+), 60 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index abb793cbad01..0a912bfc86c5 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -16,16 +16,14 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
-#include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
-#include <crypto/sha1.h>
-#include <crypto/sha1_base.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha1.h>
+#include <crypto/sha1_base.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 static const struct x86_cpu_id module_cpu_ids[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
@@ -36,14 +34,10 @@ static const struct x86_cpu_id module_cpu_ids[] = {
 };
 MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
 
-static int sha1_update(struct shash_desc *desc, const u8 *data,
-			     unsigned int len, sha1_block_fn *sha1_xform)
+static inline int sha1_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, sha1_block_fn *sha1_xform)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
-		return crypto_sha1_update(desc, data, len);
+	int remain;
 
 	/*
 	 * Make sure struct sha1_state begins directly with the SHA1
@@ -52,22 +46,18 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	BUILD_BUG_ON(offsetof(struct sha1_state, state) != 0);
 
 	kernel_fpu_begin();
-	sha1_base_do_update(desc, data, len, sha1_xform);
+	remain = sha1_base_do_update_blocks(desc, data, len, sha1_xform);
 	kernel_fpu_end();
 
-	return 0;
+	return remain;
 }
 
-static int sha1_finup(struct shash_desc *desc, const u8 *data,
-		      unsigned int len, u8 *out, sha1_block_fn *sha1_xform)
+static inline int sha1_finup(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *out,
+			     sha1_block_fn *sha1_xform)
 {
-	if (!crypto_simd_usable())
-		return crypto_sha1_finup(desc, data, len, out);
-
 	kernel_fpu_begin();
-	if (len)
-		sha1_base_do_update(desc, data, len, sha1_xform);
-	sha1_base_do_finalize(desc, sha1_xform);
+	sha1_base_do_finup(desc, data, len, sha1_xform);
 	kernel_fpu_end();
 
 	return sha1_base_finish(desc, out);
@@ -88,23 +78,17 @@ static int sha1_ssse3_finup(struct shash_desc *desc, const u8 *data,
 	return sha1_finup(desc, data, len, out, sha1_transform_ssse3);
 }
 
-/* Add padding and return the message digest. */
-static int sha1_ssse3_final(struct shash_desc *desc, u8 *out)
-{
-	return sha1_ssse3_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg sha1_ssse3_alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	sha1_ssse3_update,
-	.final		=	sha1_ssse3_final,
 	.finup		=	sha1_ssse3_finup,
-	.descsize	=	sizeof(struct sha1_state),
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name =	"sha1-ssse3",
 		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -138,22 +122,17 @@ static int sha1_avx_finup(struct shash_desc *desc, const u8 *data,
 	return sha1_finup(desc, data, len, out, sha1_transform_avx);
 }
 
-static int sha1_avx_final(struct shash_desc *desc, u8 *out)
-{
-	return sha1_avx_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg sha1_avx_alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	sha1_avx_update,
-	.final		=	sha1_avx_final,
 	.finup		=	sha1_avx_finup,
-	.descsize	=	sizeof(struct sha1_state),
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name =	"sha1-avx",
 		.cra_priority	=	160,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -198,8 +177,8 @@ static bool avx2_usable(void)
 	return false;
 }
 
-static void sha1_apply_transform_avx2(struct sha1_state *state,
-				      const u8 *data, int blocks)
+static inline void sha1_apply_transform_avx2(struct sha1_state *state,
+					     const u8 *data, int blocks)
 {
 	/* Select the optimal transform based on data block size */
 	if (blocks >= SHA1_AVX2_BLOCK_OPTSIZE)
@@ -220,22 +199,17 @@ static int sha1_avx2_finup(struct shash_desc *desc, const u8 *data,
 	return sha1_finup(desc, data, len, out, sha1_apply_transform_avx2);
 }
 
-static int sha1_avx2_final(struct shash_desc *desc, u8 *out)
-{
-	return sha1_avx2_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg sha1_avx2_alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	sha1_avx2_update,
-	.final		=	sha1_avx2_final,
 	.finup		=	sha1_avx2_finup,
-	.descsize	=	sizeof(struct sha1_state),
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name =	"sha1-avx2",
 		.cra_priority	=	170,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -269,22 +243,17 @@ static int sha1_ni_finup(struct shash_desc *desc, const u8 *data,
 	return sha1_finup(desc, data, len, out, sha1_ni_transform);
 }
 
-static int sha1_ni_final(struct shash_desc *desc, u8 *out)
-{
-	return sha1_ni_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg sha1_ni_alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	sha1_ni_update,
-	.final		=	sha1_ni_final,
 	.finup		=	sha1_ni_finup,
-	.descsize	=	sizeof(struct sha1_state),
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name =	"sha1-ni",
 		.cra_priority	=	250,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
index 044ecea60ac8..dd6de4a4d6e6 100644
--- a/include/crypto/sha1.h
+++ b/include/crypto/sha1.h
@@ -10,6 +10,7 @@
 
 #define SHA1_DIGEST_SIZE        20
 #define SHA1_BLOCK_SIZE         64
+#define SHA1_STATE_SIZE         offsetof(struct sha1_state, buffer)
 
 #define SHA1_H0		0x67452301UL
 #define SHA1_H1		0xefcdab89UL
diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
index 0c342ed0d038..b23cfad18ce2 100644
--- a/include/crypto/sha1_base.h
+++ b/include/crypto/sha1_base.h
@@ -10,10 +10,9 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/sha1.h>
-#include <linux/crypto.h>
-#include <linux/module.h>
+#include <linux/math.h>
 #include <linux/string.h>
-
+#include <linux/types.h>
 #include <linux/unaligned.h>
 
 typedef void (sha1_block_fn)(struct sha1_state *sst, u8 const *src, int blocks);
@@ -70,6 +69,19 @@ static inline int sha1_base_do_update(struct shash_desc *desc,
 	return 0;
 }
 
+static inline int sha1_base_do_update_blocks(struct shash_desc *desc,
+					     const u8 *data,
+					     unsigned int len,
+					     sha1_block_fn *block_fn)
+{
+	unsigned int remain = len - round_down(len, SHA1_BLOCK_SIZE);
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	sctx->count += len - remain;
+	block_fn(sctx, data, len / SHA1_BLOCK_SIZE);
+	return remain;
+}
+
 static inline int sha1_base_do_finalize(struct shash_desc *desc,
 					sha1_block_fn *block_fn)
 {
@@ -93,6 +105,29 @@ static inline int sha1_base_do_finalize(struct shash_desc *desc,
 	return 0;
 }
 
+static inline int sha1_base_do_finup(struct shash_desc *desc,
+				     const u8 *src, unsigned int len,
+				     sha1_block_fn *block_fn)
+{
+	unsigned int bit_offset = SHA1_BLOCK_SIZE / 8 - 1;
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	union {
+		__be64 b64[SHA1_BLOCK_SIZE / 4];
+		u8 u8[SHA1_BLOCK_SIZE * 2];
+	} block = {};
+
+	if (len >= bit_offset * 8)
+		bit_offset += SHA1_BLOCK_SIZE / 8;
+	memcpy(&block, src, len);
+	block.u8[len] = 0x80;
+	sctx->count += len;
+	block.b64[bit_offset] = cpu_to_be64(sctx->count << 3);
+	block_fn(sctx, block.u8, (bit_offset + 1) * 8 / SHA1_BLOCK_SIZE);
+	memzero_explicit(&block, sizeof(block));
+
+	return 0;
+}
+
 static inline int sha1_base_finish(struct shash_desc *desc, u8 *out)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
@@ -102,7 +137,6 @@ static inline int sha1_base_finish(struct shash_desc *desc, u8 *out)
 	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
 		put_unaligned_be32(sctx->state[i], digest++);
 
-	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
-- 
2.39.5

