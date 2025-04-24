Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B09D22688C
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491641; cv=none; b=PMmlr6bz9d/jkX3DQFS4MU+aD4Hc8UDumL12KN8l4dS59XAIVYauzd4HSzww77ZjUZj/vTDWNRTafjM1TJxLLYwnXJuhCnO61efGOSDE4dsIqbHndgK7wR5U3qi5q/DgTsM6fUufXPm615X9AuH6oWhFOJxWM36Km7YfimgYAIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491641; c=relaxed/simple;
	bh=FaY8tVDBw26hqSdF+kc+JAVreb1Z6qrpqKCCLXxSRRk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=KcZ9Nduj2YrkMissD1ymENLc7syuIeC+B/vK7F1gCWq5S+mNaTFtLHAmeUGfZ5QII2/N9uEtxXXDxVSPxO8es/gfTD/HwM6j0U8F4eWtX068UcnLwhWUwSMYwbKT9CS4QJaWVgw2eDxzT/Ebp/0AArQHU56LU2vvv/V0/iboD/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HXRNo9Bw; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HXRNo9Bw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=egkG/yHE62KZZ9KS+xuvU3K84kP7gt9TajOvrHB7C4Y=; b=HXRNo9Bw+D0xVZoBBTx5P09PvK
	MwNNTwWNgWlWsNQavmsAM/jjoQLvMchmOGIpHb8ROkAbZFUDG8O/ljSaUlDNo6Xy5akGnIH6vWok6
	xDTk9mmzIY0fgGAcsXDnr2TMpMDJxjqAUsqfCzaT/NosT2pRAFZ8iAizFtHJuN6cqOTOCUpOjFyAh
	L+a2VCPZkhIATcPkI6QWAqsag94InrAj5FqbdwYAco9NmB6jlbT89/DCwtltKdkWVOpljB9XAkrXr
	h4hMSOjmK4TCFBNSQ/CFeEepVjzmrkrxFnN0WG2poL4I9oxNIy2vLIt8oSiaZ7cJkAiFcGvKZh5Zg
	wCAErhlA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u6s-000fMe-2F;
	Thu, 24 Apr 2025 18:47:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:14 +0800
Date: Thu, 24 Apr 2025 18:47:14 +0800
Message-Id: <20c70ad952dc0893294f490a1e31c9cfe90812a9.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 08/15] crypto: poly1305 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also add a setkey function that may be used instead of setting
the key through the first two blocks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/poly1305.c      | 137 +++++++++++++++++++++++++++++++----------
 include/linux/crypto.h |   3 +
 2 files changed, 109 insertions(+), 31 deletions(-)

diff --git a/crypto/poly1305.c b/crypto/poly1305.c
index e0436bdc462b..9c36ff4bd9c4 100644
--- a/crypto/poly1305.c
+++ b/crypto/poly1305.c
@@ -9,57 +9,107 @@
  * (at your option) any later version.
  */
 
-#include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/poly1305.h>
-#include <linux/crypto.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
+
+#define CRYPTO_POLY1305_TFM_HAS_KEY 0x00100000
+
+struct crypto_poly1305_ctx {
+	struct poly1305_block_state state;
+	u32 s[4];
+};
 
 struct crypto_poly1305_desc_ctx {
-	struct poly1305_desc_ctx base;
-	u8 key[POLY1305_KEY_SIZE];
+	struct crypto_poly1305_ctx base;
 	unsigned int keysize;
 };
 
+static int crypto_poly1305_setkey(struct crypto_shash *tfm, const u8 *key,
+				  unsigned int len, bool arch)
+{
+	struct crypto_poly1305_ctx *ctx = crypto_shash_ctx(tfm);
+
+	if (len != POLY1305_KEY_SIZE)
+		return -EINVAL;
+
+	if (arch)
+		poly1305_block_init_arch(&ctx->state, key);
+	else
+		poly1305_block_init_generic(&ctx->state, key);
+	memcpy(ctx->s, key + POLY1305_BLOCK_SIZE, sizeof(ctx->s));
+	crypto_shash_set_flags(tfm, CRYPTO_POLY1305_TFM_HAS_KEY);
+	return 0;
+}
+
+static int crypto_poly1305_setkey_generic(struct crypto_shash *tfm,
+					  const u8 *key, unsigned int len)
+{
+	return crypto_poly1305_setkey(tfm, key, len, false);
+}
+
+static int crypto_poly1305_setkey_arch(struct crypto_shash *tfm, const u8 *key,
+				       unsigned int len)
+{
+	return crypto_poly1305_setkey(tfm, key, len, true);
+}
+
 static int crypto_poly1305_init(struct shash_desc *desc)
 {
 	struct crypto_poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct crypto_shash *tfm = desc->tfm;
+	struct crypto_poly1305_ctx *ctx;
 
+	ctx = crypto_shash_ctx(tfm);
+	dctx->base = *ctx;
 	dctx->keysize = 0;
+	if (crypto_shash_get_flags(tfm) & CRYPTO_POLY1305_TFM_HAS_KEY)
+		dctx->keysize = POLY1305_KEY_SIZE;
 	return 0;
 }
 
-static int crypto_poly1305_update(struct shash_desc *desc,
-				  const u8 *src, unsigned int srclen, bool arch)
+static inline int crypto_poly1305_update(struct shash_desc *desc,
+					 const u8 *src, unsigned int srclen,
+					 bool arch)
 {
 	struct crypto_poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	unsigned int bytes;
 
 	/*
 	 * The key is passed as the first 32 "data" bytes.  The actual
 	 * poly1305_init() can be called only once the full key is available.
 	 */
 	if (dctx->keysize < POLY1305_KEY_SIZE) {
-		bytes = min(srclen, POLY1305_KEY_SIZE - dctx->keysize);
-		memcpy(&dctx->key[dctx->keysize], src, bytes);
-		dctx->keysize += bytes;
-		if (dctx->keysize < POLY1305_KEY_SIZE)
-			return 0;
-		if (arch)
-			poly1305_init(&dctx->base, dctx->key);
-		else
-			poly1305_init_generic(&dctx->base, dctx->key);
-		src += bytes;
-		srclen -= bytes;
+		if (!dctx->keysize) {
+			if (arch)
+				poly1305_block_init_arch(&dctx->base.state,
+							 src);
+			else
+				poly1305_block_init_generic(&dctx->base.state,
+							    src);
+		}
+		dctx->keysize += POLY1305_BLOCK_SIZE;
+		src += POLY1305_BLOCK_SIZE;
+		srclen -= POLY1305_BLOCK_SIZE;
+		if (srclen < POLY1305_BLOCK_SIZE)
+			return srclen;
+
+		memcpy(&dctx->base.s, src, POLY1305_BLOCK_SIZE);
+		dctx->keysize += POLY1305_BLOCK_SIZE;
+		src += POLY1305_BLOCK_SIZE;
+		srclen -= POLY1305_BLOCK_SIZE;
+		if (srclen < POLY1305_BLOCK_SIZE)
+			return srclen;
 	}
 
 	if (arch)
-		poly1305_update(&dctx->base, src, srclen);
+		poly1305_blocks_arch(&dctx->base.state, src, srclen, 1);
 	else
-		poly1305_update_generic(&dctx->base, src, srclen);
+		poly1305_blocks_generic(&dctx->base.state, src, srclen, 1);
 
-	return 0;
+	return srclen % POLY1305_BLOCK_SIZE;
 }
 
 static int crypto_poly1305_update_generic(struct shash_desc *desc,
@@ -74,29 +124,46 @@ static int crypto_poly1305_update_arch(struct shash_desc *desc,
 	return crypto_poly1305_update(desc, src, srclen, true);
 }
 
-static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst, bool arch)
+static inline int crypto_poly1305_finup(struct shash_desc *desc, const u8 *src,
+					unsigned int len, u8 *dst, bool arch)
 {
 	struct crypto_poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
 
 	if (unlikely(dctx->keysize != POLY1305_KEY_SIZE))
 		return -ENOKEY;
 
+	if (unlikely(len)) {
+		u8 block[POLY1305_BLOCK_SIZE] = {};
+
+		memcpy(block, src, len);
+		block[len] = 1;
+		if (arch)
+			poly1305_blocks_arch(&dctx->base.state, block,
+					     POLY1305_BLOCK_SIZE, 0);
+		else
+			poly1305_blocks_generic(&dctx->base.state, block,
+						POLY1305_BLOCK_SIZE, 0);
+		memzero_explicit(block, sizeof(block));
+	}
+
 	if (arch)
-		poly1305_final(&dctx->base, dst);
+		poly1305_emit_arch(&dctx->base.state.h, dst, dctx->base.s);
 	else
-		poly1305_final_generic(&dctx->base, dst);
-	memzero_explicit(&dctx->key, sizeof(dctx->key));
+		poly1305_emit_generic(&dctx->base.state.h, dst, dctx->base.s);
 	return 0;
 }
 
-static int crypto_poly1305_final_generic(struct shash_desc *desc, u8 *dst)
+static int crypto_poly1305_finup_generic(struct shash_desc *desc,
+					 const u8 *src, unsigned int len,
+					 u8 *dst)
 {
-	return crypto_poly1305_final(desc, dst, false);
+	return crypto_poly1305_finup(desc, src, len, dst, false);
 }
 
-static int crypto_poly1305_final_arch(struct shash_desc *desc, u8 *dst)
+static int crypto_poly1305_finup_arch(struct shash_desc *desc,
+				      const u8 *src, unsigned int len, u8 *dst)
 {
-	return crypto_poly1305_final(desc, dst, true);
+	return crypto_poly1305_finup(desc, src, len, dst, true);
 }
 
 static struct shash_alg poly1305_algs[] = {
@@ -104,24 +171,32 @@ static struct shash_alg poly1305_algs[] = {
 		.base.cra_name		= "poly1305",
 		.base.cra_driver_name	= "poly1305-generic",
 		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= POLY1305_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct crypto_poly1305_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= POLY1305_DIGEST_SIZE,
 		.init			= crypto_poly1305_init,
+		.setkey			= crypto_poly1305_setkey_generic,
 		.update			= crypto_poly1305_update_generic,
-		.final			= crypto_poly1305_final_generic,
+		.finup			= crypto_poly1305_finup_generic,
 		.descsize		= sizeof(struct crypto_poly1305_desc_ctx),
 	},
 	{
 		.base.cra_name		= "poly1305",
 		.base.cra_driver_name	= "poly1305-" __stringify(ARCH),
 		.base.cra_priority	= 300,
+		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_ALG_OPTIONAL_KEY,
 		.base.cra_blocksize	= POLY1305_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct crypto_poly1305_ctx),
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= POLY1305_DIGEST_SIZE,
 		.init			= crypto_poly1305_init,
+		.setkey			= crypto_poly1305_setkey_arch,
 		.update			= crypto_poly1305_update_arch,
-		.final			= crypto_poly1305_final_arch,
+		.finup			= crypto_poly1305_finup_arch,
 		.descsize		= sizeof(struct crypto_poly1305_desc_ctx),
 	},
 };
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index fe75320ff9a3..43ede1958a18 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -140,9 +140,12 @@
 
 /*
  * Transform masks and values (for crt_flags).
+ *
+ * The top three nibbles 0xfff00000 are reserved for the algorithm.
  */
 #define CRYPTO_TFM_NEED_KEY		0x00000001
 
+/* The top three nibbles 0xfff00000 are reserved for the algorithm. */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
 #define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
-- 
2.39.5

