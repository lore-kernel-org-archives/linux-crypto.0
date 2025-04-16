Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E176622D7B9
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785909; cv=none; b=fhPdxyxAbuZxCSscgB8tvpWRVh9zkOH5IcSu5pdA3EKONjG+H2RCPexKQzhhtEW56gkS37Ab8X+0WMzHa4AReurSWmdrtiNS1Kv3/X8VPt4A5s3RD5uBftJ3nR35dpl8wLRWLRLAAOGi/Uk7lqwAsgPST97WDpY5MLoTBc7NNPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785909; c=relaxed/simple;
	bh=zo8vsjwR51Z8AX/TJJt1mP3Y8CNNa41mTOchUgXUWTg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=KhJdr1Im7lVapFwB0DFiFCbtjHSibza8rlLdg4+9UGRW95cFX4mlVLIERS1BP+tfhdDedsyXR8ylsS1TuKa6tprv5aNk4nnZv79wYG0Tad4DpEL/djiKIta/h+0Ui5lHhKz++h5PnBLtysUjWgZYqDCs2esLv5jFRlNdIkuD9NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mMz2K1cb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mMz2K1cb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=za9mO/CF1fRrWa3XMDoFIw7RrmbeLat2DmIfS74+P24=; b=mMz2K1cbQSai7dwDKWgcNIvcYN
	QLJ3BzbzrMM/vMA9trbjRlCJiAdOLkQMEMRyt3gjReEYsyb8HfzhtJaUQS2yVazWCvhyG0XE+/J2D
	5Wfu9Tx/LM92wjtoLxOW5ubxUezdo4LNeNtjy9djMEsUyhG5K+BSW91K3XnK9CMIjnAiVHj8qBo0s
	OrBrTdn2isUCdyJQXvXsoktecEUjN5XlFnkG8K0WYtU3Ph1Xakp7wYyj7DTn//JtAHp0mUH2JSVmG
	EQLrAWe6r2XJa8MB4laTLXQNVArcAdGXH3VwV39A8Yei2y3b5JT86xrc+YzNo0gSWqhY6hJsc+B12
	LlcwyCZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wW8-00G6TK-15;
	Wed, 16 Apr 2025 14:45:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:45:04 +0800
Date: Wed, 16 Apr 2025 14:45:04 +0800
Message-Id: <7bebc68c7b41b83c50fbbf7253f47686947a6d4f.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 61/67] crypto: cbcmac - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ccm.c | 59 +++++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index a0610ff6ce02..f3f455e4908b 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -10,11 +10,12 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 
 struct ccm_instance_ctx {
 	struct crypto_skcipher_spawn ctr;
@@ -54,11 +55,6 @@ struct cbcmac_tfm_ctx {
 	struct crypto_cipher *child;
 };
 
-struct cbcmac_desc_ctx {
-	unsigned int len;
-	u8 dg[];
-};
-
 static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
 	struct aead_request *req)
 {
@@ -783,12 +779,10 @@ static int crypto_cbcmac_digest_setkey(struct crypto_shash *parent,
 
 static int crypto_cbcmac_digest_init(struct shash_desc *pdesc)
 {
-	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	int bs = crypto_shash_digestsize(pdesc->tfm);
+	u8 *dg = shash_desc_ctx(pdesc);
 
-	ctx->len = 0;
-	memset(ctx->dg, 0, bs);
-
+	memset(dg, 0, bs);
 	return 0;
 }
 
@@ -797,39 +791,34 @@ static int crypto_cbcmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 {
 	struct crypto_shash *parent = pdesc->tfm;
 	struct cbcmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
-	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_digestsize(parent);
+	u8 *dg = shash_desc_ctx(pdesc);
 
-	while (len > 0) {
-		unsigned int l = min(len, bs - ctx->len);
-
-		crypto_xor(&ctx->dg[ctx->len], p, l);
-		ctx->len +=l;
-		len -= l;
-		p += l;
-
-		if (ctx->len == bs) {
-			crypto_cipher_encrypt_one(tfm, ctx->dg, ctx->dg);
-			ctx->len = 0;
-		}
-	}
-
-	return 0;
+	do {
+		crypto_xor(dg, p, bs);
+		crypto_cipher_encrypt_one(tfm, dg, dg);
+		p += bs;
+		len -= bs;
+	} while (len >= bs);
+	return len;
 }
 
-static int crypto_cbcmac_digest_final(struct shash_desc *pdesc, u8 *out)
+static int crypto_cbcmac_digest_finup(struct shash_desc *pdesc, const u8 *src,
+				      unsigned int len, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
 	struct cbcmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
-	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_digestsize(parent);
+	u8 *dg = shash_desc_ctx(pdesc);
 
-	if (ctx->len)
-		crypto_cipher_encrypt_one(tfm, ctx->dg, ctx->dg);
-
-	memcpy(out, ctx->dg, bs);
+	if (len) {
+		crypto_xor(dg, src, len);
+		crypto_cipher_encrypt_one(tfm, out, dg);
+		return 0;
+	}
+	memcpy(out, dg, bs);
 	return 0;
 }
 
@@ -886,16 +875,16 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
 
 	inst->alg.digestsize = alg->cra_blocksize;
-	inst->alg.descsize = sizeof(struct cbcmac_desc_ctx) +
-			     alg->cra_blocksize;
+	inst->alg.descsize = alg->cra_blocksize;
 
+	inst->alg.base.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY;
 	inst->alg.base.cra_ctxsize = sizeof(struct cbcmac_tfm_ctx);
 	inst->alg.base.cra_init = cbcmac_init_tfm;
 	inst->alg.base.cra_exit = cbcmac_exit_tfm;
 
 	inst->alg.init = crypto_cbcmac_digest_init;
 	inst->alg.update = crypto_cbcmac_digest_update;
-	inst->alg.final = crypto_cbcmac_digest_final;
+	inst->alg.finup = crypto_cbcmac_digest_finup;
 	inst->alg.setkey = crypto_cbcmac_digest_setkey;
 
 	inst->free = shash_free_singlespawn_instance;
-- 
2.39.5

