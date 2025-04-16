Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EC42459DC
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785912; cv=none; b=XrlO+Y/1pSVhzbGLoJdgHpsaLo20FzKYmW8VBX3WwpvkwJdjmuhLVOW0X94sXeQj4PrPC2AikE/27GEcZzdAQLm4jD6EBiAm5mCVuVggK1AKiEbqNl05wocrcotZAkJxuIwj2AMGsMauxM5mJjBQmFcvrobuiUpmsF19xDTAsVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785912; c=relaxed/simple;
	bh=6mvU8fpTmGT0HkqqZuGpu9iMuXxwdDK7+T/2VIowkTQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=RFGmyslcfiXCkItANQnpZrMxC1Ob8yNCFfC7KS8k6R6FlpnGVyG2STnHXB2PFcKGWk1KCn9HmScQHDkqMLAM9+1DVtxM8fGoiONv3OhxI5a6IU5PVJ3ChWPANmX8NW+vaP5pd6aLU7/nV+yMSMln7X5/Mzla+lFN/G26Kgxpx0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sSPuLkPP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sSPuLkPP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Lei4oiAlMxMRMszs7W37Sq8JqffuFwfF0gn2jhmCkrs=; b=sSPuLkPP6+Bf8r4VXF2TsPdSJa
	pBn14FplJfV6ZcemcUCE911QI0bkU6xjbHNmgI6caEgNfKppfn6ccsj2ZoZqwC3WKhfQbJWFinZ25
	iejr2MUF8muUNw9Yu3zYEAbn6hmhp6miNPOpH8kz33dJa1/7MWVEwckOxBdZe5mGNqlR1fkPi9G8m
	6aoGCQUrXGsPvKkdyWps7lEYovHe27a1TViA2z/YL6ddU9KvMbN1NszZkypoSHxlUpbT1HVfYoLLo
	o87D0Beh0ijtnGHEwAbXXlMqRzsYF1E5rifFFYYlBwJE9AWJn8BeyhzOzEaBnw9FPI/gpofL2dBc3
	CBSH4iiQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wWA-00G6Tu-29;
	Wed, 16 Apr 2025 14:45:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:45:06 +0800
Date: Wed, 16 Apr 2025 14:45:06 +0800
Message-Id: <7b5fa584e845a66571ee78a7bb4e85573bd70b33.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 62/67] crypto: cmac - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/cmac.c | 92 ++++++++++-----------------------------------------
 1 file changed, 18 insertions(+), 74 deletions(-)

diff --git a/crypto/cmac.c b/crypto/cmac.c
index c66a0f4d8808..f297042a324b 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -13,9 +13,12 @@
 
 #include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
+#include <crypto/utils.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 /*
  * +------------------------
@@ -31,22 +34,6 @@ struct cmac_tfm_ctx {
 	__be64 consts[];
 };
 
-/*
- * +------------------------
- * | <shash desc>
- * +------------------------
- * | cmac_desc_ctx
- * +------------------------
- * | odds (block size)
- * +------------------------
- * | prev (block size)
- * +------------------------
- */
-struct cmac_desc_ctx {
-	unsigned int len;
-	u8 odds[];
-};
-
 static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
 				     const u8 *inkey, unsigned int keylen)
 {
@@ -102,13 +89,10 @@ static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
 
 static int crypto_cmac_digest_init(struct shash_desc *pdesc)
 {
-	struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	int bs = crypto_shash_blocksize(pdesc->tfm);
-	u8 *prev = &ctx->odds[bs];
+	u8 *prev = shash_desc_ctx(pdesc);
 
-	ctx->len = 0;
 	memset(prev, 0, bs);
-
 	return 0;
 }
 
@@ -117,77 +101,36 @@ static int crypto_cmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 {
 	struct crypto_shash *parent = pdesc->tfm;
 	struct cmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
-	struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
-	u8 *odds = ctx->odds;
-	u8 *prev = odds + bs;
+	u8 *prev = shash_desc_ctx(pdesc);
 
-	/* checking the data can fill the block */
-	if ((ctx->len + len) <= bs) {
-		memcpy(odds + ctx->len, p, len);
-		ctx->len += len;
-		return 0;
-	}
-
-	/* filling odds with new data and encrypting it */
-	memcpy(odds + ctx->len, p, bs - ctx->len);
-	len -= bs - ctx->len;
-	p += bs - ctx->len;
-
-	crypto_xor(prev, odds, bs);
-	crypto_cipher_encrypt_one(tfm, prev, prev);
-
-	/* clearing the length */
-	ctx->len = 0;
-
-	/* encrypting the rest of data */
-	while (len > bs) {
+	do {
 		crypto_xor(prev, p, bs);
 		crypto_cipher_encrypt_one(tfm, prev, prev);
 		p += bs;
 		len -= bs;
-	}
-
-	/* keeping the surplus of blocksize */
-	if (len) {
-		memcpy(odds, p, len);
-		ctx->len = len;
-	}
-
-	return 0;
+	} while (len >= bs);
+	return len;
 }
 
-static int crypto_cmac_digest_final(struct shash_desc *pdesc, u8 *out)
+static int crypto_cmac_digest_finup(struct shash_desc *pdesc, const u8 *src,
+				    unsigned int len, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
 	struct cmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
-	struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
-	u8 *odds = ctx->odds;
-	u8 *prev = odds + bs;
+	u8 *prev = shash_desc_ctx(pdesc);
 	unsigned int offset = 0;
 
-	if (ctx->len != bs) {
-		unsigned int rlen;
-		u8 *p = odds + ctx->len;
-
-		*p = 0x80;
-		p++;
-
-		rlen = bs - ctx->len - 1;
-		if (rlen)
-			memset(p, 0, rlen);
-
+	crypto_xor(prev, src, len);
+	if (len != bs) {
+		prev[len] ^= 0x80;
 		offset += bs;
 	}
-
-	crypto_xor(prev, odds, bs);
 	crypto_xor(prev, (const u8 *)tctx->consts + offset, bs);
-
 	crypto_cipher_encrypt_one(tfm, out, prev);
-
 	return 0;
 }
 
@@ -269,13 +212,14 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
 	inst->alg.base.cra_ctxsize = sizeof(struct cmac_tfm_ctx) +
 				     alg->cra_blocksize * 2;
+	inst->alg.base.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				   CRYPTO_AHASH_ALG_FINAL_NONZERO;
 
 	inst->alg.digestsize = alg->cra_blocksize;
-	inst->alg.descsize = sizeof(struct cmac_desc_ctx) +
-			     alg->cra_blocksize * 2;
+	inst->alg.descsize = alg->cra_blocksize;
 	inst->alg.init = crypto_cmac_digest_init;
 	inst->alg.update = crypto_cmac_digest_update;
-	inst->alg.final = crypto_cmac_digest_final;
+	inst->alg.finup = crypto_cmac_digest_finup;
 	inst->alg.setkey = crypto_cmac_digest_setkey;
 	inst->alg.init_tfm = cmac_init_tfm;
 	inst->alg.clone_tfm = cmac_clone_tfm;
-- 
2.39.5

