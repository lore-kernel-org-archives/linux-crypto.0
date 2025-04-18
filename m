Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B88267F51
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945132; cv=none; b=mPr7KmyvL22t0jvorllIi3J9fJbZtss1Ez/PIpmb8AdAU4tAV30Ooay9T9iXFlPAIOcT3kWXzKXoV7cDk6H/j+IyjeTY6xhJBL3vZM5FNezGgh2wVpPRnJdfzfibLgsX7NA/xpJYLudXFtl5c3NuRtml2UbDBUCvAg0moaryoEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945132; c=relaxed/simple;
	bh=xmlrVQUbZ9FKgGtbBWEHGHPJaSYsYMZtOe++DSrQom8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=cx9sfXHBPAeAKe4tk+8TkugNsBDLDAd+D/isCFgQYo1ec620LGXXa0zgTHGzB05Po8dz9fwxGVjFhi3dg/MwrA1TpDOfh3JrdAzqcM62qg6GmCZ4Kf43caAnOU9fJDObaT9TXSHECjaHryltcswyJ36NDTDu4d2RxJYhgHQ0ih0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mD8PS19C; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mD8PS19C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KXph+NYQoyYYxciGmgBltGxugdAbkE+XVcFsJK3XjWc=; b=mD8PS19C4UB5hMRa0yW4cNfvnu
	qekefW7mwyT7QJElGKc84zLnYUMDRinZ8bLZequ/RZ4GDEalLF/1hSI7tFpQw4BZmp5mWwQGyB/yU
	8fmaaAC/IHX3ZV4rFOQ8V805c0iDh9rLkHIiidoLImjMfRvgYbmsposHLsduzngiT7zFRG3GnN2vs
	ju9FXgRPhJhQC6kgSxx9xHp/qkCBTXhoviLwohtD1cxPxD+iBrXk7CBNGf9bO+0Hmprt7TvfIe031
	AFrn2f4P+ZC6Dj4V3iHnbWSZjknF2YgHyIMn92qrWQ9M5NOq/MGPOYiz5Ght6PReWa/bfO6YUL3Cf
	l4vV0BVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwD-00Ge2U-27;
	Fri, 18 Apr 2025 10:58:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:58:45 +0800
Date: Fri, 18 Apr 2025 10:58:45 +0800
Message-Id: <40a1ffc4c66dd5a0f3c77c8d0301609b91af09dd.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 03/67] crypto: arm/blake2b - Use API partial block handling
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
 arch/arm/crypto/blake2b-neon-glue.c | 20 +++++-----
 include/crypto/blake2b.h            | 21 +++++-----
 include/crypto/internal/blake2b.h   | 62 -----------------------------
 3 files changed, 19 insertions(+), 84 deletions(-)

diff --git a/arch/arm/crypto/blake2b-neon-glue.c b/arch/arm/crypto/blake2b-neon-glue.c
index 4b59d027ba4a..7ae4ba0afe06 100644
--- a/arch/arm/crypto/blake2b-neon-glue.c
+++ b/arch/arm/crypto/blake2b-neon-glue.c
@@ -7,7 +7,6 @@
 
 #include <crypto/internal/blake2b.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 
 #include <linux/module.h>
 #include <linux/sizes.h>
@@ -21,11 +20,6 @@ asmlinkage void blake2b_compress_neon(struct blake2b_state *state,
 static void blake2b_compress_arch(struct blake2b_state *state,
 				  const u8 *block, size_t nblocks, u32 inc)
 {
-	if (!crypto_simd_usable()) {
-		blake2b_compress_generic(state, block, nblocks, inc);
-		return;
-	}
-
 	do {
 		const size_t blocks = min_t(size_t, nblocks,
 					    SZ_4K / BLAKE2B_BLOCK_SIZE);
@@ -42,12 +36,14 @@ static void blake2b_compress_arch(struct blake2b_state *state,
 static int crypto_blake2b_update_neon(struct shash_desc *desc,
 				      const u8 *in, unsigned int inlen)
 {
-	return crypto_blake2b_update(desc, in, inlen, blake2b_compress_arch);
+	return crypto_blake2b_update_bo(desc, in, inlen, blake2b_compress_arch);
 }
 
-static int crypto_blake2b_final_neon(struct shash_desc *desc, u8 *out)
+static int crypto_blake2b_finup_neon(struct shash_desc *desc, const u8 *in,
+				     unsigned int inlen, u8 *out)
 {
-	return crypto_blake2b_final(desc, out, blake2b_compress_arch);
+	return crypto_blake2b_finup(desc, in, inlen, out,
+				    blake2b_compress_arch);
 }
 
 #define BLAKE2B_ALG(name, driver_name, digest_size)			\
@@ -55,7 +51,8 @@ static int crypto_blake2b_final_neon(struct shash_desc *desc, u8 *out)
 		.base.cra_name		= name,				\
 		.base.cra_driver_name	= driver_name,			\
 		.base.cra_priority	= 200,				\
-		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,	\
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY |	\
+					  CRYPTO_AHASH_ALG_BLOCK_ONLY,	\
 		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,		\
 		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx), \
 		.base.cra_module	= THIS_MODULE,			\
@@ -63,8 +60,9 @@ static int crypto_blake2b_final_neon(struct shash_desc *desc, u8 *out)
 		.setkey			= crypto_blake2b_setkey,	\
 		.init			= crypto_blake2b_init,		\
 		.update			= crypto_blake2b_update_neon,	\
-		.final			= crypto_blake2b_final_neon,	\
+		.finup			= crypto_blake2b_finup_neon,	\
 		.descsize		= sizeof(struct blake2b_state),	\
+		.statesize		= BLAKE2B_STATE_SIZE,		\
 	}
 
 static struct shash_alg blake2b_neon_algs[] = {
diff --git a/include/crypto/blake2b.h b/include/crypto/blake2b.h
index 68da368dc182..dd7694477e50 100644
--- a/include/crypto/blake2b.h
+++ b/include/crypto/blake2b.h
@@ -7,12 +7,20 @@
 #include <linux/types.h>
 #include <linux/string.h>
 
+struct blake2b_state {
+	/* 'h', 't', and 'f' are used in assembly code, so keep them as-is. */
+	u64 h[8];
+	u64 t[2];
+	/* The true state ends here.  The rest is temporary storage. */
+	u64 f[2];
+};
+
 enum blake2b_lengths {
 	BLAKE2B_BLOCK_SIZE = 128,
 	BLAKE2B_HASH_SIZE = 64,
 	BLAKE2B_KEY_SIZE = 64,
-	BLAKE2B_STATE_SIZE = 80,
-	BLAKE2B_DESC_SIZE = 96,
+	BLAKE2B_STATE_SIZE = offsetof(struct blake2b_state, f),
+	BLAKE2B_DESC_SIZE = sizeof(struct blake2b_state),
 
 	BLAKE2B_160_HASH_SIZE = 20,
 	BLAKE2B_256_HASH_SIZE = 32,
@@ -20,15 +28,6 @@ enum blake2b_lengths {
 	BLAKE2B_512_HASH_SIZE = 64,
 };
 
-struct blake2b_state {
-	/* 'h', 't', and 'f' are used in assembly code, so keep them as-is. */
-	u64 h[8];
-	u64 t[2];
-	u64 f[2];
-	u8 buf[BLAKE2B_BLOCK_SIZE];
-	unsigned int buflen;
-};
-
 enum blake2b_iv {
 	BLAKE2B_IV0 = 0x6A09E667F3BCC908ULL,
 	BLAKE2B_IV1 = 0xBB67AE8584CAA73BULL,
diff --git a/include/crypto/internal/blake2b.h b/include/crypto/internal/blake2b.h
index 48dc9830400d..3e09e2485306 100644
--- a/include/crypto/internal/blake2b.h
+++ b/include/crypto/internal/blake2b.h
@@ -33,48 +33,6 @@ static inline void blake2b_set_nonlast(struct blake2b_state *state)
 typedef void (*blake2b_compress_t)(struct blake2b_state *state,
 				   const u8 *block, size_t nblocks, u32 inc);
 
-static inline void __blake2b_update(struct blake2b_state *state,
-				    const u8 *in, size_t inlen,
-				    blake2b_compress_t compress)
-{
-	const size_t fill = BLAKE2B_BLOCK_SIZE - state->buflen;
-
-	if (unlikely(!inlen))
-		return;
-	blake2b_set_nonlast(state);
-	if (inlen > fill) {
-		memcpy(state->buf + state->buflen, in, fill);
-		(*compress)(state, state->buf, 1, BLAKE2B_BLOCK_SIZE);
-		state->buflen = 0;
-		in += fill;
-		inlen -= fill;
-	}
-	if (inlen > BLAKE2B_BLOCK_SIZE) {
-		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2B_BLOCK_SIZE);
-		/* Hash one less (full) block than strictly possible */
-		(*compress)(state, in, nblocks - 1, BLAKE2B_BLOCK_SIZE);
-		in += BLAKE2B_BLOCK_SIZE * (nblocks - 1);
-		inlen -= BLAKE2B_BLOCK_SIZE * (nblocks - 1);
-	}
-	memcpy(state->buf + state->buflen, in, inlen);
-	state->buflen += inlen;
-}
-
-static inline void __blake2b_final(struct blake2b_state *state, u8 *out,
-				   unsigned int outlen,
-				   blake2b_compress_t compress)
-{
-	int i;
-
-	blake2b_set_lastblock(state);
-	memset(state->buf + state->buflen, 0,
-	       BLAKE2B_BLOCK_SIZE - state->buflen); /* Padding */
-	(*compress)(state, state->buf, 1, state->buflen);
-	for (i = 0; i < ARRAY_SIZE(state->h); i++)
-		__cpu_to_le64s(&state->h[i]);
-	memcpy(out, state->h, outlen);
-}
-
 /* Helper functions for shash implementations of BLAKE2b */
 
 struct blake2b_tfm_ctx {
@@ -110,16 +68,6 @@ static inline int crypto_blake2b_init(struct shash_desc *desc)
 	       crypto_shash_update(desc, tctx->key, BLAKE2B_BLOCK_SIZE) : 0;
 }
 
-static inline int crypto_blake2b_update(struct shash_desc *desc,
-					const u8 *in, unsigned int inlen,
-					blake2b_compress_t compress)
-{
-	struct blake2b_state *state = shash_desc_ctx(desc);
-
-	__blake2b_update(state, in, inlen, compress);
-	return 0;
-}
-
 static inline int crypto_blake2b_update_bo(struct shash_desc *desc,
 					   const u8 *in, unsigned int inlen,
 					   blake2b_compress_t compress)
@@ -131,16 +79,6 @@ static inline int crypto_blake2b_update_bo(struct shash_desc *desc,
 	return inlen - round_down(inlen, BLAKE2B_BLOCK_SIZE);
 }
 
-static inline int crypto_blake2b_final(struct shash_desc *desc, u8 *out,
-				       blake2b_compress_t compress)
-{
-	unsigned int outlen = crypto_shash_digestsize(desc->tfm);
-	struct blake2b_state *state = shash_desc_ctx(desc);
-
-	__blake2b_final(state, out, outlen, compress);
-	return 0;
-}
-
 static inline int crypto_blake2b_finup(struct shash_desc *desc, const u8 *in,
 				       unsigned int inlen, u8 *out,
 				       blake2b_compress_t compress)
-- 
2.39.5

